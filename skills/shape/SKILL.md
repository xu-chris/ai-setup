---
description: Use when a concept document has reached Frame Go and the problem is clear enough to start defining a solution. Guides the user through elements, breadboarding, rabbit holes, and scope boundaries. Adds to the Solution section of the concept document.
---

# Shaping

Shaping is the work of defining what to build. It starts from a clear problem (the Frame) and produces a solution concept that is rough enough to leave room for implementation judgment, solved enough that nothing critical is hand-waved, and bounded by the appetite set during framing.

Shaping is not writing. The document that comes out is packaging — a way to bring others to the same understanding reached during the shaping session. The real work is the thinking, the sketching, and the back-and-forth that gets to the "we've got it" moment.

Before starting: read the concept document at `docs/concepts/[name].md`. The status must be `frame-go`. If the problem section is still vague, return to framing. Shaping without a clear frame produces the wrong solution.

## The Abstraction Discipline

Shaped work lives at the fat marker sketch level. This is the hardest discipline to hold.

**Keep:** Named building blocks, macro-level connections, flow topology, the wiring of how things work together.

**Reject:** Visual designs, exact copy, database schemas, component libraries, API specs, implementation detail of any kind.

A shaped solution is like the blueprint of a house — where the walls go, where the sink goes, where the pipes run. Not the tile, not the paint color, not the fixture styles. Those decisions happen later, during building, by the people doing the work.

If the shaping is getting too detailed, stop and ask: is this a decision that must be made now, or can the builder make it? If the builder can make it, leave it out.

## How to Shape

### Step 1: Read the Frame

Absorb the problem, the affected segment, the current workaround, what goes wrong, and the appetite. Shaping happens inside those constraints. The appetite is fixed — scope adjusts to fit.

Pay attention to the language in the frame. The words used there — the domain's own terms for the problem — are the words that must carry through shaping. If the frame says "missed payments," the elements and breadboard should say "missed payments," not "payment status" or "invoice errors." Language drift between frame and shape is a signal that the solution is drifting from the problem.

Shaping regularly surfaces questions that require going back to the frame. This is not a failure — it is knowledge crunching. The shared understanding of the problem deepens through the back-and-forth between problem and solution. The first model is always wrong. Expect to refine the frame as shaping proceeds, and treat each refinement as progress rather than rework.

### Step 2: Name the Elements

Elements are the high-level building blocks of the solution. They are not screens, not components, not database tables. They are named concepts that describe what the solution is made of.

Aim for 3 to 7 elements. More than that usually means the solution is too big for the appetite or not yet abstracted enough.

For each element, answer: what is it, and what does it do for the user? One or two sentences maximum. If it takes more, the element is probably too detailed or needs to be split.

Name elements in the domain's language, not in technical or generic terms. An element name that the person who knows the problem would not recognize is a warning sign — either the element is too technical, or the solution has drifted from the problem. The right name usually comes from the frame itself. If "missed payments" is the problem, "Missed Payments Panel" is a better element name than "Dashboard Widget" or "Invoice Status Component."

Getting the names right is part of the shaping work. A well-named element makes the solution legible to anyone who understands the problem, not only to the people who will build it.

### Step 3: Breadboard the Flow

Breadboarding maps how users move through the solution using three components:

**Places** — screens, dialogs, states, or any location where the user finds themselves.

**Affordances** — buttons, fields, links, messages, or any thing the user can interact with or read at that place.

**Connections** — arrows that show where an affordance takes the user.

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

Breadboard the critical path first — the flow the user takes when everything works. Then breadboard any significant branches or edge cases that the appetite allows for.

The breadboard is not a wireframe. No layout, no visual design, no exact copy. Just the topology — what exists where, and how it connects.

### Step 4: Find the Rabbit Holes

Rabbit holes are things that seem small but could unexpectedly expand scope. They are the time bombs that blow up build cycles when left unresolved.

For each rabbit hole, a patch is required — a specific constraint that prevents it from derailing the work. Identifying a rabbit hole without patching it is not enough.

Ask:
- What parts of this solution touch things we do not fully understand?
- What edge cases could force a much bigger implementation than expected?
- Where does this solution brush up against existing complexity?

Each rabbit hole entry: what the risk is, and what the patch is.

### Step 5: Define Dos and Won't-Dos

Won't-dos are intentional exclusions. They are not nice-to-haves left for later by default — they are deliberate decisions that protect the appetite. Each won't-do needs a rationale.

Dos confirm what is explicitly in scope. They close off ambiguity about what the shaped solution covers.

Go through the elements and breadboard and ask: what could someone reasonably assume is included that we are not building? Make those assumptions explicit as won't-dos.

## Three Properties Check

Before writing to the document, validate the solution against three properties:

**Rough** — Is every element described at high abstraction? Does the breadboard show topology without visual design? Is there room for the builder to make implementation decisions? If too detailed, elevate the abstraction.

**Solved** — Are all elements identified and connected? Is the user flow clear end to end? Is anything critical hand-waved or marked TBD? If something is unclear, work it out now. Unresolved questions in shaping become problems in building.

**Bounded** — Does the solution fit the appetite? Are the won't-dos explicit? Does every rabbit hole have a patch? If the solution exceeds the appetite, cut scope at the concept level until it fits.

If any property fails, keep shaping. Do not write a shape-go that is not actually shaped.

## Output

When the three properties pass, add to the Solution section of `docs/concepts/[name].md` and set `status: shape-go`.

The Elements section lists each element with a one or two sentence description.

The Breadboard section contains the full breadboard notation for all relevant flows.

The Rabbit Holes section lists each risk and its patch.

The Dos section lists what is explicitly in scope.

The Won't-Dos section lists what is explicitly out, each with a brief rationale.
