# Example: AshOban Patterns

## Setup / Application Config

```elixir
# application.ex -- replace plain Oban with AshOban.config
children = [
  # ...
  {Oban, AshOban.config(Application.fetch_env!(:my_app, :ash_domains), oban_config)}
]
```

```elixir
# config/test.exs
config :my_app, Oban, testing: :manual
```

## Trigger: Process Records Matching a Condition

```elixir
defmodule MyApp.Fulfillment.Order do
  use Ash.Resource,
    otp_app: :my_app,
    domain: MyApp.Fulfillment,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshOban]

  attributes do
    uuid_primary_key :id
    attribute :status, :atom, constraints: [one_of: [:pending, :processing, :shipped, :errored]]
    attribute :last_error, :string
    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  oban do
    triggers do
      trigger :fulfill do
        action :fulfill
        where expr(status == :pending)
        scheduler_cron "* * * * *"
        on_error :mark_errored
        max_attempts 3
        worker_module_name MyApp.Fulfillment.Order.AshOban.Worker.Fulfill
        scheduler_module_name MyApp.Fulfillment.Order.AshOban.Scheduler.Fulfill
      end
    end
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:status]
    end

    update :fulfill do
      accept []
      change set_attribute(:status, :shipped)
      # ... fulfillment logic in a Change module ...
    end

    update :mark_errored do
      accept []
      argument :error, :term
      change set_attribute(:status, :errored)
      change fn changeset, _context ->
        case Ash.Changeset.fetch_argument(changeset, :error) do
          {:ok, error} ->
            Ash.Changeset.change_attribute(changeset, :last_error, inspect(error))
          :error ->
            changeset
        end
      end
    end
  end

  policies do
    bypass AshOban.Checks.AshObanInteraction do
      authorize_if always()
    end

    bypass actor_attribute_equals(:role, :admin) do
      authorize_if always()
    end

    policy action_type(:read) do
      authorize_if always()
    end
  end
end
```

## Trigger: Expedite on Action (run_oban_trigger)

```elixir
# Immediately trigger processing when a new order is created
create :create do
  accept [:status]
  change run_oban_trigger(:fulfill)
end
```

## Scheduled Action: Periodic Generic Action

```elixir
defmodule MyApp.Analytics.Report do
  use Ash.Resource,
    otp_app: :my_app,
    domain: MyApp.Analytics,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshOban]

  oban do
    scheduled_actions do
      schedule :generate_daily_summary, "0 2 * * *" do
        action :generate_daily_summary
        worker_module_name MyApp.Analytics.Report.AshOban.ActionWorker.GenerateDailySummary
      end
    end
  end

  actions do
    action :generate_daily_summary, :term do
      run fn _input, _context ->
        # ... generate report logic ...
        {:ok, :completed}
      end
    end
  end
end
```

## Actor Persister

```elixir
defmodule MyApp.AshObanActorPersister do
  use AshOban.ActorPersister

  def store(%MyApp.Accounts.User{id: id}), do: %{"type" => "user", "id" => id}

  def lookup(%{"type" => "user", "id" => id}) do
    MyApp.Accounts.get_user_by_id(id)
  end

  def lookup(nil), do: {:ok, nil}
end
```

```elixir
# config/config.exs
config :ash_oban, :actor_persister, MyApp.AshObanActorPersister
```

## Trigger with Custom Backoff

```elixir
trigger :sync_inventory do
  action :sync_inventory
  where expr(needs_sync == true)
  scheduler_cron "*/5 * * * *"
  max_attempts 5

  backoff fn %Oban.Job{attempt: attempt, unsaved_error: unsaved_error} ->
    %{kind: _, reason: reason, stacktrace: _} = unsaved_error
    case reason do
      %MyApp.RateLimitError{} -> 300
      _ -> trunc(:math.pow(attempt, 4))
    end
  end

  worker_module_name MyApp.Inventory.Product.AshOban.Worker.SyncInventory
  scheduler_module_name MyApp.Inventory.Product.AshOban.Scheduler.SyncInventory
end
```

## Trigger with Multitenancy

```elixir
oban do
  list_tenants MyApp.Tenants
  use_tenant_from_record? true

  triggers do
    trigger :process do
      action :process
      where expr(processed != true)
      read_action :read_all_tenants  # must support :allow_global
    end
  end
end
```

## Testing: Basic Trigger

```elixir
defmodule MyApp.Fulfillment.OrderTest do
  use MyApp.DataCase, async: true
  import MyApp.Generator

  test "fulfills pending orders" do
    order = generate(order(status: :pending))

    # success: 2 = 1 scheduler + 1 worker
    assert %{success: 2} =
      AshOban.Test.schedule_and_run_triggers({MyApp.Fulfillment.Order, :fulfill})

    assert Ash.reload!(order).status == :shipped
  end

  test "does not fulfill already shipped orders" do
    _order = generate(order(status: :shipped))

    # success: 1 = scheduler only (no matching records, no worker jobs)
    assert %{success: 1} =
      AshOban.Test.schedule_and_run_triggers({MyApp.Fulfillment.Order, :fulfill})
  end

  test "marks errored orders on final attempt failure" do
    order = generate(order(status: :pending))
    # ... stub fulfillment to fail ...

    assert %{discard: 1, success: 1} =
      AshOban.Test.schedule_and_run_triggers({MyApp.Fulfillment.Order, :fulfill})

    assert Ash.reload!(order).status == :errored
  end
end
```

## Testing: Scheduled Action

```elixir
test "generates daily summary" do
  AshOban.Test.schedule_and_run_triggers(
    {MyApp.Analytics.Report, :generate_daily_summary},
    scheduled_actions?: true
  )

  # Assert side effects...
end
```

## Testing: Specific Record

```elixir
test "can trigger for a specific record" do
  order = generate(order(status: :pending))

  # Enqueue job for specific record (without scheduler)
  AshOban.run_trigger(order, :fulfill)

  # Drain to execute
  AshOban.Test.schedule_and_run_triggers(MyApp.Fulfillment.Order)

  assert Ash.reload!(order).status == :shipped
end
```

## Testing: With Actor

```elixir
test "trigger runs with actor context" do
  admin = generate(user(role: :admin))
  order = generate(order(status: :pending))

  AshOban.Test.schedule_and_run_triggers(
    {MyApp.Fulfillment.Order, :fulfill},
    actor: admin
  )
end
```

## Mix Commands

- `mix ash_oban.set_default_module_names` -- set module names to defaults (prevents dangling jobs)

## Key Rules

- **Always set `worker_module_name` and `scheduler_module_name`** explicitly to prevent dangling jobs on rename
- **Always add `bypass AshOban.Checks.AshObanInteraction`** to policies on resources with triggers
- **`on_error`** action receives `:error` argument -- keep it simple to avoid secondary failures
- **`run_oban_trigger(:name)`** change expedites processing on create/update
- **`scheduler_cron false`** disables the scheduler (manual trigger only)
- **Default queue name** is `resource_short_name_trigger_name` -- add to Oban config
- **Test result counts**: scheduler job + N worker jobs = total success count
- **`scheduled_actions?: true`** required to include scheduled actions in test runs
- **`state :paused` or `state :deleted`** to retire triggers -- never just remove them (especially with Oban Pro)
