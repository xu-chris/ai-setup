---
description: Start a shaping session for a concept that has reached Frame Go. Defines the solution at the right level of abstraction and fills the Solution section of the concept document.
---

# Shape a Concept

Read and follow the `shape-up:shape` skill to run this shaping session.

The concept is: $ARGUMENTS

If no concept name was provided, list the files in `docs/concepts/` and ask the user which one to shape.

Before starting, read `docs/concepts/[name].md` and verify the status is `frame-go`. If the status is `candidate`, tell the user the concept needs framing first. If the document does not exist, tell the user to run `/shape-up:frame` first.

Work collaboratively through the shaping steps. Name the elements together, breadboard the flow, identify rabbit holes and their patches, and define dos and won't-dos. Hold the abstraction discipline throughout — redirect to a higher level whenever the conversation slides into implementation detail.

When the three properties check passes, write the completed Solution section into `docs/concepts/[name].md` and set `status: shape-go`.
