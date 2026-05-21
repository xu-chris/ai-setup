---
description: Break down a specific scope into concrete tasks ready for an agent to execute. Run at the start of work on each scope, one scope at a time. Adds tasks to the scopes document.
---

# Break Down a Scope

Read and follow the `shape-up:scope` skill to run this scope breakdown.

The concept is: $ARGUMENTS

If no concept name was provided, list the files in `docs/concepts/` with status `building` and ask the user which one to work on.

Read `docs/concepts/[name].scopes.md` and ask the user which scope to break down if there is more than one scope remaining without tasks.

Also read `docs/concepts/[name].md` to have the full concept — breadboard, rabbit holes, and won't-dos — in view before generating tasks.

Work through the breakdown collaboratively. Derive tasks from the breadboard, sequence them by dependency and uncertainty, name them in domain language, and write acceptance criteria for each.

Add the completed tasks inline to the relevant scope in `docs/concepts/[name].scopes.md` and mark the scope as in progress.
