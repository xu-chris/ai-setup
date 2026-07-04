# Example: Porting Ecto Code to Ash

## Problem: Raw Ecto Reads on Ash Resources

Domain uses `Repo.all` with joins on resources already registered as Ash.

## Before (Ecto)

```elixir
defmodule MyApp.Orders do
  def list_orders_for_account(account_ids) do
    Order
    |> join(:inner, [o], p in Project, on: o.project_id == p.id)
    |> where([o, p], p.account_id in ^account_ids)
    |> preload([o], [:line_items, :shipping_method])
    |> Repo.all()
  end
end
```

## After (Ash)

```elixir
# Add policy to the resource
defmodule MyApp.Orders.Order do
  # ... existing resource ...

  policies do
    bypass actor_attribute_equals(:role, :admin) do
      authorize_if always()
    end

    policy action_type(:read) do
      authorize_if expr(
        exists(project, account_id in ^actor(:account_ids))
      )
    end
  end
end

# Add code interface to the domain
defmodule MyApp.Orders do
  resources do
    resource MyApp.Orders.Order do
      define :list_orders, action: :read
    end
  end
end

# Call via code interface (policies auto-filter by account)
MyApp.Orders.list_orders!(
  load: [:line_items, :shipping_method],
  actor: current_user
)
```

## Problem: Ecto Changesets on Ash Resources

Resource defines Ash actions but domain uses `Ecto.Changeset` + `Repo.insert`.

## Before (Ecto)

```elixir
defmodule MyApp.Support do
  def create_ticket(attrs) do
    %Ticket{id: Ash.UUIDv7.generate()}
    |> Ticket.changeset(attrs)
    |> Repo.insert()
  end

  def update_ticket(ticket, attrs) do
    ticket
    |> Ticket.changeset(attrs)
    |> Repo.update()
  end
end
```

## After (Ash)

```elixir
# Ensure the resource has proper actions defined
defmodule MyApp.Support.Ticket do
  actions do
    create :create do
      accept [:title, :description, :severity, :project_id]
    end

    update :update do
      accept [:title, :description, :severity, :status]
    end
  end
end

# Add code interfaces to the domain
defmodule MyApp.Support do
  resources do
    resource MyApp.Support.Ticket do
      define :create_ticket, action: :create
      define :update_ticket, action: :update
    end
  end
end

# Call via code interface
MyApp.Support.create_ticket!(attrs, actor: current_user)
MyApp.Support.update_ticket!(ticket, attrs, actor: current_user)
```

## Problem: Manual Scope Filtering

Every read function manually joins through Project to filter by account.

## Before (Ecto)

```elixir
def list_tasks_for_account(account_ids) do
  Task
  |> join(:inner, [t], p in Project, on: t.project_id == p.id)
  |> where([t, p], p.account_id in ^account_ids)
  |> Repo.all()
end
```

## After (Ash with Policy)

```elixir
# On the resource, add a policy that filters by account
policies do
  policy action_type(:read) do
    authorize_if expr(
      exists(project, account_id in ^actor(:account_ids))
    )
  end
end

# Now just call the read action -- policy auto-filters
MyApp.Projects.list_tasks!(actor: current_user)
```

## Problem: Manual PubSub Broadcast

Domain uses `Phoenix.PubSub.broadcast` instead of Ash notifiers.

## Before (Manual)

```elixir
def update_ticket(ticket, attrs) do
  result = Repo.update(changeset)

  case result do
    {:ok, updated} ->
      Phoenix.PubSub.broadcast(MyApp.PubSub, "tickets:#{updated.project_id}",
        {:ticket_updated, updated})
      {:ok, updated}

    error -> error
  end
end
```

## After (Ash Notifier)

```elixir
# On the resource
defmodule MyApp.Support.Ticket do
  use Ash.Resource,
    notifiers: [Ash.Notifier.PubSub]

  pub_sub do
    prefix "tickets"
    module MyAppWeb.Endpoint
    publish :update, [:project_id]

    transform fn notification ->
      Map.take(notification.data, [:id, :project_id, :status])
    end
  end
end
```

## Problem: Repo.exists? on Ash Resources

```elixir
# Before
def member_exists?(account_id, user_id) do
  Repo.exists?(
    from m in Member,
      where: m.account_id == ^account_id and m.user_id == ^user_id
  )
end

# After -- use Ash.exists? or count
def member_exists?(account_id, user_id) do
  Member
  |> Ash.Query.filter(account_id == ^account_id and user_id == ^user_id)
  |> Ash.exists?()
end
```

## Problem: Repo.get_by on Ash Resources

```elixir
# Before
Repo.get_by(Account, id: account_id)

# After -- define a code interface with get_by
# In the domain:
define :get_account, action: :read, get_by: [:id]

# Call:
MyApp.Accounts.get_account!(account_id)
```

## Porting Checklist

- Replace `Repo.all(from ...)` with `Ash.Query.filter` + `Ash.read!` or code interface
- Replace `Ecto.Changeset` + `Repo.insert/update` with code interface calls
- Replace `Repo.exists?` with `Ash.exists?`
- Replace `Repo.get_by` with code interface using `get_by: [:id]` (list form)
- Replace manual `Phoenix.PubSub.broadcast` with `Ash.Notifier.PubSub`
- Replace manual join-based scope checks with Ash policies using `exists/2`
- Add `authorizers: [Ash.Policy.Authorizer]` to resources without it
- Add `actor:` to all action calls
- Keep `Ecto.Multi` for complex multi-step transactions
- Keep raw SQL for analytics/reporting queries
