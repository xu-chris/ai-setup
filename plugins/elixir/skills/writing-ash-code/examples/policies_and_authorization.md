# Example: Policies and Authorization

## Admin Bypass + Role-Based Access

```elixir
policies do
  # Bypass: admin can do everything (OR logic -- skips all other policies)
  bypass actor_attribute_equals(:role, :admin) do
    authorize_if always()
  end

  # Standard: editors can create
  policy action(:create) do
    authorize_if actor_attribute_equals(:role, :editor)
  end

  # Standard: ownership check for update/destroy
  policy action_type([:update, :destroy]) do
    authorize_if expr(
      ^actor(:role) == :editor and created_by_id == ^actor(:id)
    )
  end

  # Standard: anyone can read
  policy action_type(:read) do
    authorize_if always()
  end
end
```

## Authentication Resource Policies

```elixir
policies do
  # Allow AshAuthentication's internal action calls
  bypass AshAuthentication.Checks.AshAuthenticationInteraction do
    authorize_if always()
  end

  # Public registration and sign-in
  policy action([:register_with_password, :sign_in_with_password]) do
    authorize_if always()
  end

  # Everything else forbidden by default (hidden forbid_if always())
end
```

## AshOban Bypass

```elixir
policies do
  bypass AshOban.Checks.AshObanInteraction do
    authorize_if always()
  end

  # ... rest of policies
end
```

## Forbid Pattern (block specific conditions)

```elixir
policy action(:publish) do
  forbid_if expr(published == true)   # already published = forbidden
  authorize_if actor_attribute_equals(:role, :admin)
end
```

## Child Resource with accessing_from

```elixir
# Variants are only manageable through their parent Product
policies do
  policy always() do
    authorize_if accessing_from(MyApp.Catalog.Product, :variants)
    authorize_if action_type(:read)
  end
end
```

## Read Policies as Filters (user-scoped data)

```elixir
# Read policies don't forbid -- they filter which records are returned
policy action_type(:read) do
  authorize_if expr(user_id == ^actor(:id))   # only see your own data
  authorize_if actor_attribute_equals(:role, :admin)  # admins see all
end
```

## Strict Read Policies (hard deny instead of filter)

```elixir
policies do
  # Forces 403 instead of empty results when unauthorized
  access_type :strict

  policy action_type(:read) do
    authorize_if relates_to_actor_via(:owner)
  end
end
```

## Using exists/2 in Policy Expressions

```elixir
# Recommended over direct relationship references in expressions
policy action_type(:read) do
  authorize_if expr(
    exists(project, account_id in ^actor(:account_ids))
  )
end
```

## Policy Groups (shared condition)

```elixir
policy_group actor_attribute_equals(:role, :editor) do
  policy action(:create) do
    authorize_if always()
  end

  policy action_type(:update) do
    authorize_if relates_to_actor_via(:created_by)
  end
end
```

## Field Policies

```elixir
field_policies do
  # Default: all fields visible
  field_policy :* do
    authorize_if always()
  end

  # Sensitive field restricted to admins
  field_policy :internal_cost do
    authorize_if actor_attribute_equals(:role, :admin)
  end

  # SSN only visible to owner
  field_policy :ssn do
    authorize_if relates_to_actor_via(:user)
  end
end
```

## Reusable Policy Logic via Calculations

```elixir
# Define once on Product
calculations do
  calculate :can_manage?, :boolean,
    expr(
      ^actor(:role) == :admin or
      (^actor(:role) == :editor and created_by_id == ^actor(:id))
    )
end

# Use in Product policies
policy action_type([:update, :destroy]) do
  authorize_if expr(can_manage?)
end

# Reuse in Review policies (cross-resource via relationship)
policy action(:destroy) do
  authorize_if expr(product.can_manage?)
  authorize_if relates_to_actor_via(:user)
end
```

## Internal-Only Action (forbid external access)

```elixir
# For actions only called internally with authorize?: false
policy action(:create) do
  forbid_if always()
end
```

## Actor Tracking via Global Changes

```elixir
changes do
  change relate_actor(:created_by, allow_nil?: true), on: [:create]
  change relate_actor(:updated_by, allow_nil?: true)
end
```

## Enum Type for Roles

```elixir
defmodule MyApp.Accounts.Role do
  use Ash.Type.Enum, values: [:admin, :editor, :user]
end
```

## Using can_*? in LiveView Templates

```heex
<.button_link
  :if={MyApp.Catalog.can_create_product?(@current_user)}
  navigate={~p"/products/new"}>
  New Product
</.button_link>

<.button_link
  :if={MyApp.Catalog.can_destroy_product?(@current_user, @product)}
  kind="error"
  phx-click="destroy-product"
  data-confirm={"Delete #{@product.name}?"}>
  Delete
</.button_link>
```

## Key Rules

- **Bypass policies first**, standard policies after -- order matters: a failing standard policy BEFORE a passing bypass still fails
- **Bypass = OR**, standard = AND in the SAT solver
- **Check order matters** within a policy (like `cond`)
- **Debug** with `config :ash, policies: [show_policy_breakdowns?: true]` in dev
- **`run_queries?: false, maybe_is: false`** on `can_*?` in LiveView templates to avoid DB queries per render
- **Read policies filter**, they don't forbid -- use `access_type :strict` for hard deny
- **`exists/2`** is strongly recommended over direct relationship references in expressions
- **Expression limitations on create** -- cannot reference data being created; use argument-based checks
- **`relates_to_actor_via`** checks ownership through a relationship
- **`accessing_from`** authorizes child records accessed through parent
- **`^actor(:field)`** references actor attributes inside `expr()`
- **`allow_nil?: true`** on `relate_actor` is needed for seeds/system actions without actors
- **Pass `actor:` everywhere** -- in code interfaces, forms, LiveView handlers
