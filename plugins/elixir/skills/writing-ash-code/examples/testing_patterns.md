# Example: Testing Patterns

## Test Configuration

```elixir
# config/test.exs
config :ash, :disable_async?, true
config :ash, :missed_notifications, :ignore
config :my_app, Oban, testing: :manual
```

## Generator Module

```elixir
defmodule MyApp.Generator do
  use Ash.Generator

  def user(opts \\ []) do
    changeset_generator(
      MyApp.Accounts.User,
      :register_with_password,
      defaults: [
        email: sequence(:user_email, &"user#{&1}@example.com"),
        password: "password",
        password_confirmation: "password"
      ],
      overrides: opts,
      after_action: fn user ->
        role = opts[:role] || :user
        MyApp.Accounts.set_user_role!(user, role, authorize?: false)
      end
    )
  end

  def category(opts \\ []) do
    actor = opts[:actor] || once(:default_actor, fn ->
      generate(user(role: :admin))
    end)

    after_action =
      if opts[:product_count] do
        fn category ->
          generate_many(product(category_id: category.id), opts[:product_count])
          Ash.load!(category, :products)
        end
      end

    changeset_generator(
      MyApp.Catalog.Category,
      :create,
      defaults: [name: sequence(:category_name, &"Category #{&1}")],
      actor: actor,
      overrides: opts,
      after_action: after_action
    )
  end

  def product(opts \\ []) do
    actor = opts[:actor] || once(:default_actor, fn ->
      generate(user(role: opts[:actor_role] || :editor))
    end)

    category_id = opts[:category_id] || once(:default_category_id, fn ->
      generate(category()).id
    end)

    changeset_generator(
      MyApp.Catalog.Product,
      :create,
      defaults: [
        name: sequence(:product_name, &"Product #{&1}"),
        price_cents: StreamData.integer(100..99999),
        category_id: category_id,
        cover_image_url: nil
      ],
      overrides: opts,
      actor: actor
    )
  end
end
```

## Seed Generator (bypasses actions)

```elixir
# For data-condition tests where you need specific DB state without going through actions
# First arg is a resource STRUCT with defaults baked in, not a module
def product_seed(opts \\ []) do
  seed_generator(
    %MyApp.Catalog.Product{
      name: sequence(:product_name, &"Product #{&1}"),
      price_cents: 1000,
      category_id: once(:seed_category_id, fn -> generate(category()).id end)
    },
    overrides: opts
  )
end
```

## Ad-Hoc Seed (one-off data insertion)

```elixir
# Ash.Seed.seed! for direct data layer insertion without actions
product = Ash.Seed.seed!(%MyApp.Catalog.Product{
  name: "Test Product",
  price_cents: 999,
  category_id: category.id
})
```

## Basic Resource Test Structure

```elixir
defmodule MyApp.Catalog.CategoryTest do
  use MyApp.DataCase, async: true
  import MyApp.Generator

  alias MyApp.Catalog

  describe "read_categories/0" do
    test "returns empty list when no data" do
      assert Catalog.read_categories!() == []
    end
  end

  describe "search_categories/1" do
    test "filters by partial name match" do
      ["electronics", "clothing", "books"]
      |> Enum.each(&generate(category(name: &1)))

      assert %{results: results} = Catalog.search_categories!("o")
      names = Enum.map(results, & &1.name) |> Enum.sort()
      assert names == ["books", "clothing", "electronics"]
    end

    test "sorts by product count" do
      generate(category(name: "two", product_count: 2))
      generate(category(name: "none"))
      generate(category(name: "one", product_count: 1))

      %{results: results} =
        Catalog.search_categories!("", query: [sort_input: "-product_count"])

      assert Enum.map(results, & &1.name) == ["two", "one", "none"]
    end
  end
end
```

## Testing Errors

```elixir
# With assert_raise (bang version)
assert_raise Ash.Error.Invalid, ~r/must be zero or positive/, fn ->
  Catalog.create_product!(%{category_id: category.id, name: "bad", price_cents: -1},
    actor: admin)
end

# With assert_has_error/3 (error class + function)
%{category_id: category.id, name: "bad", price_cents: -1}
|> Catalog.create_product(actor: admin)
|> Ash.Test.assert_has_error(Ash.Error.Invalid, fn error ->
  match?(%{message: "must be zero or positive"}, error)
end)

# With assert_has_error/2 (function only)
MyApp.Catalog.Product
|> Ash.Changeset.for_create(:create, %{price_cents: -1})
|> assert_has_error(fn error ->
  match?(%{message: "must be zero or positive"}, error)
end)
```

## Testing Policies

```elixir
describe "create_category policies" do
  test "only admins can create categories" do
    admin = generate(user(role: :admin))
    assert Catalog.can_create_category?(admin)

    editor = generate(user(role: :editor))
    refute Catalog.can_create_category?(editor)

    user = generate(user())
    refute Catalog.can_create_category?(user)

    refute Catalog.can_create_category?(nil)
  end
end

# Testing read policies with data: option
describe "get_user_by_email policies" do
  test "users can only read themselves" do
    [actor, other] = generate_many(user(), 2)

    assert Accounts.can_get_user_by_email?(actor, actor.email, data: actor)
    refute Accounts.can_get_user_by_email?(actor, other.email, data: other)
  end

  test "admins can read all users" do
    [user1, user2] = generate_many(user(), 2)
    admin = generate(user(role: :admin))

    assert Accounts.can_get_user_by_email?(admin, user1.email, data: user1)
    assert Accounts.can_get_user_by_email?(admin, user2.email, data: user2)
  end
end
```

## Testing Calculations

```elixir
# Via Ash.calculate! with refs
test "name_length calculates string length" do
  assert Ash.calculate!(MyApp.Catalog.Category, :name_length, refs: %{name: "Electronics"}) == 11
end

# Via code interface
test "name_length via code interface" do
  assert MyApp.Catalog.category_name_length!("Books") == 5
end
```

## Testing with action_input/3 and Ash.load!

```elixir
# action_input/3 generates valid random inputs for property-based testing
test "create action accepts valid random inputs" do
  actor = generate(user(role: :editor))
  category = generate(category())
  input = Ash.Generator.action_input(MyApp.Catalog.Product, :create, %{category_id: category.id})
  assert {:ok, _product} = MyApp.Catalog.create_product(input, actor: actor)
end

# Ash.load!/2 for testing aggregates and calculations
test "variant_count aggregate returns correct count" do
  product = generate(product())
  generate_many(variant(product_id: product.id), 3)
  product = Ash.load!(product, [:variant_count], authorize?: false)
  assert product.variant_count == 3
end
```

## Unit Testing Change Modules

```elixir
test "previous_names stores current name when changing" do
  changeset =
    %Category{name: "Old Name", previous_names: ["Original"]}
    |> Ash.Changeset.new()
    |> MyApp.Catalog.Changes.TrackPreviousNames.change([], %{})

  assert Ash.Changeset.changing_attribute?(changeset, :previous_names)
  assert {:ok, ["Old Name", "Original"]} =
    Ash.Changeset.fetch_change(changeset, :previous_names)
end
```

## Testing PubSub Notifications

```elixir
test "creating product broadcasts notification" do
  category = generate(category())
  MyAppWeb.Endpoint.subscribe("products:#{category.id}")
  Catalog.create_product!(%{name: "New", price_cents: 1999, category_id: category.id},
    actor: generate(user(role: :editor)))
  assert_received %Phoenix.Socket.Broadcast{topic: "products:" <> _, event: "create"}
end
```

## Testing AshOban Triggers

```elixir
test "processes unhandled records" do
  record = generate(product(status: :pending))

  assert %{success: 2} =
    AshOban.Test.schedule_and_run_triggers({MyApp.Catalog.Product, :process})

  assert Ash.reload!(record).status == :processed
end
```

## Key Rules

- **Split tests by resource**, not by domain
- **Use bang (`!`) versions** in tests for cleaner assertions
- **Use `authorize?: false`** in test setup when not testing authorization
- **Use `data:` option** on `can_*?` for testing read policies
- **`assert_has_error` uses non-bang**, `assert_raise` uses bang
- **`once/2`** prevents creating a new actor/parent per generator call
- **`sequence/2`** guarantees uniqueness per test process (NOT across test runs)
- **`generate_many/2`** for batch creation
- **`seed_generator/2`** bypasses actions; **`action_input/3`** generates valid random inputs
- **Seeds vs actions**: actions for testing behavior; seeds for testing data conditions
- **`Ash.load!/2`** with `authorize?: false` for testing aggregates/calculations in setup
- **Private arguments** (`public?: false`) can conditionally disable validations in setup
- **Don't over-test**: skip unit tests for trivial logic; focus on complex Change/Calculation modules
- **Configure** `disable_async?` and `missed_notifications` in test env
