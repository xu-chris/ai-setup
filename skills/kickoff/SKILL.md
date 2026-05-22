---
name: kickoff
description: Use when a concept has been bet on and building is about to begin.
---

# Building Kickoff

Kickoff transitions from concept to execution. It is a live session with the full build team — backend, frontend, designer, QA — where the shaped work is understood together and broken into vertical scopes that can be built and demoed independently.

The kickoff has two parts. First: tour the document together. Second: map the scopes together.

The output is a separate scopes document at `docs/concepts/[name].scopes.md`. The concept document is not modified during kickoff — it remains the reference. The scopes document is the working plan.

**No code is written during kickoff. The output is a scopes document, not a pull request.**

**Before starting:** Read `docs/concepts/[name].md`. The status must be `bet`. If shaping or betting is incomplete, do not proceed. A kickoff from fuzzy shaped work produces confused scopes.

## The Iron Law

```
SCOPES ARE VERTICAL SLICES. TACKLE HIGHEST UNCERTAINTY FIRST.
```

Violating the letter of this rule is violating the spirit of it. A scope organized by layer — all backend, all frontend — is not a vertical slice. A cycle that saves the hardest problem for last will not finish on time.

## Part 1: Document Tour

**Goal:** Bring everyone to the same understanding of the problem, solution, and constraints before any scope discussion.

Walk through the concept document together. Cover: the problem being solved, the appetite, the elements, the breadboard, the rabbit holes and their patches, and the won't-dos. Answer questions. This is not a review — it is a shared a-ha session for people who weren't in the shaping sessions.

While walking through, collect every ambiguity: gaps in the breadboard, elements whose connection to the user flow is not obvious, rabbit holes that feel underspecified. Do not move to scopes until these are resolved.

**Gate:** Everyone understands what is being built and why. All ambiguities from the document tour are resolved.

```
IF ambiguities remain after the document tour → resolve them before proposing scopes
  Scopes defined over gaps produce work that stalls mid-cycle
```

## Part 2: Investigate the Existing System

**Goal:** Understand what already exists before proposing scopes.

Before mapping scopes, search the codebase for code relevant to the concept: existing data models, API endpoints, UI components, utilities, conventions. Read the files the breadboard sections will touch. Note which patterns are established and which areas are new territory.

Scopes derived from code reality are more accurate than scopes derived from the breadboard alone. A missing foundation discovered at kickoff costs far less than one discovered mid-cycle.

Document key findings — these become the "Existing System Context" section of the scopes document.

**Gate:** Can name the reusable components, established patterns, and areas of new territory before proposing scopes.

```
IF investigation reveals an unpatched rabbit hole or a critical gap not addressed in the concept document:
  → STOP. Do not proceed to scope mapping.
  → Surface what was found: where it is in the code, why it matters, what the risk is.
  → Get a decision: patch with a constraint, return concept to shaping, or adjust scope.
```

## Part 3: Map the Scopes Together

**Goal:** Break the work into vertical slices at the whiteboard with the full team.

**Step 1 — Brain dump.** Before grouping anything, list every implementation task you can think of from the breadboard. Do not organize yet. The dump forces you to consider the full concept before committing to any starting point.

**Step 2 — Group into scopes.** Look for natural clusters in the task list — tasks that belong together because they deliver one demoable thing. Group the tasks first, then name the group. Do not name a scope before its tasks are grouped — names applied before grouping import pre-conceived categories rather than letting the actual work define the slice.

A vertical slice cuts through all layers needed to deliver one demoable thing — backend, frontend, and everything in between. It is not a layer.

Each scope:
- Delivers one demoable capability
- Cuts across all layers needed to make it work
- Can be built without depending on unfinished work from other scopes, or has explicit dependencies stated

The scope count is fixed at nine or fewer. More than that means the scopes are too granular or the concept is too large for one cycle.

Name scopes in domain language — what they deliver, not what layer they touch. "Payment recovery flow" not "backend work." "Missed payments panel" not "frontend components."

A scope is ready when someone can answer: what will I be able to demo when this scope is done?

**Gate:** Present proposed scopes to the full team and confirm before writing anything.

```
IF scope count exceeds 9 → too granular; regroup around demoable outcomes
IF any scope is named as a layer → regroup around vertical behavior
IF scopes were named before tasks were grouped → regroup without the names; let the tasks drive the shape
```

## Part 4: Sequence by Uncertainty

**Goal:** Put highest uncertainty first so problems surface when there is still time to recover.

Scopes touching rabbit holes from shaping, scopes that depend on things not fully understood, scopes reaching into unfamiliar areas of the system — these carry higher uncertainty and go first.

The fastest way to identify uncertain scopes: mark the ones that are routine and familiar first. What is not marked is the uncertain territory. Start there.

A critical unknown discovered in week five of a six-week cycle leaves no room to recover. The same unknown discovered in week one is solvable — there is time to investigate, regroup, and still ship.

Wiring before finish: build something that works before making it look right. A scope that is functionally correct but visually rough is further along than one that looks polished but does not connect to real data or logic. Polish is the last scope, not the first priority.

**Gate:** Highest-uncertainty scope is assigned to be tackled first. Build sequence is explicit.

## Part 5: Confirm Against Appetite

**Goal:** Verify total scope fits the appetite set during framing.

```
IF total scope exceeds appetite:
  IF scopes can be cut → cut at the scope level, not at the task level within a scope
    Won't-dos from shaping stay won't-dos
  IF no scope can be cut → simplify one scope's boundary to a smaller demoable outcome
  IF neither works → return the concept to framing with the new understanding
    This is not failure — it is the process discovering that appetite and problem were not calibrated

Do not proceed to building with more work than the appetite covers.
A cycle that begins over-scoped ends without a finished thing.
```

**Gate:** Total scope fits the appetite. Any cuts are confirmed and recorded.

## Output

Write `docs/concepts/[name].scopes.md`:

```markdown
---
concept: docs/concepts/[name].md
status: building
---

# Scopes: [Concept Name]

## What We're Building
[Two or three sentences: problem being solved and shaped approach. Enough context to orient anyone reading the scopes document on its own.]

## Existing System Context
[Reusable components, established patterns, areas where this work extends existing behavior, areas where it introduces something new. Prevents each scope from being planned in isolation.]

## Scopes

### [Scope Name]
[What this scope delivers. What can be demoed when it is done.]

**Uncertainty:** low / medium / high
**Depends on:** none | [other scope name]

## Sequence
[Which scope to tackle first and why. Order of the rest with brief rationale for non-obvious sequencing.]

## Appetite Check
[Total scopes vs. appetite. What was cut to fit, if anything.]
```

Update the Build section of the concept document with a link to the scopes document and set `status: building`.

## Red Flags

| If you're thinking... | Do this |
|---|---|
| "I'll propose scopes before reading the full concept" | STOP — document tour comes first |
| "Scopes organized by layer are easier to track" | STOP — layers are not vertical slices |
| "We'll start with the easiest scope to build momentum" | STOP — highest uncertainty goes first |
| "13 scopes is fine, they're small" | Too granular; regroup around demoable outcomes |
| "I'll resolve the ambiguity during building" | STOP — resolve before proposing scopes |
| "The document tour is just a formality, we all read it" | The tour surfaces ambiguities. Run it. |

## Rationalization Table

| Excuse | Reality |
|---|---|
| "Organizing by layer is cleaner to implement" | Layer-organized work produces integration problems at the end of the cycle |
| "Starting easy builds momentum" | Starting easy leaves the hardest problem for last. Cycles end without finished things. |
| "More scopes means more granularity means more control" | More than nine means the concept is too large or the breakdown is too fine |
| "We can over-scope and cut later" | Over-scoped cycles never finish cleanly. Cut before building begins. |
| "Wiring and polish can happen in parallel" | Wiring must be confirmed before polish is worth doing. Wire first. |
| "Starting at the beginning and working forward is natural" | Top-to-bottom execution hits critical unknowns in week four or five. By then there is no time to recover. |

## Quick Reference

| Phase | Key Activity | Gate |
|---|---|---|
| 1. Document Tour | Walk through concept with full team, collect ambiguities | All ambiguities resolved |
| 2. Investigate System | Read relevant code, find reusable patterns | Can name reusable components and new territory |
| 3. Map Scopes | Vertical slices, max 9, domain language | Team confirms scope list before writing |
| 4. Sequence | Highest uncertainty first, wiring before finish | Highest-uncertainty scope is first |
| 5. Appetite Check | Verify total scope fits | Fits, or cuts confirmed |
