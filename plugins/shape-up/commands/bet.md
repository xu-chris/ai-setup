---
description: Run a betting session for a shaped concept. Evaluates whether to commit a cycle to building it. Fills the Bet section of the concept document and sets the final status before building begins.
---

# Bet on a Concept

Read and follow the `shape-up:bet` skill to run this betting session.

The concept is: $ARGUMENTS

If no concept name was provided, list the files in `docs/concepts/` with status `shape-go` and ask the user which one to evaluate.

Before starting, read `docs/concepts/[name]/frame.md` and `docs/concepts/[name]/shape.md`. Verify the status in `frame.md` is `shape-go`. If the status is `frame-go`, tell the user shaping needs to happen first. If the status is `candidate`, tell the user framing is still needed.

Work through the five questions critically. Do not rush toward yes. The value of this session is in surfacing any reason to say no before time is committed.

When the decision is made, write the Bet section into `docs/concepts/[name]/frame.md` and set the status to `bet` or back to `candidate` accordingly.
