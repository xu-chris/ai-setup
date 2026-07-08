# Capturing the current version — the draw-and-correct method

Background and worked example for Step 0 of SKILL.md. The steps in SKILL.md are binding; this explains why they work and shows the loop in motion.

## Why draw-then-correct, not ask-then-guess

This is Domain-Driven Design's *knowledge crunching* (Evans, ch. 1). Evans set out to build PCB-design software knowing nothing about circuits. He did not interview the experts for a spec — he **drew diagrams and let them correct him**:

> "I started drawing diagrams for them as we discussed the things they wanted the software to do… They constantly corrected me, and as they did I started to learn. They began to explain things more precisely… and we started to develop a model together."

The corrections are the point: "the net box looks just like a component instance," "we call them component instances," "it isn't enough to say a signal arrives at a ref-des, we have to know the pin." Each is domain knowledge the code (or the ASCII spec they first offered) could not surface. Evans names the failure mode you are avoiding: **the waterfall hand-off "fails because it completely lacks feedback… knowledge trickles in one direction but does not accumulate,"** and **"this ignorance leads us to make false assumptions."** An agent that asks the user code-answerable questions, or asserts a flow it half-read, is running that broken one-directional loop. Draw from the code, present the draft, let the expert correct — that is the loop that accumulates truth.

Distillation is part of it (Evans, ingredient 4): drop what is not central. "Then I'm going to drop it out for now… we can bring it back when we get to those features." The current breadboard is the user flow and lightly what affordances do — not every field and function. Leave out what the domain expert would not care about.

## Guards are hidden business rules — surface them

Evans' overbooking example is exactly the guard-capture in Step 0.c. The requirement "Allow 10% overbooking" arrived as one line and was implemented as a guard clause buried in a method:

```
if ((voyage.bookedCargoSize() + cargo.size()) > voyage.capacity() * 1.1)
    return -1;
```

> "Now an important business rule is hidden as a guard clause in an application method."

His whole lesson: make it explicit so **"any business expert could read it to verify the rule."** That is what you do with each guard on the current flow — a required status, a permission, a present/absent precondition. You read the guard from the code (you can see the `if` exists); you surface it in plain language so the expert can confirm it is *right and complete* — because "domain experts are usually not aware of how complex their mental processes are… they navigate all these rules, reconcile contradictions, and fill in gaps with common sense. Software can't do this." The guard in the code may be partial or wrong; only the expert closes that gap.

## Guard vocabulary (what to look for in code, confirm with the expert)

- **Status gate** — the flow or step only exists when a record is in a state: `status == :inbox`, `published?`, `paid`, `approved`. (Screentour: a submission surfaces on deadline surfaces only at `:inbox` with a dated regulation.)
- **Right / permission** — the actor must hold a role or policy: an Ash policy, an `on_mount` check, a `can?`. Absent → the place is not reachable for that user.
- **Presence / absence** — a linked record exists (or must not): a non-null FK, a feature flag on, a space *not* frozen (`SpaceNotFrozen`), a prior step completed.
- **Time / window** — a deadline in range, a cron cadence, a lookahead window (the 14-day digest).

Each guard is an edge condition on the breadboard: the arrow exists only when the guard holds. Where a guard fails silently (the flow just doesn't happen, with no signal) that is very often exactly where the framed problem lives — mark the ⚠️ there.

## Worked loop (abridged, Screentour deadline flow)

**Agent (draft from code):** "Here's the current flow. A filmmaker adds a festival on *Browse* → it creates a tracked record → it shows on the *Tour Plan* card with a countdown, and in the *Home* Upcoming panel. Guard I read in the code: the Upcoming panel and the weekly email only include a festival when its tracked record is `:inbox` **and** has a dated regulation attached. Does that match how it's meant to work?"

**Expert (corrects):** "Mostly — but saving from the search page doesn't always attach a regulation. People save a festival they're *considering*, before they've picked a category."

**Agent (redraw + guard correction):** "Then there's a silent gap: a save with no attached regulation passes the guard's second half and never appears on any deadline surface — no countdown feeds it, no email includes it. That's where I'll put the ⚠️: on the *save* affordance, condition 'regulation absent'. And a second ⚠️ at the nightly sweep — the one job that detects a passed deadline only flips a status, it wires out to nothing the filmmaker sees. Correct?"

**Expert:** "Yes — and the sweep one is worse than I thought."

Two passes, and the current breadboard now carries the two problem locations the frame is about — discovered by drawing from code and letting the expert correct, not by asking the expert what the code already says.

## Multi-repo / microservices

The flow crosses services. Enumerate every service it passes through *before* drawing, and confirm you hold each repo. When an affordance calls another service, the truth of what happens next lives in that service's repo — open it and read it. If you don't have it, that is a pause-for-research: ask for the git URL and clone it. Guessing the callee's behavior is the single most common way the current version comes out wrong, because the seam between services is exactly where no one repo tells the whole story.
