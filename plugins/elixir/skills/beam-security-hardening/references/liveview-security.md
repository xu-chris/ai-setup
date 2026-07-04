# Phoenix LiveView Security Model

Source: Phoenix LiveView guide "Security considerations" (hexdocs.pm/phoenix_live_view/security-model.html).

**The core fact:** a LiveView begins life as a regular HTTP request, then establishes a stateful connection. Both receive client data via params and session. **Any session validation must therefore happen twice: in the HTTP request (plug pipeline) AND in the stateful connection (LiveView `mount`).**

---

## 1. Authentication vs authorization

- **Authentication** = identifying the user (email/password, third-party OAuth). A token identifying the user is stored in the session cookie. Phoenix validates the session automatically; `mix phx.gen.auth` generates the building blocks.
- **Authorization** = deciding whether the identified user may access a resource or perform an action. Rules are domain-specific.
- LiveViews share authentication logic with regular requests **through plugs** (endpoint → router → plug pipeline stores user info in the session).
- Once authenticated: validate the session in the `mount` callback. Authorization runs on `mount` ("may the user see this page?") **and** on `handle_event` ("may the user delete this item?").

## 2. `live_session`

`Phoenix.LiveView.Router.live_session/2` groups LiveViews. Navigation **within** the same `live_session` skips the regular HTTP request - it does **not** go through the plug pipeline. Navigation **across** live sessions goes through the router (full page navigation, brand-new live connection).

Consequences:
- Plugs (`pipe_through`) protect only the initial request and regular routes (get/post). They do not protect live navigation within a session.
- LiveViews must run their own checks in `mount` or via `on_mount` hooks.
- Pair each `live_session` with a plug pipeline that performs the **same** checks, tailored to plug. If a live session has no regular web requests under it, the `pipe_through` checks are unnecessary.

Declare the hook once at the router level instead of per LiveView:

```elixir
scope "/" do
  pipe_through [:authenticate_user]

  live_session :default, on_mount: MyAppWeb.UserLiveAuth do
    live ...
  end
end

scope "/admin" do
  pipe_through [:authenticate_admin]

  live_session :admin, on_mount: MyAppWeb.AdminLiveAuth do
    live ...
  end
end
```

Use `live_session` to draw boundaries between **authentication** domains (different user types, e.g. users vs admins with HTTP auth) or to change `:root_layout`. Using it to separate mere *authorization* rules causes frequent page reloads - keep authorization in `mount`/`handle_event` instead.

## 3. Mounting considerations

`mount/3` is invoked on both the initial HTTP mount and the connected mount - authorization there covers all scenarios. Re-execute the same verifications your plugs perform (e.g. `:ensure_user_authenticated`, `:ensure_user_confirmed`).

Encapsulate in an `on_mount` hook:

```elixir
defmodule MyAppWeb.UserLiveAuth do
  import Phoenix.Component
  import Phoenix.LiveView
  alias MyAppWeb.Accounts

  def on_mount(:default, _params, %{"user_token" => user_token} = _session, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        Accounts.get_user_by_session_token(user_token)
      end)

    if socket.assigns.current_user.confirmed_at do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/login")}
    end
  end
end
```

- `assign_new/3` avoids refetching `current_user` across parent-child LiveViews.
- Attach the hook via `live_session :name, on_mount: ...` (router), `on_mount MyAppWeb.UserLiveAuth` (per LiveView), or in `def live_view` inside the web module to apply to all LiveViews by default.
- Reading the user from session is typically a single database lookup in both plug and `on_mount`.

## 4. Events considerations

**Always verify permissions on the server for every action.** Hiding a delete button in the UI is not authorization - a savvy user can talk to the server directly and request the action anyway.

Most actions arrive in `handle_event` - authorize there, by passing the current user to the context function that enforces the rule:

```elixir
def handle_event("delete_project", %{"project_id" => project_id}, socket) do
  Project.delete!(socket.assigns.current_user, project_id)
  {:noreply, update(socket, :projects, &Enum.reject(&1, fn p -> p.id == project_id end))}
end
```

Raising on unauthorized access is fine - legitimate users never trigger that code path. Authorization rules live in context modules (domain logic), same as for regular requests. (In this project: thread `scope:` through Ash actions; policies enforce the rules.)

## 5. Disconnecting all instances of a live user

A LiveView is a **permanent connection**. Logout or access revocation does not affect already-connected LiveViews until the page reloads - unless you disconnect them.

Set a `live_socket_id` in the session at login:

```elixir
conn
|> put_session(:current_user_id, user.id)
|> put_session(:live_socket_id, "users_socket:#{user.id}")
```

Then force-disconnect every LiveView for that user (on logout, ban, permission change):

```elixir
MyAppWeb.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
```

- `mix phx.gen.auth` already generates this (keyed by `user_token` instead of `user_id`).
- After disconnect, the client reconnects and re-runs `mount/3`; a no-longer-authorized user fails mount and is redirected.
- The same mechanism works for `Phoenix.Channel` - use it for any stateful connection.

## 6. Summing up

- **Validate twice:** plug pipeline for the HTTP request, `mount`/`on_mount` for the stateful connection.
- **`live_session`** draws authentication boundaries (and root-layout changes); crossing it forces full page navigation.
- **Authentication** lives in the regular request pipeline (shared with controllers); the session stores the user; plugs read it for requests, `on_mount` reads it for LiveViews.
- **Authorization** runs in `mount` (page access) and in `handle_event` (actions), enforced in context modules server-side - never trust the UI to hide capabilities.
- **Revocation** requires `live_socket_id` + `Endpoint.broadcast(..., "disconnect", ...)` because live connections outlive session changes.
