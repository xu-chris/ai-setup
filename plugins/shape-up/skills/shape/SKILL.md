---
name: shape
description: Use when a concept document has reached Frame Go and the problem is clear enough to start defining a solution.
---

# Shaping

Shaping is getting to the "we've got it" moment - a shared understanding of what to build that is rough enough to leave implementation judgment to builders, solved enough that nothing critical is hand-waved, and bounded by the appetite set during framing.

Shaping is not a document exercise. The document that comes out is packaging: a way to bring people who weren't in the sessions to the same understanding. The real work is the live thinking, sketching, and back-and-forth that reaches the a-ha moment. Shaping cannot be done alone or by filling in a template.

**Shaping requires senior technical people who know the codebase. Shaping without technical depth is the #1 failure mode. Projects shaped without it churn in build because of unanswered questions that were never surfaced.**

**Before starting:** Read `docs/concepts/[name]/frame.md`. The status must be `frame-go`. If the problem section is still vague, return to framing - shaping without a clear frame produces the wrong solution.

## The Iron Law

```
APPETITE DOES NOT MOVE. SCOPE ADJUSTS TO FIT IT.
```

Violating the letter of this rule is violating the spirit of it. If the solution doesn't fit the appetite, scope must be cut or the problem must be reframed - the appetite does not flex.

## The Abstraction Discipline

Shaped work lives at the fat-marker sketch level. This is the hardest discipline to hold.

**Keep:** Named building blocks, macro-level connections, flow topology, the wiring of how things work together.

**Reject:** Visual designs, exact copy, database schemas, component libraries, API specs, implementation detail of any kind.

A shaped solution is the blueprint of a house: where the walls go, where the sink goes, where the pipes run. Not the tile, not the paint, not the fixtures. Those decisions happen during building, by the people doing the work.

This discipline governs shape part descriptions. The breadboarding skill defines its own abstraction standard for affordances.

```
WHEN describing any shape part or flow step:
  IF you are specifying visual design, exact copy, component names, database schemas, or API specs
    → STOP, elevate the abstraction
  Ask: can the builder make this decision without needing to understand the problem?
  IF yes → leave it out of the shape
```

## The Iterative Boundary

Shaping regularly surfaces questions that require going back to the frame. This is expected - the understanding of both problem and solution deepens together. The first model is always wrong.

```
WHEN a question surfaces during shaping:
  IF it concerns the solution (what should exist, how it connects, what the flow looks like)
    → answer it here, stay in shaping
  IF it concerns the problem (is this the right failure, does this cost what we thought, who actually has this)
    → STOP, invoke frame skill, resolve the framing question
    → resume shaping after frame-go is confirmed
```

Shaping that continues over an unresolved framing question produces a shaped solution to the wrong problem.

When domain questions keep surfacing repeatedly, the right fix is not more round-trips between framing and shaping - it is bringing the domain expert into the shaping session so questions can be answered on the spot and the design can be revised in real time.

## Phase 1: Read the Frame

**Goal:** Absorb the problem, appetite, and language before any solution thinking begins.

Pay close attention to the language in the frame. The words used there must carry through shaping. If the frame says "missed payments," shape parts and the breadboard should say "missed payments" - not "payment status" or "invoice errors." Language drift between frame and shape signals the solution is drifting from the problem.

**Gate:** Appetite is fixed in mind. Frame language is noted. No shaping operations have begun.

## Shaping Operations

After reading the frame, the following operations can be performed in any order. They inform each other - R and S are refined together, and the fit check drives which shape advances.

### R - Requirements

Requirements define the problem space.

- Number them R0, R1, R2...
- Track status per requirement: Core goal / Must-have / Undecided / Nice-to-have / Out
- R states what's needed, not how to satisfy it. Satisfaction is shown in a fit check.
- Never more than 9 top-level requirements. Group related ones as R3.1, R3.2 if needed.

```
| ID | Requirement | Status |
|----|-------------|--------|
| R0 | [statement] | Core goal |
| R1 | [statement] | Must-have |
```

Always show the full requirements table - never summarize or abbreviate.

When re-rendering the table after changes, mark changed cells with 🟡.

### S - Shapes

Shapes are solution options. Letters A, B, C... are mutually exclusive - you pick one.

Each shape gets a short descriptive title: `A: [title]`. Good titles capture the essence of the approach in a few words.

Parts within a shape use the shape's letter plus a number: A1, A1.1, A1.2... Start flat; add hierarchy only when grouping aids understanding.

Shape parts describe mechanisms - what to BUILD or CHANGE. They are not intentions or constraints.

Mark flagged unknowns with ⚠️ in a Flag column: the mechanism is described at a high level but HOW is not yet known.

```
| Part | Mechanism | Flag |
|------|-----------|:----:|
| A1   | [mechanism] | |
| A2   | [mechanism] | ⚠️ |
```

**CURRENT** is a reserved shape name for the existing system baseline. Use it in fit checks as the starting point.

Always show full shape tables - never summarize or abbreviate.

When re-rendering after changes, mark changed cells with 🟡.

### Fit Check

The fit check is the decision matrix comparing shapes against requirements. Requirements are rows; shapes are columns.

```
| ID | Requirement | Status | CURRENT | A | B |
|----|-------------|--------|---------|---|---|
| R0 | [statement] | Core goal | ❌ | ✅ | ✅ |
| R1 | [statement] | Must-have | ✅ | ✅ | ❌ |
```

Rules:
- Fit check is binary only: ✅ (passes) or ❌ (fails). No other values.
- A flagged unknown (⚠️) on any part makes the fit check ❌ for requirements that part addresses. You cannot claim what you don't know.
- Shape columns contain only ✅ or ❌ - explanations go in a Notes section below the table.
- Always show full requirement text. Never abbreviate.

When re-rendering after changes, mark changed cells with 🟡.

If a shape passes all checks but still feels wrong, there is a missing requirement. Articulate the implicit constraint as a new R, then re-run the fit check.

### Spikes

A spike investigates a flagged unknown (⚠️) and returns with concrete information about how to build the mechanism.

Write spikes as sub-sections in `shape.md` (not separate files).

Structure:
- **Context** - why we're investigating
- **Questions** - specific questions about mechanics, not effort
- **Findings** - what was learned

Good spike questions ask about mechanics: "Where is the X logic?", "What changes are needed to achieve Y?", "How do we perform Z?"

Avoid: effort estimates, vague questions, yes/no questions that don't reveal mechanics.

A spike is complete when you can describe the concrete steps needed. After a spike resolves a ⚠️, update the part's mechanism description and re-run the fit check.

### Breadboard

Invoke `shape-up:breadboarding` when the winning shape is clear enough to wire. Breadboard output is written into `shape.md`.

Do not proceed to Phase 4 until breadboarding is complete with no gaps in the play-through.

### Detailing a Shape

When expanding a selected shape into affordances, use "Detail A" notation - not a new letter. Shape letters (A, B, C) are mutually exclusive alternatives. Detailing is a breakdown of the selected shape, not a sibling option.

```
A, B, C = alternatives (pick one)
Detail A = expansion of A (not a choice)
```

## Phase 4: Find the Rabbit Holes

**Goal:** Surface what could unexpectedly expand scope, and patch every one before moving on.

Rabbit holes are things that seem small but could blow up a build cycle from the inside. Any rabbit hole not patched during shaping is a time bomb - it will surface in week three of a six-week cycle when there is no room to absorb it.

For each rabbit hole:
- What parts of this solution touch things we do not fully understand?
- What edge cases could force a much bigger implementation than expected?
- Where does this solution brush up against existing complexity?

Each rabbit hole entry states the risk and its patch - a specific constraint that prevents it from derailing the build.

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

Go through the shapes and breadboard and ask: what could someone reasonably assume is included that we are not building? Make those assumptions explicit as won't-dos.

Do not declare Shape Go until you have produced an explicit Won't-Dos list. Decisions made in framing do not carry over automatically - restate them here. A reader who was not in the framing conversation must be able to understand what is excluded and why.

**Gate:** Every reasonable scope assumption is named explicitly - nothing left to inference.

## Phase 6: Three Properties Check

**Goal:** Verify the shaped solution is ready before writing to the document.

Apply these throughout shaping, not only at the end - ongoing discipline catches more than a final check.

**Rough:** Is every shape part described at high abstraction? Is there room for the builder to make implementation decisions? If too detailed, elevate the abstraction.

**Solved:** Are all shape parts identified and connected? Is the user flow clear end to end? Are there any open ⚠️ flags? Unresolved questions in shaping become blockers in building - work them out now.

**Bounded:** Does the solution fit the appetite? Are the won't-dos explicit? Does every rabbit hole have a patch?

**Gate:** All three properties pass. For each property, state the evidence - not the intention.

- "Rough: ✓" is not evidence. "Rough: parts described as named mechanisms, no database schema, no component names, no exact copy" is evidence.
- "Solved: ✓" is not evidence. "Solved: all parts connected in breadboard, no open ⚠️ flags, open question about X resolved as Y" is evidence.
- "Bounded: ✓" is not evidence. "Bounded: Won't-Dos list produced, crew/cast excluded, file upload excluded, appetite fits build estimate" is evidence.

```
IF any property fails → keep shaping. Do not write a shape-go that is not actually shaped.
IF the check passes in under a minute → you have not done it.
```

## Output

When the three properties pass, write to `docs/concepts/[name]/shape.md` (create the folder if it does not exist). The file must begin with this frontmatter:

```
---
shaping: true
status: shape-go
---
```

**Shape Go means:** "We can give this to someone to build and they will know what to do. No material unknowns from a technical or interaction standpoint."

The document captures the a-ha moment in packaging form. It should bring anyone who reads it to the same understanding reached in the shaping sessions - without them having been there.

`shape.md` is the ground truth for R, shapes, fit checks, spikes, and breadboard. Changes here ripple to `slices.md` and to any `S#-plan.md` files below it.

## Red Flags

| If you're thinking... | Do this |
|---|---|
| "I'll shape this from notes without a technical person" | STOP - shaping without technical depth produces undershaped work |
| "I'm continuing but there's a framing question I haven't resolved" | STOP - return to framing, resume after frame-go confirmed |
| "The rabbit hole might not matter in practice" | STOP - every rabbit hole needs a patch |
| "I'll add design details to make it clearer" | STOP - you've left fat-marker level |
| "I'm using different words than the frame used" | Language drift - return to frame language |
| "I'll mark this TBD and resolve it in building" | Unresolved questions in shaping become blockers in building |
| "R and S say the same thing" | R states the need; S describes the mechanism. If they're identical, the shape part adds no information. |
| "A shape part is a horizontal layer ('Data model', 'Schema')" | Co-locate data structures with the feature that needs them - shape parts should be vertical slices |
| "Continuing with an open ⚠️ without a spike" | A flagged unknown cannot pass a fit check. Spike it or descope it. |

## Rationalization Table

| Excuse | Reality |
|---|---|
| "The appetite can flex a little" | Appetite is fixed. Scope adjusts. Not the other way. |
| "A non-technical shaper is fine" | The #1 failure mode. Projects churn because of unanswered technical questions. |
| "This detail is necessary for clarity" | If the builder can make the decision, leave it out |
| "The rabbit hole probably won't come up" | Rabbit holes always come up. Patch them now or pay for it in week three. |
| "We can figure out the framing question as we go" | Shaping over an unresolved framing question produces the wrong solution |
| "The document IS the shaping" | The document is packaging. The shaping is the live sessions and the thinking. |
| "The element count is over 7 but they're all necessary" | Never used to say this - now requirements drive shape parts, not element count |

## Quick Reference

| Phase | Key Activity | Gate |
|---|---|---|
| 1. Read the Frame | Absorb appetite and language | Appetite fixed in mind, language noted |
| 2. Define R | Requirements with status | Core goal, Must-have confirmed before fit check |
| 3. Draft shapes | A/B/C with titles, parts, ⚠️ flags | Parts are mechanisms, not intentions |
| 4. Fit Check | Binary ✅/❌, CURRENT baseline | No open ⚠️ in winning shape |
| 5. Spike unknowns | Investigate ⚠️ parts | All flags resolved before Shape Go |
| 6. Breadboard | Invoke shape-up:breadboarding | No gaps in play-through |
| 7. Rabbit Holes | Identify risks, patch each one | Every rabbit hole has a specific patch |
| 8. Dos and Won't-Dos | Make all scope assumptions explicit | Nothing left to inference |
| 9. Three Properties | Rough, solved, bounded | All three pass with evidence before writing |
