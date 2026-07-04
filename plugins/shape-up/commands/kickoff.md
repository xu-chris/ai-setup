---
description: Run a building kickoff for a concept that has been bet on. Breaks the shaped work into vertical scopes and produces the scopes document that guides the build cycle.
---

# Kick Off a Concept

Read and follow the `shape-up:kickoff` skill to run this kickoff session.

The concept is: $ARGUMENTS

If no concept name was provided, list the files in `docs/concepts/` with status `bet` and ask the user which one to kick off.

Before starting, read `docs/concepts/[name]/frame.md` and verify the status is `bet`. If the status is `shape-go`, tell the user the concept needs a betting decision first. If earlier, direct the user to the appropriate phase.

Read the full concept document — problem, appetite, elements, breadboard, rabbit holes, won't-dos — before proposing any scopes. The breadboard is the primary input.

Work through the scope definition collaboratively. Name the scopes, surface uncertainty, and propose a sequence that addresses the highest-risk work first.

Write the completed scopes document to `docs/concepts/[name]/slices.md` and update the Build section and status in `docs/concepts/[name]/frame.md`.
