# Example: Action Design Patterns

## CRUD Actions with Explicit Accept

```elixir
actions do
  defaults [:read, :destroy]

  create :create do
    accept [:name, :price_cents, :description, :cover_image_url, :category_id]
  end

  update :update do
    # Never accept :category_id in update -- products don't change category
    accept [:name, :price_cents, :description, :cover_image_url]
  end
end
```

## Search Action with Argument, Filter, Pagination

```elixir
read :search do
  description "List categories, optionally filtering by name."

  argument :query, :ci_string do
    description "Return only categories with names including the given value."
    constraints allow_empty?: true
    default ""
  end

  filter expr(contains(name, ^arg(:query)))
  pagination offset?: true, default_limit: 12
  prepare build(load: [:product_count, :featured_product_name])
end
```

## Scoped Read with Actor Filter

```elixir
read :for_user do
  prepare build(load: [product: [:category]], sort: [inserted_at: :desc])
  filter expr(user_id == ^actor(:id))
end
```

## Streamable Read with Keyset Pagination

```elixir
read :for_category do
  argument :category_id, :uuid, allow_nil?: false
  filter expr(category_id == ^arg(:category_id))
  pagination keyset?: true, required?: false
end
```

## Update with Change Module and Conditional

```elixir
update :update do
  accept [:name, :description]
  change MyApp.Catalog.Changes.TrackPreviousNames, where: [changing(:name)]
end
```

## Update with manage_relationship

```elixir
update :update do
  accept [:name, :price_cents, :description, :cover_image_url]
  require_atomic? false    # required for manage_relationship
  argument :variants, {:array, :map}
  change manage_relationship(:variants, type: :direct_control, order_is_key: :position)
end
```

## Create with append_and_remove (verify related record exists + authorized)

```elixir
create :create do
  accept [:name, :price_cents, :description, :cover_image_url]
  argument :category_id, :uuid, allow_nil?: false
  change manage_relationship(:category_id, :category, type: :append_and_remove)
end
```

## Destroy with Cascade

```elixir
destroy :destroy do
  primary? true
  change cascade_destroy(:notifications,
    return_notifications?: true,
    after_action?: false       # delete children BEFORE parent to avoid FK violation
  )
end
```

## Destroy with Filter (for join resources without primary key lookup)

```elixir
destroy :destroy do
  argument :product_id, :uuid, allow_nil?: false
  change filter(expr(
    product_id == ^arg(:product_id) && user_id == ^actor(:id)
  ))
end
```

## Action with Argument-to-Attribute Change

```elixir
create :create do
  primary? true
  accept [:position, :name, :product_id]
  argument :weight, :string, allow_nil?: false
  change MyApp.Catalog.Changes.ParseWeight, only_when_valid?: true
end
```

## Atomic Update with Counter

```elixir
update :increment_views do
  change atomic_update(:view_count, expr(view_count + 1))
end

update :decrement_stock do
  change atomic_update(:stock_count, expr(stock_count - 1))
end
```

## Change Module with atomic/3 Callback

```elixir
defmodule MyApp.Catalog.Changes.TrackPreviousNames do
  use Ash.Resource.Change

  # In-memory fallback
  @impl true
  def change(changeset, _opts, _context) do
    new_name = Ash.Changeset.get_attribute(changeset, :name)
    previous_name = Ash.Changeset.get_data(changeset, :name)
    previous_names = Ash.Changeset.get_data(changeset, :previous_names)

    names =
      [previous_name | previous_names]
      |> Enum.uniq()
      |> Enum.reject(&(&1 == new_name))

    Ash.Changeset.change_attribute(changeset, :previous_names, names)
  end

  # Database-side atomic version
  @impl true
  def atomic(_changeset, _opts, _context) do
    {:atomic,
     %{
       previous_names:
         {:atomic,
          expr(
            fragment(
              "array_remove(array_prepend(?, ?), ?)",
              name,              # current DB value
              previous_names,    # current DB value
              ^atomic_ref(:name) # value AFTER other changes in this action
            )
          )}
     }}
  end
end
```

## Calculation Module with Both expression/2 and calculate/3

```elixir
defmodule MyApp.Catalog.Calculations.FormatPrice do
  use Ash.Resource.Calculation

  # Runs in database when loaded alongside data fetch
  @impl true
  def expression(_opts, _context) do
    expr(
      fragment("'$' || to_char(? / 100.0, 'FM999990.00')", price_cents)
    )
  end

  # Runs in Elixir when loaded on existing record with reuse_values?
  @impl true
  def calculate(records, _opts, _context) do
    Enum.map(records, fn %{price_cents: cents} ->
      "$#{:erlang.float_to_binary(cents / 100, decimals: 2)}"
    end)
  end
end
```

## Generic Action

```elixir
action :export_csv, :string do
  argument :format, :atom do
    constraints one_of: [:full, :summary]
    default :summary
  end

  run fn input, _context ->
    format = input.arguments.format
    # ... generate CSV string ...
    {:ok, csv_content}
  end
end
```

## Key Rules

- **`accept` is security** -- never accept attributes the user shouldn't control
- **`require_atomic? false`** only when unavoidable (manage_relationship, imperative changes)
- **`primary? true`** on create/update actions used by `manage_relationship`
- **`order_is_key`** uses zero-based indexing
- **`only_when_valid?`** prevents changes from running on invalid changesets
- **`after_action?: false`** on cascade_destroy deletes children before parent
- **`atomic_ref(:name)`** = value after changes; bare `name` = current DB value
- **`Ash.Changeset.get_data/2`** for current/old value; `get_attribute/2` for change-or-fallback
