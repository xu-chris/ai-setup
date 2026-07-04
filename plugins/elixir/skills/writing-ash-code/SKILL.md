---
name: writing-ash-code
description: >
  Write production-grade Ash Framework code with lead-engineer precision. Use when creating
  Ash resources, domains, actions, policies, calculations, aggregates, or relationships. Use
  when porting Ecto code to Ash, refactoring existing resources, adding authorization, or
  building LiveView forms with AshPhoenix. Use when adding background jobs with AshOban.
  Triggers on "add resource", "create action", "write policy", "port to Ash", "Ash migration",
  "manage_relationship", "oban trigger", "scheduled action", or any Ash DSL work.
---

# Writing Ash Code

You are a lead Ash Framework engineer. Every resource, action, policy, and domain you write
must be complete, architecturally sound, and use Ash at its fullest. You have full authority
to port outdated Ecto code to Ash when working on a problem.

## Core Philosophy

**Data > Code** -- Model your domain as resource DSL that compiles into introspectible data structures
**Derive > Hand-write** -- Resources are the single source of truth; derive APIs, forms, docs from them
**What > How** -- Declare behavior, not implementation; Ash determines the how

## Before Writing Any Code

**Always introspect first.** Run these commands to understand the current state before changing anything:

- `Ash.Resource.Info.attributes(MyResource)` -- list all attributes
- `Ash.Resource.Info.relationships(MyResource)` -- list all relationships
- `Ash.Resource.Info.actions(MyResource)` -- list all actions
- `Ash.Resource.Info.calculations(MyResource)` -- list calculations
- `Ash.Resource.Info.aggregates(MyResource)` -- list aggregates
- `Ash.Domain.Info.resources(MyDomain)` -- list domain resources
- `Spark.extensions(MyResource)` -- list extensions on a resource
- `exports(MyModule)` -- list all functions (IEx helper)
- `mix ash.codegen <name>` -- generate migration from resource changes
- `mix ash.migrate` -- run pending migrations
- `mix ash.gen.resource My.Domain.Resource --extend postgres` -- scaffold a new resource
- `mix ash.extend My.Resource json_api` -- add an extension

**Never guess** the current state of a resource. Always read the source or introspect via `project_eval`.

## Resource Architecture

**Use** `Ash.Resource` with explicit options on every resource:
- `otp_app:` -- always the app atom (e.g. `:my_app`)
- `domain:` -- the parent domain module
- `data_layer:` -- `AshPostgres.DataLayer` for persisted, `:embedded` for embedded
- `authorizers:` -- `[Ash.Policy.Authorizer]` on every persisted resource
- `notifiers:` -- `[Ash.Notifier.PubSub]` when real-time updates needed
- `extensions:` -- `[AshJsonApi.Resource]`, `[AshGraphql.Resource]`, `[AshOban]` as needed

**Prefer** `uuid_primary_key :id` for all persisted resources
**Use** `create_timestamp :inserted_at` and `update_timestamp :updated_at` individually (allows per-field `public?: true`)
**Mark** attributes `public? true` only when needed for API exposure or `sort_input`
**Set** `allow_nil? false` on required attributes -- this generates DB NOT NULL constraints
**Set** `default` on attributes for default values: `default: []`, `default: 0`, `default: "draft"` -- works with all types including `{:array, :string}`
**Use** `constraints` for validation at the type level: `min:`, `max:`, `one_of:`, `min_length:`

**See**: [Resource anatomy](examples/resource_anatomy.md)

## Domain Design

**One domain per bounded context.** Group closely related resources together.
**Define** all code interfaces on the domain, not the resource -- domains are the public API.
**Use** `define` for every action you want callable from outside the domain.
**Use** `define_calculation` for calculations accessible via code interface.
**Add** `extensions: [AshPhoenix]` to generate `form_to_*` helpers.
**Use** the `forms` block for forms that need extra arguments (e.g., `form :create_product, args: [:category_id]`).
**Use** `get_by:` on read code interfaces for single-record lookups: `get_by: [:id]` (list form).
**Use** `default_options: [load: [...]]` on code interfaces to auto-load aggregates/calculations.
**Use** `custom_input` with `transform` to bridge ergonomic code interfaces (accept structs) with clean API designs (accept IDs).

**See**: [Domain patterns](examples/domain_patterns.md)

## Action Design

### Defaults and accept

**Use** `defaults [:read, :destroy]` only for actions needing zero customization
**Always** explicitly define `:create` and `:update` actions with `accept` lists
**Use** `default_accept` sparingly -- prefer explicit `accept` per action for security
**Never** accept relationship foreign keys in update actions unless re-parenting is intentional
**Mark** actions `primary? true` when used by `manage_relationship`

### Arguments

**Use** arguments for non-persisted action inputs (search queries, filters, computed values)
**Use** `private_arguments` block or `public? false` on arguments that should not be user-facing
**Use** `allow_nil? false` on required arguments
**Prefer** `:ci_string` for search arguments (case-insensitive matching)
**Use** `constraints allow_empty?: true` with `default ""` for optional search arguments

### Atomicity

**Keep** `require_atomic? true` (the default) unless imperative code is unavoidable
**Set** `require_atomic? false` only when using: `manage_relationship`, imperative `change fn`, or non-atomic Change modules
**Implement** `atomic/3` callback in Change modules whenever possible -- push logic to SQL
**Use** `atomic_update(:field, expr(...))` for counter increments and similar patterns
**Distinguish** `name` (current DB value) from `atomic_ref(:name)` (value after other changes) in `atomic/3`

### Generic Actions

**Use** generic actions for operations that don't fit CRUD (e.g., `request_password_reset`)
**Define** with `action :name, :return_type do ... end`

### Bulk Operations

**Use** code interfaces that accept lists for bulk create/update/destroy
**Set** `return_records?: true` when you need the created/updated records back
**Set** `notify?: true` on `Ash.bulk_create!` calls to trigger notifiers
**Use** `bulk_options` on code interface definitions for default bulk behavior

**See**: [Action design patterns](examples/action_design.md)

## Relationships

**Use** `belongs_to` on the resource holding the foreign key
**Use** `has_many` on the "one" side; add `sort` for default ordering; use `destination_attribute` when the FK column name doesn't match convention (e.g., `destination_attribute :author_id` instead of default `:user_id`)
**Use** `many_to_many` with `through` pointing to the join resource module (Ash auto-generates a hidden join relationship); or use `join_relationship` to reference an explicitly-defined `has_many` on the join resource
**Use** `destination_attribute_on_join_resource` when the FK column name doesn't match convention
**Set** `allow_nil? false` on required `belongs_to`
**Set** `primary_key? true` on both sides of composite-key join resources (no `uuid_primary_key :id` needed)
**Always** configure `references` in the `postgres` block: `index?: true` on foreign keys, `on_delete:` as appropriate

### Manual Relationships

**Use** `Ash.Resource.ManualRelationship` when the relationship doesn't follow standard FK patterns
**Implement** `load/3` callback that returns `{:ok, map_of_parent_to_related}`

### manage_relationship

**Use** `type: :direct_control` for full CRUD-managing child records (variants on products)
**Use** `type: :append_and_remove` for linking/unlinking existing records (tags on posts)
**Use** `type: :append` for add-only linking (no removal)
**Use** `type: :remove` for remove-only unlinking
**Use** `type: :create` for create-only (no updating or removing)
**Use** `order_is_key: :order` for sortable lists (zero-indexed)
**Accept** the managed data as `argument :items, {:array, :map}` on the action
**Ensure** managed child resources have `primary? true` on create/update/destroy actions Ash will invoke

### Cascade Deletes

**Prefer** database-level `on_delete: :delete` when no business logic needs to run
**Use** `change cascade_destroy(:relationship)` when notifiers/policies must fire
**Set** `after_action?: false` on `cascade_destroy` to avoid FK violations
**Set** `return_notifications?: true` when PubSub must broadcast the cascade

## Authorization & Policies

**Add** `authorizers: [Ash.Policy.Authorizer]` to EVERY persisted resource
**Pass** `actor:` on every action call -- never rely on "no actor = no auth check"
**Use** `authorize?: false` only in seeds, internal system actions, and test setup

### Policy Structure

**Place** bypass policies first, standard policies after
- Bypass = OR logic (if it passes, skip remaining policies) -- but order matters: a failing standard policy BEFORE a passing bypass still fails
- Standard = AND logic (all applicable must pass)
**Understand** once an authorizer is added with no applicable policies, the request is forbidden by default
**Use** `bypass actor_attribute_equals(:role, :admin) do authorize_if always() end` for admin override
**Use** `bypass AshAuthentication.Checks.AshAuthenticationInteraction` on auth resources
**Use** `bypass AshOban.Checks.AshObanInteraction` on resources with AshOban triggers

### Policy Checks

- `always()` -- unconditional
- `actor_present()` -- any logged-in user
- `actor_attribute_equals(:role, :value)` -- role check
- `relates_to_actor_via(:relationship)` -- ownership via relationship
- `accessing_from(Resource, :relationship)` -- authorized through parent
- `exists(relationship, expr(field == value))` -- recommended over direct relationship references in expressions
- `expr(^actor(:role) == :editor and created_by_id == ^actor(:id))` -- compound check
- `forbid_if expr(published == true)` -- forbid pattern

### Expression Limitations

**Never** reference data being created in policy expressions for create actions -- the record doesn't exist yet
**Use** `relates_to_actor_via` or argument-based checks for create authorization
**Ensure** the User resource has a read policy allowing users to read themselves -- `relate_actor` internally reads the actor, so users must be readable

### Read Policies

**Understand** read policies act as filters, not yes/no gates
**Use** `access_type :strict` when you need hard deny instead of filter behavior
**Use** `authorize_if always()` for publicly readable resources
**Use** `authorize_if expr(user_id == ^actor(:id))` for user-scoped data

### Policy Groups

**Use** `policy_group` to apply a shared condition to multiple policies:

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

### Field Policies

**Use** `field_policies` block to control attribute-level visibility
**Use** `:*` wildcard to set default field policy
**Use** `private_fields :include | :show | :hide` option to control private field behavior

### Reusable Policy Logic

**Extract** shared authorization expressions into calculations (e.g., `calculate :can_manage?, :boolean, expr(...)`)
**Reference** across resources via relationships: `authorize_if expr(product.can_manage_product?)`

### can_*? Helpers

**Use** auto-generated `can_create_resource?/1`, `can_update_resource?/2` in templates
**Use** `data:` option for testing read policies: `can_read?(actor, data: record)`
**Use** `run_queries?: false, maybe_is: false` in LiveView templates to avoid DB queries on every render
**Use** `Ash.can?/3` for lower-level programmatic checks: `Ash.can?({Resource, :action}, actor)`
**Use** `AshPhoenix.Form.ensure_can_submit!/1` after creating forms with `actor:`

### Debugging Policies

**Set** `config :ash, policies: [show_policy_breakdowns?: true]` in dev config for detailed SAT solver output

**See**: [Policies and authorization](examples/policies_and_authorization.md)

## Changes, Validations & Preparations

### Hook Lifecycle (execution order)

`around_transaction` > `before_transaction` > `around_action` > `before_action` > [DATA LAYER] > `after_action` > `after_transaction`

### Changes

**Extract** to modules (`use Ash.Resource.Change`) when: reused across actions, testable in isolation, or breaking compile-time deps
**Use** inline `change fn changeset, _context -> ... end` only for trivial one-offs
**Use** `where: [changing(:field)]` to gate changes on specific attribute modifications
**Use** `only_when_valid?` to skip changes when validation already failed
**Use** `on: [:create]` in global `changes` block to scope to specific action types
**Wrap** side-effects in `before_action`/`after_action` hooks -- changes run in 4 contexts: (1) building initial form, (2) authorization checks, (3) every form validation event, (4) actual action submission
**Use** `force_change_attribute/3` to set attributes inside `before_action` hooks without triggering "bypasses accept-list" warnings

### Key Changeset Functions

- `Ash.Changeset.get_attribute/2` -- returns the change value, falling back to original data; use `fetch_change/2` for new-only
- `Ash.Changeset.get_data/2` -- access the CURRENT/OLD value from the record (e.g., `get_data(changeset, :name)`)
- `Ash.Changeset.fetch_change/2` -- returns `{:ok, new_value}` or `:error` if not changed
- `Ash.Changeset.change_attribute/3` -- set an attribute value
- `Ash.Changeset.change_new_attribute/3` -- set only if not already changed
- `Ash.Changeset.force_change_attribute/3` -- set bypassing accept-list
- `Ash.Changeset.add_error/2` -- add validation error
- `Ash.Changeset.fetch_argument/2` -- get action argument value
- `Ash.Changeset.force_set_argument/3` -- set argument bypassing public? check
- `Ash.Changeset.put_context/3` -- add to changeset context map
- `Ash.Changeset.before_action/2` -- register hook (runs once at execution)
- `Ash.Changeset.after_action/2` -- register hook (returns `{:ok, record}`, `{:ok, record, [notifications]}`, or `{:error, any}`)

### Validations

**Use** built-in validators: `numericality`, `match`, `string_length`, `present`, `attribute_equals`
**Use** `where:` for conditional validations: `where: [present(:field)]`, `where: [changing(:field)]`
**Set** `message:` for user-friendly error messages
**Set** `before_action? true` on validations that must run after `before_action` hooks set attributes (validations run before hooks by default)
**Place** in `validations` block for global rules; in action block for action-specific rules

### Preparations

**Use** `prepare build(load: [...])` to auto-load calculations/aggregates on read actions
**Use** `prepare build(sort: [...])` for default sort orders
**Use** `filter expr(...)` on read actions for scoped queries

## Calculations & Aggregates

### Calculations

**Prefer** expression-based: `calculate :name, :type, expr(...)` -- runs in database
**Use** anonymous function form for in-memory calculations: `calculate :name, :type, fn records, _context -> Enum.map(records, ...) end`
**Use** module-based (`use Ash.Resource.Calculation`) when logic exceeds a single expression
**Implement** `expression/2` callback for DB-side execution when possible
**Implement** `calculate/3` as fallback for in-memory execution
**Mark** `public? true` only when needed for API or `sort_input`
**Always** return a list from `calculate/3` (one value per input record)

### Aggregates

**Use** `count`, `first`, `sum`, `min`, `max`, `avg`, `list`, `exists`, `custom` for relationship-derived values
**Prefer** aggregates over inline `expr(count(...))` -- they generate more efficient SQL
**Aggregate** on join relationships (not many-to-many) to save database joins
**Use** resource-based aggregates (without relationship) with `parent/1` for self-referencing
**Mark** `public? true` for sortable/filterable aggregates
**Use** `include_nil?: true` on `first` when nil values should not be filtered out
**Use** `exists` as inline aggregate inside calculation expressions: `expr(exists(comments, is_nil(deleted_at)))`
**Use** `reuse_values?: true` on `Ash.load!` to force in-memory calculation evaluation on already-loaded data

### Loading Strategy

- **At call site**: `load: [...]` -- flexible, can be forgotten
- **In preparation**: `prepare build(load: [...])` -- always loads
- **In code interface**: `default_options: [load: [...]]` -- recommended middle ground

## Identities

**Use** `identity` for unique constraints: `identity :unique_name, [:name]`
**Set** `eager_check?` to validate uniqueness before hitting the DB (in changesets)
**Set** `pre_check?` for checking at changeset build time without eager check
**Use** `field_names:` to customize error field mappings
**Combine** with upsert support: `upsert? true, upsert_identity: :unique_name` on create actions

## Testing

**Use** `Ash.Generator` with `changeset_generator/3` for test data factories
**Use** `seed_generator/2` as alternative -- pass a resource struct with defaults: `seed_generator(%Resource{field: value}, opts)`
**Use** `Ash.Seed.seed!/1` for ad-hoc direct data layer insertion in test setup
**Use** `sequence/2` for unique values: `sequence(:email, &"user#{&1}@example.com")` (unique per test process, NOT across runs)
**Use** `once/2` for lazy shared setup (default actors, parent records)
**Use** `generate/1` and `generate_many/2` to materialize records
**Test** actions via code interfaces with bang (`!`) versions
**Use** `Ash.Test.assert_has_error/2` or `/3` (non-bang) or `assert_raise` (bang) for error assertions
**Test** policies with `can_create_*?/1`, `can_update_*?/2` -- test every role
**Use** `data:` option on `can_*?` for read policy tests
**Use** `Ash.Generator.action_input/3` to generate valid inputs for testing action validation
**Use** private arguments (e.g., `argument :skip_validation, :boolean, default: true, public?: false`) to conditionally disable validations in test setup
**Test** calculations with `Ash.calculate!/3` and `refs:` map
**Test** relationships/aggregates with `Ash.load!/2` -- use `authorize?: false` in setup, pass `actor:` when testing authorization
**Prefer** actions over seeds for testing behavior; seeds only for testing data conditions (pre-existing state)
**Write** an empty read as the first test for any new resource (e.g., `assert Domain.list_things!() == []`)
**Skip** unit testing simple pass-through logic -- only unit test Change modules or calculations with complex branching
**Split** tests by resource, not by domain
**Configure** test env: `config :ash, :disable_async?, true` and `config :ash, :missed_notifications, :ignore`

**See**: [Testing patterns](examples/testing_patterns.md)

## LiveView Integration

**Use** `AshPhoenix.Form.for_create/3` or domain `form_to_create_*/1` for create forms
**Use** `AshPhoenix.Form.for_update/3` or domain `form_to_update_*/2` for edit forms
**Always** pass `actor:` when creating forms
**Call** `AshPhoenix.Form.ensure_can_submit!/1` after form creation
**Use** `AshPhoenix.Form.validate/2` in `"validate"` event handlers -- always pipe result through `to_form/1`
**Use** `AshPhoenix.Form.submit/2` with `params:` in `"save"` event handlers
**Use** `AshPhoenix.Form.add_form/2`, `remove_form/2`, `sort_forms/3` for nested forms
**Use** nested form options: `:sparse?` for partial updates, `:data` for pre-loaded data, `:transform_errors` for custom error formatting
**Use** `AshPhoenix.LiveView.page_from_params/2` for pagination from URL params
**Use** `AshPhoenix.LiveView.prev_page?/1`, `next_page?/1` for pagination controls
**Pass** `actor:` on every domain call in LiveView handlers

**See**: [LiveView forms](examples/liveview_forms.md)

## PubSub & Notifiers

**Add** `notifiers: [Ash.Notifier.PubSub]` on resources that broadcast
**Use** `simple_notifiers: [MyNotifier]` shorthand for custom notifier modules
**Set** `prefix` and `module` (the Phoenix Endpoint) in the `pub_sub` block
**Use** `publish :action_name, [:attribute]` to define topic templates
**Always** add a `transform` to strip sensitive data before broadcast
**Set** `notify?: true` on `Ash.bulk_create!` calls to trigger notifiers
**Subscribe** in LiveView `mount/3` inside `if connected?(socket)` guard

### Custom Notifiers

**Create** module with `use Ash.Notifier` and implement `notify/1` callback
**Receive** `%Ash.Notifier.Notification{}` with `:resource`, `:action`, `:data`, `:changeset`, `:actor`

## AshOban (Background Jobs)

**Add** `extensions: [AshOban]` to resources that need background processing
**Configure** Oban in application: `{Oban, AshOban.config(domains, oban_config)}`
**Set** `config :my_app, Oban, testing: :manual` in test config

### Triggers

**Use** triggers for actions that run periodically on records matching a condition
**Define** `where expr(...)` to filter which records the trigger applies to
**Set** `scheduler_cron` for timing (default: every minute); use `false` to disable scheduler
**Set** `on_error` to an update action for graceful error handling
**Set** `worker_module_name` and `scheduler_module_name` explicitly to avoid dangling jobs on rename
**Use** `run_oban_trigger(:trigger_name)` change to expedite processing on create/update
**Use** `lock_for_update?` (default true) for safe concurrent processing

### Scheduled Actions

**Use** for periodic generic/create actions not tied to specific records
**Define** with `schedule :name, "cron_expression", action: :action_name`

### Policy Bypass

**Add** `bypass AshOban.Checks.AshObanInteraction do authorize_if always() end` to resources with triggers

### Testing AshOban

**Use** `AshOban.Test.schedule_and_run_triggers({Resource, :trigger_name})` in tests
**Assert** on result map: `%{success: 2, failure: 0}` (scheduler + worker = 2 for 1 record)
**Pass** `scheduled_actions?: true` to include scheduled actions
**Use** `AshOban.run_trigger/3` for testing a specific record

**See**: [AshOban patterns](examples/ash_oban.md)

## Porting Authority

You have full authority to port Ecto code to Ash when you encounter it during your work.

### When to Port

**Port** when: the resource is already registered as Ash but domain bypasses it with raw Ecto
**Port** when: manual scope filtering (`Repo.all` with joins) could be replaced by Ash policies
**Port** when: `Ecto.Changeset` functions exist alongside Ash actions on the same resource
**Port** when: manual `Phoenix.PubSub.broadcast` exists but Ash PubSub notifiers would work
**Port** when: cross-domain queries use `Repo.get_by` on Ash resources

### How to Port

- Replace `Repo.all(from r in Resource, ...)` with `Ash.Query.filter` + `Ash.read!`
- Replace `Ecto.Changeset.change(record, attrs)` + `Repo.update` with code interface calls
- Replace `%Resource{} |> Resource.changeset(attrs) |> Repo.insert` with `Domain.create_resource(attrs)`
- Replace manual join-based scope filtering with Ash policies using `expr(^actor(...))`
- Replace `Repo.exists?(from ...)` with `Ash.exists?` or policy checks
- Add `authorizers: [Ash.Policy.Authorizer]` and write policies for resources lacking them

### What NOT to Port

**Keep** `Ecto.Multi` for genuinely complex multi-step transactions with rollback logic
**Keep** raw SQL for reporting/analytics queries that don't map to resource actions
**Keep** Ecto schemas for billing/payment integrations where third-party libraries expect them

**See**: [Porting Ecto to Ash](examples/porting_ecto_to_ash.md)

## API Generation

**Use** `mix ash.extend Resource json_api` and `mix ash.extend Resource graphql` to add API extensions
**Define** routes/queries/mutations on the domain, not the resource
**Set** `type` on each resource for API identification (`"product"` for JSON:API, `:product` for GraphQL)
**Use** `default_fields` to control which attributes appear in responses
**Use** `includes` on resources to allow relationship loading
**Add** `description` to resources and actions for auto-generated API documentation

## References

- **examples/** - Detailed patterns:
  - [Resource anatomy](examples/resource_anatomy.md) - Complete resource with every DSL block
  - [Domain patterns](examples/domain_patterns.md) - Domain design, code interfaces, forms
  - [Action design](examples/action_design.md) - All action types, arguments, atomicity
  - [Policies and authorization](examples/policies_and_authorization.md) - Policy structure, checks, bypass, reusable logic
  - [Testing patterns](examples/testing_patterns.md) - Generators, assertions, policy tests
  - [LiveView forms](examples/liveview_forms.md) - AshPhoenix.Form, pagination, PubSub
  - [AshOban patterns](examples/ash_oban.md) - Triggers, scheduled actions, testing
  - [Porting Ecto to Ash](examples/porting_ecto_to_ash.md) - Before/after conversion patterns
