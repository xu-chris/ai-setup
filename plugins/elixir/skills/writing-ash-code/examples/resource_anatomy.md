# Example: Complete Resource Anatomy

## The Resource

A fully-featured Ash resource demonstrating every DSL block in correct order.

```elixir
defmodule MyApp.Catalog.Product do
  use Ash.Resource,
    otp_app: :my_app,
    domain: MyApp.Catalog,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    notifiers: [Ash.Notifier.PubSub],
    extensions: [AshJsonApi.Resource, AshGraphql.Resource]

  resource do
    description "A product in the catalog with variants and categories."
  end

  postgres do
    table "products"
    repo MyApp.Repo

    references do
      reference :category, index?: true, on_delete: :restrict
    end

    custom_indexes do
      index "name gin_trgm_ops", name: "products_name_gin_index", using: "GIN"
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :price_cents, :integer do
      allow_nil? false
      public? true
      constraints min: 0
    end

    attribute :description, :string do
      public? true
    end

    attribute :cover_image_url, :string do
      public? true
    end

    attribute :previous_names, {:array, :string} do
      default []
    end

    attribute :status, :atom do
      constraints one_of: [:draft, :active, :archived]
      default :draft
      allow_nil? false
    end

    create_timestamp :inserted_at, public?: true
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :category, MyApp.Catalog.Category do
      allow_nil? false
    end

    has_many :variants, MyApp.Catalog.Variant do
      sort position: :asc
      public? true
    end

    belongs_to :created_by, MyApp.Accounts.User
    belongs_to :updated_by, MyApp.Accounts.User
  end

  identities do
    identity :unique_product_name_per_category, [:name, :category_id],
      message: "already exists in this category"
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:name, :price_cents, :description, :cover_image_url, :category_id]
      argument :variants, {:array, :map}
      change manage_relationship(:variants, type: :direct_control, order_is_key: :position)
    end

    update :update do
      accept [:name, :price_cents, :description, :cover_image_url]
      require_atomic? false
      argument :variants, {:array, :map}
      change manage_relationship(:variants, type: :direct_control, order_is_key: :position)
    end

    read :search do
      description "Search products by name."

      argument :query, :ci_string do
        constraints allow_empty?: true
        default ""
      end

      filter expr(contains(name, ^arg(:query)))
      pagination offset?: true, default_limit: 12
    end
  end

  validations do
    validate numericality(:price_cents,
      greater_than_or_equal_to: 0
    ),
    where: [present(:price_cents)],
    message: "must be zero or positive"

    validate match(:cover_image_url, ~r"^(https://|/images/).+(.png|.jpg)$"),
      where: [changing(:cover_image_url)],
      message: "must start with https:// or /images/"
  end

  changes do
    change relate_actor(:created_by, allow_nil?: true), on: [:create]
    change relate_actor(:updated_by, allow_nil?: true)
  end

  calculations do
    calculate :display_price, :string, expr(
      fragment("'$' || to_char(? / 100.0, 'FM999990.00')", price_cents)
    ) do
      public? true
    end

    calculate :can_manage?, :boolean,
      expr(
        ^actor(:role) == :admin or
        (^actor(:role) == :editor and created_by_id == ^actor(:id))
      )
  end

  aggregates do
    count :variant_count, :variants
    first :featured_variant_name, :variants, :name do
      sort position: :asc
      include_nil? false
    end
    min :lowest_variant_price, :variants, :price_cents
    max :highest_variant_price, :variants, :price_cents
  end

  policies do
    bypass actor_attribute_equals(:role, :admin) do
      authorize_if always()
    end

    policy action(:create) do
      authorize_if actor_attribute_equals(:role, :editor)
    end

    policy action_type([:update, :destroy]) do
      authorize_if expr(can_manage?)
    end

    policy action_type(:read) do
      authorize_if always()
    end
  end

  pub_sub do
    prefix "products"
    module MyAppWeb.Endpoint
    publish :create, [:category_id]
    publish :destroy, [:category_id]
  end

  json_api do
    type "product"
    includes [:variants]
  end

  graphql do
    type :product
  end
end
```

## Embedded Resource

```elixir
defmodule MyApp.Catalog.Product.Dimensions do
  use Ash.Resource,
    otp_app: :my_app,
    data_layer: :embedded

  attributes do
    attribute :width, :float
    attribute :height, :float
    attribute :depth, :float
    attribute :weight_grams, :integer do
      constraints min: 1
    end
  end
end
```

## Composite Primary Key (Join Resource)

```elixir
defmodule MyApp.Catalog.ProductTag do
  use Ash.Resource,
    otp_app: :my_app,
    domain: MyApp.Catalog,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "product_tags"
    repo MyApp.Repo

    references do
      reference :product, on_delete: :delete, index?: true
      reference :tag, on_delete: :delete
    end
  end

  # No uuid_primary_key -- composite key from relationships
  relationships do
    belongs_to :product, MyApp.Catalog.Product do
      primary_key? true
      allow_nil? false
    end

    belongs_to :tag, MyApp.Catalog.Tag do
      primary_key? true
      allow_nil? false
    end
  end

  actions do
    defaults [:read]

    create :create do
      accept [:product_id, :tag_id]
    end

    destroy :destroy do
      primary? true
    end
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end

    policy action_type([:create, :destroy]) do
      authorize_if actor_present()
    end
  end
end
```

## Key Rules

- **DSL block order**: resource > postgres > attributes > relationships > identities > actions > validations > changes > calculations > aggregates > policies > pub_sub > json_api > graphql > oban
- **`create_timestamp`/`update_timestamp`** individually (allows per-field `public?: true`)
- **Composite keys** use `primary_key? true` on `belongs_to` -- no `uuid_primary_key`
- **`allow_nil? false`** on both attributes and belongs_to generates NOT NULL
- **`references`** block configures FK indexes and cascade behavior at migration level
