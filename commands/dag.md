---
description: Generate a dependency graph for the current concept's scopes or tasks.
argument-hint: "[concept-name] [slice-number]"
---

# Generate Dependency Graph

Read and follow the `shape-up:dag` skill.

If a slice number is given (e.g. `S1`), read `docs/concepts/$ARGUMENTS/S1-plan.md` and generate a task-level DAG.

If only a concept name is given, read `docs/concepts/$ARGUMENTS/slices.md` and generate a scope-level DAG.

If no argument is given, look for a concept with `status: building` in `docs/concepts/` and generate the scope-level DAG for it.
