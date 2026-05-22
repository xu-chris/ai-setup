---
name: shape
description: Use when a concept document has reached Frame Go and the problem is clear enough to start defining a solution.
---

# Shaping

Shaping is getting to the "we've got it" moment — a shared understanding of what to build that is rough enough to leave implementation judgment to builders, solved enough that nothing critical is hand-waved, and bounded by the appetite set during framing.

Shaping is not a document exercise. The document that comes out is packaging: a way to bring people who weren't in the sessions to the same understanding. The real work is the live thinking, sketching, and back-and-forth that reaches the a-ha moment. Shaping cannot be done alone or by filling in a template.

**Shaping requires senior technical people who know the codebase. Shaping without technical depth is the #1 failure mode. Projects shaped without it churn in build because of unanswered questions that were never surfaced.**

**Before starting:** Read the concept document at `docs/concepts/[name].md`. The status must be `frame-go`. If the problem section is still vague, return to framing — shaping without a clear frame produces the wrong solution.

## The Iron Law

```
APPETITE DOES NOT MOVE. SCOPE ADJUSTS TO FIT IT.
```

Violating the letter of this rule is violating the spirit of it. If the solution doesn't fit the appetite, scope must be cut or the problem must be reframed — the appetite does not flex.

## The Abstraction Discipline

Shaped work lives at the fat-marker sketch level. This is the hardest discipline to hold.

**Keep:** Named building blocks, macro-level connections, flow topology, the wiring of how things work together.

**Reject:** Visual designs, exact copy, database schemas, component libraries, API specs, implementation detail of any kind.

A shaped solution is the blueprint of a house: where the walls go, where the sink goes, where the pipes run. Not the tile, not the paint, not the fixtures. Those decisions happen during building, by the people doing the work.

```
WHEN describing any element or flow step:
  IF you are specifying visual design, exact copy, component names, database schemas, or API specs
    → STOP, elevate the abstraction
  Ask: can the builder make this decision without needing to understand the problem?
  IF yes → leave it out of the shape
```

## The Iterative Boundary

Shaping regularly surfaces questions that require going back to the frame. This is expected — the understanding of both problem and solution deepens together. The first model is always wrong.

```
WHEN a question surfaces during shaping:
  IF it concerns the solution (what should exist, how it connects, what the flow looks like)
    → answer it here, stay in shaping
  IF it concerns the problem (is this the right failure, does this cost what we thought, who actually has this)
    → STOP, invoke frame skill, resolve the framing question
    → resume shaping after frame-go is confirmed
```

Shaping that continues over an unresolved framing question produces a shaped solution to the wrong problem.

When domain questions keep surfacing repeatedly, the right fix is not more round-trips between framing and shaping — it is bringing the domain expert into the shaping session so questions can be answered on the spot and the design can be revised in real time.

## Phase 1: Read the Frame

**Goal:** Absorb the problem, appetite, and language before any solution thinking begins.

Pay close attention to the language in the frame. The words used there must carry through shaping. If the frame says "missed payments," elements and breadboard should say "missed payments" — not "payment status" or "invoice errors." Language drift between frame and shape signals the solution is drifting from the problem.

**Gate:** Appetite is fixed in mind. Frame language is noted. No element naming has begun.

## Phase 2: Name the Elements

**Goal:** Identify the high-level building blocks of the solution.

Elements are not screens, components, or database tables. They are named concepts describing what the solution is made of. Aim for 3–7. More than that usually means the solution is too big for the appetite or not yet abstracted enough.

For each element: what is it, and what does it do for the user? One or two sentences maximum. If it takes more, the element is too detailed or needs to be split.

Name elements in the domain's language. An element name the person who lives with the problem would not recognize is a warning sign.

**Gate:** 3–7 elements, each describable in one or two sentences, named in domain language.

## Phase 3: Breadboard the Flow

**Goal:** Map how users move through the solution using places, affordances, and connections — nothing more.

- **Places:** screens, dialogs, states — anywhere the user finds themselves
- **Affordances:** buttons, fields, links, messages — anything the user can interact with or read
- **Connections:** where an affordance takes the user

```
Place Name
----------
  affordance
  action → Next Place

Next Place
----------
  field or input
  action → Another Place
```

Breadboard the critical path first. Then breadboard significant branches the appetite allows for.

**Gate:** No layout, no visual design, no exact copy, no component names. Only topology: what exists where and how it connects.

```
IF the breadboard contains column widths, component names from a design system, styling notes,
or descriptions of how something looks rather than what it is and where it goes
  → strip it back to places, affordances, and connections
```

## Phase 4: Find the Rabbit Holes

**Goal:** Surface what could unexpectedly expand scope, and patch every one before moving on.

Rabbit holes are things that seem small but could blow up a build cycle from the inside. Any rabbit hole not patched during shaping is a time bomb — it will surface in week three of a six-week cycle when there is no room to absorb it.

For each rabbit hole:
- What parts of this solution touch things we do not fully understand?
- What edge cases could force a much bigger implementation than expected?
- Where does this solution brush up against existing complexity?

Each rabbit hole entry states the risk and its patch — a specific constraint that prevents it from derailing the build.

**Gate:** Every identified rabbit hole has a specific patch. No open rabbit holes.

```
IF a rabbit hole has no patch:
  → either redesign the solution to avoid it
  → or reframe the problem to take it out of scope
  → do not proceed with an open rabbit hole
```

## Phase 5: Define Dos and Won't-Dos

**Goal:** Make every reasonable scope assumption explicit.

Won't-dos are intentional exclusions that protect the appetite, each with a rationale. Dos confirm what is explicitly in scope.

Go through the elements and breadboard and ask: what could someone reasonably assume is included that we are not building? Make those assumptions explicit as won't-dos.

**Gate:** Every reasonable scope assumption is named explicitly — nothing left to inference.

## Phase 6: Three Properties Check

**Goal:** Verify the shaped solution is ready before writing to the document.

Apply these throughout shaping, not only at the end — ongoing discipline catches more than a final check.

**Rough:** Is every element described at high abstraction? Is there room for the builder to make implementation decisions? If too detailed, elevate the abstraction.

**Solved:** Are all elements identified and connected? Is the user flow clear end to end? Is anything critical hand-waved or marked TBD? Unresolved questions in shaping become blockers in building — work them out now.

**Bounded:** Does the solution fit the appetite? Are the won't-dos explicit? Does every rabbit hole have a patch?

**Gate:** All three properties pass.

```
IF any property fails → keep shaping. Do not write a shape-go that is not actually shaped.
```

## Output

When the three properties pass, write to the Solution section of `docs/concepts/[name].md` and set `status: shape-go`.

**Shape Go means:** "We can give this to someone to build and they will know what to do. No material unknowns from a technical or interaction standpoint."

The document captures the a-ha moment in packaging form. It should bring anyone who reads it to the same understanding reached in the shaping sessions — without them having been there.

## Red Flags

| If you're thinking... | Do this |
|---|---|
| "I'll shape this from notes without a technical person" | STOP — shaping without technical depth produces undershaped work |
| "I'm continuing but there's a framing question I haven't resolved" | STOP — return to framing, resume after frame-go confirmed |
| "The rabbit hole might not matter in practice" | STOP — every rabbit hole needs a patch |
| "I'll add design details to make it clearer" | STOP — you've left fat-marker level |
| "The element count is over 7 but they're all necessary" | The solution is too big for the appetite, or not yet abstracted enough |
| "I'm using different words than the frame used" | Language drift — return to frame language |
| "I'll mark this TBD and resolve it in building" | Unresolved questions in shaping become blockers in building |

## Rationalization Table

| Excuse | Reality |
|---|---|
| "The appetite can flex a little" | Appetite is fixed. Scope adjusts. Not the other way. |
| "A non-technical shaper is fine" | The #1 failure mode. Projects churn because of unanswered technical questions. |
| "This detail is necessary for clarity" | If the builder can make the decision, leave it out |
| "The rabbit hole probably won't come up" | Rabbit holes always come up. Patch them now or pay for it in week three. |
| "We can figure out the framing question as we go" | Shaping over an unresolved framing question produces the wrong solution |
| "The document IS the shaping" | The document is packaging. The shaping is the live sessions and the thinking. |

## Quick Reference

| Phase | Key Activity | Gate |
|---|---|---|
| 1. Read the Frame | Absorb appetite and language | Appetite fixed in mind, language noted |
| 2. Name Elements | 3–7 building blocks in domain language | Each in 1–2 sentences, no technical terms |
| 3. Breadboard | Places, affordances, connections only | No visual design, no component names |
| 4. Rabbit Holes | Identify risks, patch each one | Every rabbit hole has a specific patch |
| 5. Dos and Won't-Dos | Make all scope assumptions explicit | Nothing left to inference |
| 6. Three Properties | Rough, solved, bounded | All three pass before writing |
