---
name: scope
description: Use when a scopes document exists and building is ready to begin on a specific scope.
---

# Scope Breakdown

Scope breakdown translates one scope from the scopes document into a concrete sequence of tasks. It happens at the start of work on that scope — not all at once before building begins. Breaking down all scopes upfront produces plans that are wrong by the time you reach them. Learning from each scope informs the next.

**One scope at a time. Work through it. Learn. Then break down the next.**

**Before starting:** Read `docs/concepts/[name].scopes.md` and identify the scope to break down. Also read `docs/concepts/[name].md` to have the full concept in view. Tasks must stay within the scope boundary and respect the won't-dos.

## The Iron Law

```
ONE SCOPE AT A TIME. BREAK DOWN AT THE START OF THAT SCOPE, NOT ALL UPFRONT.
```

Violating the letter of this rule is violating the spirit of it. Plans written far in advance are wrong when executed — each scope teaches something that changes what comes next.

## Phase 1: Understand What the Scope Delivers

**Goal:** Know the demoable outcome before breaking down any tasks.

Read the scope entry in the scopes document. Every task must contribute to reaching the demoable outcome described there.

**Gate:** Can state the demoable outcome in one sentence before any task breakdown begins.

```
IF the scope description is vague → clarify with the user before proceeding
  A vague scope produces tasks that point in different directions
```

## Phase 2: Work from the Breadboard

**Goal:** Produce a flat list of what needs to exist for this flow to work end to end.

Walk through the breadboard sections in the concept document that belong to this scope. Ask: what has to be built for this flow to work end to end? Keep it as a flat list — do not organize by layer yet.

Then check for vertical coverage. A vertical slice reaches through all layers needed to produce a demoable behavior: from the data or logic that drives it, through whatever connects them, to the interface the user touches.

```
IF all items in the list are backend work → regroup around behavior
  What must come together across all layers to make this flow demoable?
IF all items are UI work → same: what must come together to make this scope work end to end?
```

**Gate:** List covers all layers needed to produce the demoable outcome.

## Phase 3: Investigate the Relevant Code

**Goal:** Read code before sequencing tasks — not after.

Search for existing implementations related to the breadboard places and affordances: data models, queries, API handlers, UI components, utilities. Understand what already exists, what patterns are established, and where this scope extends or modifies existing behavior.

Tasks derived from code reality are more precise than tasks derived from the breadboard alone. Discovering a missing dependency during breakdown costs less than discovering it mid-scope.

```
IF investigation reveals complexity significantly beyond what the concept document suggested
  → STOP. Do not continue. Surface what was found.

IF investigation surfaces an unpatched rabbit hole:
  → STOP. State clearly: where it is in the code, why it is more complex than expected, what the risk is.
  → Get a decision before proceeding.
  Options: patch with a constraint, narrow the scope, return concept to shaping.
  Continuing without a decision turns a shaping gap into a build failure.
```

**Gate:** Can name existing patterns this scope reuses and the areas that are new territory.

## Phase 4: Sequence by Dependency and Uncertainty

**Goal:** Order tasks so each builds on the previous, with unknowns addressed early.

The first task establishes the foundation the other tasks depend on. If the scope has a rabbit hole identified in the concept document, the task that addresses it comes early.

**Wiring before finish.** Tasks that get the mechanics working come before tasks that make things look right. A scope is done when it works, not when it is polished. Polish is the last task, not the first priority. Very often, wiring with raw or inherited UI is enough to confirm the mechanics — high fidelity comes after the wiring is confirmed.

Not every task needs the same level of finish. For well-understood, routine work (standard auth flows, known patterns), a stub that unblocks more critical tasks is enough — move through the known quickly and put focus on the unknown. A stub is not an excuse to skip the unknown; it is a way to sequence effort correctly.

Where tasks are independent, flag them explicitly — they can run in parallel.

**Gate:** Task list is ordered with highest-uncertainty tasks first. Dependencies are explicit.

## Phase 5: Write Acceptance Criteria

**Goal:** Give each task a specific, observable done condition.

For each task: one to three acceptance criteria describing behavior, not implementation.

- "The panel shows the three most recent missed payments for the current member" — behavior ✓
- "The query returns results" — implementation ✗

**Gate:** Every acceptance criterion describes observable behavior. If criteria are hard to write, the task is too vague — restate it until the done condition is clear.

## Phase 6: Propose and Confirm

**Goal:** Get user confirmation before writing tasks to the scopes document.

Present the task list, walk through the sequence, and confirm the acceptance criteria make sense to someone who understands the problem. Adjust based on feedback.

**Gate:** User has confirmed before tasks are written to the scopes document. The breakdown is complete when confirmed, not when generated.

## Staying Inside the Scope

```
IF a task seems necessary but falls outside the scope's stated boundary
  → flag it explicitly. Either it belongs to a different scope, or the boundary needs renegotiating.

IF investigation reveals the demoable outcome can be reached by cutting something the scope included
  → surface it explicitly and confirm before writing
  Silently shrinking scope is as much of a problem as silently expanding it.
```

## When the Scope Is Larger Than Expected

```
IF task list grows beyond 10 tasks → STOP. Do not continue generating tasks.
  Surface: what was found, why it is more complex than expected, what the options are.
  Options:
    - Narrow the scope by cutting tasks not essential to the demoable outcome
    - Split the scope into two
    - Accept the larger scope and adjust the cycle's remaining appetite
  This decision belongs to the person who bet on this cycle.
  Do not resolve it by silently expanding the task list.
```

## Output

Add tasks inline to the relevant scope in `docs/concepts/[name].scopes.md`:

```markdown
#### [Task Name]
[One sentence describing what to do.]

**Done when:**
- [Specific, observable condition]
- [Specific, observable condition]

**Depends on:** [task name] or none
**Can run in parallel with:** [task name] or none
```

After adding all tasks, update the scope's status from `building` to `in progress`.

```
IF superpowers is available:
  → invoke superpowers:writing-plans for this scope
    The scope description, demoable outcome, and "Done when:" conditions are the spec
    writing-plans adds the implementation layer: file structure, TDD task sequence, exact code, exact commands
    Shape Up ends here — building begins with superpowers
ELSE:
  → implement the tasks directly using the confirmed task list and acceptance criteria as the guide
```

## Red Flags

| If you're thinking... | Do this |
|---|---|
| "I'll break down all scopes now while I'm thinking about it" | STOP — one scope at a time, at the start of that scope |
| "Tasks named by layer are clearer" | Regroup around behavior — layer names are not task names |
| "This acceptance criterion describes the implementation" | Rewrite it to describe observable behavior |
| "The task list is 14 items but they're all necessary" | STOP — surface the situation, do not continue |
| "I'll just include this task, it's obviously in scope" | Flag it explicitly — obvious is not confirmed |
| "I'll quietly narrow the scope to make it fit" | Surface it and confirm — silently shrinking is the same problem as silently expanding |

## Rationalization Table

| Excuse | Reality |
|---|---|
| "Breaking down all scopes upfront is more efficient" | Plans for future scopes are wrong when you reach them |
| "The task names make sense to me" | Task names must be traceable to the problem in domain language |
| "Acceptance criteria are obvious from the task name" | Unwritten criteria are not criteria — write them |
| "The rabbit hole is smaller than it looks" | Unpatched rabbit holes surface in build. Surface them now. |
| "High fidelity now saves time later" | Wire first. Confirm the mechanics. Polish after. |

## Quick Reference

| Phase | Key Activity | Gate |
|---|---|---|
| 1. Understand Scope | State the demoable outcome | One sentence before any task |
| 2. Breadboard | Flat list of what needs to exist | Covers all layers |
| 3. Investigate Code | Read relevant code | Can name reusable patterns and new territory |
| 4. Sequence | Uncertainty first, wiring before finish | Highest uncertainty tasks first |
| 5. Acceptance Criteria | Behavior-based done conditions | Every criterion is observable behavior |
| 6. Confirm | Present to user before writing | User confirmed before tasks written |
