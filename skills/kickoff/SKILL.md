---
description: Use when a concept has been bet on and building is about to begin. Reads the full concept document and breaks the shaped work into vertical scopes. Produces a scopes document as the handoff to building. This is the first act of the build phase, not the last act of shaping.
---

# Building Kickoff

Kickoff is the transition from concept to execution. It reads the full concept document (problem, solution, breadboard, rabbit holes, dos, and won't-dos) and breaks the work into vertical scopes that can be built and demoed independently.

The output is a separate scopes document at `docs/concepts/[name].scopes.md`. The concept document is not modified during kickoff. It remains the reference. The scopes document is the working plan.

Before starting: read `docs/concepts/[name].md`. The status must be `bet`. If shaping or betting is incomplete, do not proceed. A kickoff from fuzzy shaped work produces confused scopes.

## What a Scope Is

A scope is a vertical slice of the work. Vertical means it cuts through all layers needed to deliver one demoable thing, from whatever data or logic is required down to the interface the user touches. It is not a layer (all the backend work, all the frontend work). It is not a feature list. It is a unit of the solution that can be shown working on its own.

Aim for no more than nine scopes. More than that usually means the scopes are too granular, or the concept is larger than one cycle.

A scope is ready when someone can answer: what will I be able to demo when this scope is done?

## How to Run the Kickoff

### Step 1: Read the Concept and Flag Ambiguities

Read the full concept document. Absorb the problem, the appetite, the elements, the breadboard, the rabbit holes and their patches, and the won't-dos. The breadboard is the primary input for scope definition. It shows what places and flows need to exist and how they connect.

While reading, note any parts of the concept that are unclear or underspecified. Gaps in the breadboard, rabbit holes without clear patches, or elements whose connection to the user flow is not obvious: these will affect scope definition. Collect them now. Resolve them with the user before proposing scopes.

### Step 2: Investigate the Existing System

Before proposing scopes, understand what already exists. Search the codebase for code relevant to the concept: existing data models, API endpoints, UI components, utilities, and conventions. Read the files that the breadboard sections will touch. Note which patterns are already established and which areas are new territory.

Scopes derived from code reality are more accurate than scopes derived from the breadboard alone. Reusing an existing pattern is faster than building one. Discovering a missing foundation during scope breakdown, rather than now, costs more.

If this is a new project with no prior codebase, use this step to confirm that foundational technology choices implied by the concept are settled and understood.

Document the key findings. The scopes document will include an "Existing System Context" section that records what was found: reusable components, established patterns, areas where the concept extends existing behavior, and areas where it introduces something new. This context carries into scope breakdown and prevents each scope from being broken down in isolation from what the rest of the system looks like.

### Step 3: Identify and Propose Scopes

Walk through the breadboard and group the work into vertical slices. Each scope should:
- Deliver one demoable capability
- Cut across all layers needed to make it work
- Be buildable without depending on unfinished work from other scopes, or have explicit dependencies stated

Use the elements from the concept document as a starting point, but do not map elements to scopes one-to-one. Elements are conceptual building blocks. Scopes are units of execution. One element may span multiple scopes. Multiple elements may collapse into one scope.

Name each scope in domain language: what it delivers, not what layer it touches. "Payment recovery flow" not "backend work." "Missed payments panel" not "frontend components."

Present the proposed scopes to the user before writing the document. Describe what each scope delivers and its uncertainty level. Work through any disagreements. Adjust based on feedback. Write the scopes document only after the scope list and sequence are confirmed.

### Step 4: Surface Uncertainty

Not all scopes carry equal risk. Scopes that touch rabbit holes identified during shaping, or that depend on things not fully understood, or that reach into unfamiliar areas of the existing system carry higher uncertainty. Name the uncertainty explicitly in the scopes document.

Tackle the highest-uncertainty scope first. A critical unknown discovered in week five of a six-week cycle leaves no room to recover: the cycle ends without a finished thing. The same unknown discovered in week one is a solvable problem: there is time to investigate, regroup, and still deliver. Put uncertainty first so that if something breaks, it breaks early.

### Step 5: Set the Sequence

Propose a build sequence. State which scope to tackle first and why. Note any dependencies between scopes, where one scope's output is required before another can begin.

Wiring comes before finish. Build something that works before making it look right. A scope that is functionally correct but visually rough is further along than one that looks polished but does not connect to real data or logic. Polish happens last, when the wiring is confirmed.

### Step 6: Confirm Against the Appetite

Check the total scope of work against the appetite set during framing. If the scopes as defined exceed the appetite, there are three options:

**Cut scopes.** Remove or simplify whole scopes until the work fits. Cut at the scope level, not at the task level within a scope. The won't-dos from shaping stay won't-dos.

**Simplify a scope.** Sometimes a scope can be narrowed to a smaller demoable outcome that still delivers value. This is different from cutting — the scope stays, but its boundary shrinks.

**Reframe the problem.** If cutting and simplifying still leave the work too large, the problem itself may have been framed too broadly. Return the concept to framing with the new understanding gained during kickoff. This is not a failure: it is the process discovering that the appetite and the problem were not yet calibrated to each other.

Do not proceed to building with more work than the appetite covers. A cycle that begins over-scoped ends without a finished thing.

## Output: The Scopes Document

Write `docs/concepts/[name].scopes.md` with the following structure:

```markdown
---
concept: docs/concepts/[name].md
status: building
---

# Scopes: [Concept Name]

## What We're Building
[Two or three sentences drawn from the concept document. Problem being solved and the shaped approach. Enough context to orient anyone reading the scopes document on its own, without repeating the full concept.]

## Existing System Context
[Key findings from the codebase investigation: reusable components, established patterns, areas where this work extends existing behavior, and areas where it introduces something new. This section is the handoff from kickoff investigation to scope breakdown. It prevents each scope from being planned without knowledge of what the rest of the system looks like.]

## Scopes

### [Scope Name]
[What this scope delivers. What can be demoed when it is done.]

**Uncertainty:** low / medium / high
**Depends on:** none | [other scope name]

### [Scope Name]
...

## Sequence
[Which scope to tackle first and why. Order of the rest with brief rationale for any non-obvious sequencing decisions.]

## Appetite Check
[Total scopes vs. appetite. If anything was cut to fit, note it here.]
```

After writing the scopes document, update the Build section of `docs/concepts/[name].md` with a link to the scopes document and set `status: building` in the concept document frontmatter.
