---
name: updating-dependencies
description: Update Elixir/Phoenix dependencies safely. Use when running mix hex.outdated, updating mix.exs version constraints, handling breaking version changes, reviewing changelogs for upgrades, or verifying updates with compile and test.
---

# Update Elixir Dependencies

Update all outdated dependencies, handling both safe updates and breaking changes.

## Workflow

### 1. Identify Outdated Dependencies

Run `mix hex.outdated` to get a list of all outdated dependencies. Parse the output to identify:
- **Safe updates**: Patch or minor version changes (no major bump)
- **Breaking updates**: Major version changes (e.g., 1.x.x → 2.x.x)

### 2. Apply Safe Updates

Run `mix deps.update --all` to update within version constraints in `mix.exs`.

### 3. Handle Breaking Changes

For each dependency with a major version change:

1. **Update version constraint** in `mix.exs` to allow the new major version

2. **Find changelog/upgrade guide**:
   - Try `https://hexdocs.pm/{package_name}/changelog.html`
   - If not found, check `https://hexdocs.pm/{package_name}` sidebar for:
     - "Changelog", "CHANGELOG", "Upgrade Guide", "Migration Guide"
     - "Upgrading" or "Breaking Changes" sections
   - Extract breaking changes between current and target version

3. **Review breaking changes** and apply necessary code modifications

4. **Run verification** after each breaking change before next update

### 4. Verification

After updates, run and fix any issues:

```bash
mix compile --warnings-as-errors  # Compile with warnings as errors
mix format --check-formatted      # Check formatting
mix test                          # Run tests
```

**If verification fails:**
- Compile warnings → Fix the warning in code
- Format issues → Run `mix format`
- Test failures → Debug and fix tests

### 5. Final Steps

Once all verifications pass:

1. Run `mix hex.outdated` again to confirm all up to date

2. **Check diff.hex.pm for suspicious changes**:
   - For each updated package, check `https://diff.hex.pm/diff/{package}/{old_version}..{new_version}`
   - Example: `https://diff.hex.pm/diff/phoenix/1.8.2..1.8.3`
   - Look for unexpected changes, security concerns, or code you should review

3. **Summarize updates**:
   - List all updated packages with version changes
   - Note any breaking changes that required code modifications
   - Flag any suspicious findings from diff analysis

## Quick Reference

| Command | Purpose |
|---------|---------|
| `mix hex.outdated` | List outdated deps |
| `mix deps.update --all` | Update within constraints |
| `mix deps.update {dep}` | Update single dependency |
| `mix deps.get` | Fetch updated deps |
| `mix deps.clean {dep} --build` | Clean and rebuild single dep |

## Version Constraint Syntax

```elixir
# In mix.exs deps
{:phoenix, "~> 1.8"}      # >= 1.8.0 and < 2.0.0
{:ecto, "~> 3.12.0"}      # >= 3.12.0 and < 3.13.0
{:plug, ">= 1.0.0"}       # Any version >= 1.0.0
{:jason, "~> 1.0", optional: true}  # Optional dependency
```

## Common Breaking Change Patterns

**Phoenix**: Check `config/` files, router syntax, LiveView lifecycle changes
**Ecto**: Check changeset functions, query syntax, repo callbacks
**LiveView**: Check mount/3 signature, event handling, component patterns
**Oban**: Check worker callbacks, queue configuration, telemetry events
