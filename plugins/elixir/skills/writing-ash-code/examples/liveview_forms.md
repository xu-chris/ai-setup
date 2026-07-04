# Example: LiveView Integration

## Create Form with Authorization

```elixir
def mount(_params, _session, socket) do
  form =
    MyApp.Catalog.form_to_create_category(actor: socket.assigns.current_user)
    |> AshPhoenix.Form.ensure_can_submit!()

  {:ok, assign(socket, form: to_form(form), page_title: "New Category")}
end
```

## Edit Form (mount head must come BEFORE create)

```elixir
# This head MUST come BEFORE the create mount
def mount(%{"id" => category_id}, _session, socket) do
  category = MyApp.Catalog.get_category_by_id!(category_id)

  form =
    MyApp.Catalog.form_to_update_category(category,
      actor: socket.assigns.current_user)
    |> AshPhoenix.Form.ensure_can_submit!()

  {:ok, assign(socket, form: to_form(form), page_title: "Update Category")}
end

def mount(_params, _session, socket) do
  form =
    MyApp.Catalog.form_to_create_category(actor: socket.assigns.current_user)
    |> AshPhoenix.Form.ensure_can_submit!()

  {:ok, assign(socket, form: to_form(form), page_title: "New Category")}
end
```

## Validate Handler

```elixir
def handle_event("validate", %{"form" => form_data}, socket) do
  socket =
    update(socket, :form, fn form ->
      AshPhoenix.Form.validate(form, form_data)
      |> to_form()
    end)

  {:noreply, socket}
end
```

## Submit Handler

```elixir
def handle_event("save", %{"form" => form_data}, socket) do
  case AshPhoenix.Form.submit(socket.assigns.form, params: form_data) do
    {:ok, category} ->
      socket =
        socket
        |> put_flash(:info, "Category saved successfully")
        |> push_navigate(to: ~p"/categories/#{category}")

      {:noreply, socket}

    {:error, form} ->
      {:noreply,
       socket
       |> put_flash(:error, "Could not save category data")
       |> assign(:form, form)}
  end
end
```

## Destroy Handler

```elixir
def handle_event("destroy-product", _params, socket) do
  case MyApp.Catalog.destroy_product(socket.assigns.product,
         actor: socket.assigns.current_user) do
    :ok ->
      {:noreply,
       socket
       |> put_flash(:info, "Product deleted")
       |> push_navigate(to: ~p"/")}

    {:error, _error} ->
      {:noreply, put_flash(socket, :error, "Could not delete product")}
  end
end
```

## Nested Forms (Product with Variants)

```elixir
# Mount: form_to_create_product takes category_id as first arg (from forms block)
def mount(%{"category_id" => category_id}, _session, socket) do
  form =
    MyApp.Catalog.form_to_create_product(category_id,
      actor: socket.assigns.current_user)
    |> AshPhoenix.Form.ensure_can_submit!()

  {:ok, assign(socket, form: to_form(form))}
end

# Add nested form
def handle_event("add-variant", _params, socket) do
  socket =
    update(socket, :form, fn form ->
      AshPhoenix.Form.add_form(form, :variants)
    end)

  {:noreply, socket}
end

# Remove nested form by path (form[variants][2])
def handle_event("remove-variant", %{"path" => path}, socket) do
  socket =
    update(socket, :form, fn form ->
      AshPhoenix.Form.remove_form(form, path)
    end)

  {:noreply, socket}
end

# Reorder nested forms (drag and drop)
def handle_event("reorder-variants", %{"order" => order}, socket) do
  socket =
    update(socket, :form, fn form ->
      AshPhoenix.Form.sort_forms(form, [:variants], order)
    end)

  {:noreply, socket}
end
```

## Nested Form Options

```elixir
# sparse? -- only sends changed fields (for partial updates)
AshPhoenix.Form.for_update(product,
  forms: [variants: [sparse?: true]],
  actor: user
)

# data -- pre-load existing nested data
AshPhoenix.Form.for_update(product,
  forms: [variants: [data: product.variants]],
  actor: user
)

# transform_errors -- custom error formatting
AshPhoenix.Form.for_create(MyApp.Catalog.Product, :create,
  transform_errors: fn changeset, errors ->
    Enum.map(errors, fn {field, message, vars} ->
      {field, "Custom: #{message}", vars}
    end)
  end,
  actor: user
)
```

## Search with Pagination via URL Params

```elixir
def handle_params(params, _url, socket) do
  query_text = Map.get(params, "q", "")
  sort_by = Map.get(params, "sort_by") |> validate_sort_by()
  page_params = AshPhoenix.LiveView.page_from_params(params, 12)

  page =
    MyApp.Catalog.search_categories!(query_text,
      page: page_params,
      query: [sort_input: sort_by],
      actor: socket.assigns.current_user
    )

  {:noreply,
   socket
   |> assign(:query_text, query_text)
   |> assign(:sort_by, sort_by)
   |> assign(:page, page)}
end

# Pagination in template
# AshPhoenix.LiveView.prev_page?(@page) -> boolean
# AshPhoenix.LiveView.next_page?(@page) -> boolean
# AshPhoenix.LiveView.page_link_params(@page, "prev") -> keyword list
```

## PubSub Subscribe in Mount

```elixir
def mount(_params, _session, socket) do
  if connected?(socket) do
    MyAppWeb.Endpoint.subscribe("notifications:#{socket.assigns.current_user.id}")
  end

  notifications = MyApp.Accounts.notifications_for_user!(
    actor: socket.assigns.current_user
  )

  {:ok, assign(socket, notifications: notifications)}
end

def handle_info(%{topic: "notifications:" <> _}, socket) do
  notifications = MyApp.Accounts.notifications_for_user!(
    actor: socket.assigns.current_user
  )

  {:noreply, assign(socket, notifications: notifications)}
end
```

## on_mount Role Checking

```elixir
# In router.ex -- restrict live_session to specific roles
live_session :admin_only,
  on_mount: [
    {MyAppWeb.LiveUserAuth, :ensure_authenticated},
    {MyAppWeb.LiveUserAuth, {:role_required, :admin}}
  ] do
  live "/admin/dashboard", AdminDashboardLive
end

# In the on_mount module
def on_mount({:role_required, required_role}, _params, _session, socket) do
  if socket.assigns.current_user.role == required_role do
    {:cont, socket}
  else
    {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/")}
  end
end
```

## manage_relationship Resource-Side Setup

```elixir
# The CHILD resource (Variant) must have primary? true on actions
# Ash uses these when managing through the parent
actions do
  create :create do
    primary? true
    accept [:name, :price_cents, :position]
  end

  update :update do
    primary? true
    accept [:name, :price_cents, :position]
  end

  destroy :destroy do
    primary? true
  end
end
```

## Key Rules

- **Always pass `actor:`** to form creation and domain calls
- **Always call `ensure_can_submit!/1`** after creating forms
- **Mount head ordering matters** -- edit (`%{"id" => id}`) before create (`_params`)
- **`to_form/1`** converts AshPhoenix.Form to Phoenix form for templates -- always pipe validate results through `to_form/1`
- **Nested form path** format: `form[variants][2]` (zero-indexed)
- **`sort_forms/3`** for drag-and-drop reordering
- **`sparse?`** for partial nested updates (only sends changed fields)
- **PubSub subscribe** only inside `if connected?(socket)` guard
