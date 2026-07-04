# Example: Domain Design Patterns

## Complete Domain with All Features

```elixir
defmodule MyApp.Catalog do
  use Ash.Domain,
    otp_app: :my_app,
    extensions: [AshPhoenix, AshGraphql.Domain, AshJsonApi.Domain]

  # AshPhoenix forms for actions that need extra arguments
  forms do
    form :create_product, args: [:category_id]
  end

  # GraphQL queries and mutations
  graphql do
    queries do
      get MyApp.Catalog.Category, :get_category_by_id, :read
      list MyApp.Catalog.Category, :search_categories, :search
    end

    mutations do
      create MyApp.Catalog.Category, :create_category, :create
      update MyApp.Catalog.Category, :update_category, :update
      destroy MyApp.Catalog.Category, :destroy_category, :destroy
      create MyApp.Catalog.Product, :create_product, :create
      update MyApp.Catalog.Product, :update_product, :update
      destroy MyApp.Catalog.Product, :destroy_product, :destroy
    end
  end

  # JSON:API routes
  json_api do
    routes do
      base_route "/categories", MyApp.Catalog.Category do
        get :read
        index :search
        post :create
        patch :update
        delete :destroy
        related :products, :read, primary?: true
      end

      base_route "/products", MyApp.Catalog.Product do
        post :create
        patch :update
        delete :destroy
      end
    end
  end

  # Code interfaces -- the public API
  resources do
    resource MyApp.Catalog.Category do
      define :create_category, action: :create
      define :read_categories, action: :read
      define :get_category_by_id, action: :read, get_by: [:id]
      define :update_category, action: :update
      define :destroy_category, action: :destroy

      # Search with default loads for common aggregates
      define :search_categories,
        action: :search,
        args: [:query],
        default_options: [
          load: [:product_count, :featured_product_name]
        ]

      # Calculation via code interface
      define_calculation :category_name_length,
        calculation: :name_length,
        args: [{:ref, :name}]
    end

    resource MyApp.Catalog.Product do
      define :create_product, action: :create
      define :get_product_by_id, action: :read, get_by: [:id]
      define :update_product, action: :update
      define :destroy_product, action: :destroy
    end

    resource MyApp.Catalog.Variant

    # Code interface with custom_input for ergonomic struct -> ID transform
    resource MyApp.Catalog.Wishlist do
      define :add_to_wishlist do
        action :create
        args [:product]

        custom_input :product, :struct do
          constraints instance_of: MyApp.Catalog.Product
          transform to: :product_id, using: & &1.id
        end
      end

      define :remove_from_wishlist do
        action :destroy
        args [:product]
        get? true

        custom_input :product, :struct do
          constraints instance_of: MyApp.Catalog.Product
          transform to: :product_id, using: & &1.id
        end
      end
    end
  end
end
```

## Key Rules

- **Every callable action gets a `define`** on the domain
- **`get_by: [:id]`** (list form) auto-filters single-record reads
- **`default_options: [load: [...]]`** is the recommended place to auto-load aggregates/calculations
- **`custom_input` with `transform`** bridges ergonomic code (`add_to_wishlist(product)`) with clean action input (`product_id: uuid`)
- **`get? true`** on destroy: introspects BulkResult, returns `:ok` for 0-1 deletions
- **`forms` block** declares extra args for `form_to_*` helpers
- **GraphQL/JSON:API** routes are defined on the domain, not the resource
