---
name: shape
description: Use when a concept document has reached Frame Go and the problem is clear enough to start defining a solution with the user. Also when a solution is being drafted without the user's decisions, when only one option is on the table, or when a shape is about to be declared done without asking whether it solves the framed problem.
---

# Shaping

Shaping is getting to the "we've got it" moment — a shared understanding of what to build that is rough enough to leave implementation judgment to builders, solved enough that nothing critical is hand-waved, and bounded by the appetite set during framing.

The "we" is literal. Shaping is collaborative creative work: two people at a whiteboard moving fast, speaking frankly, jumping between promising positions. In this session, the user is your shaping partner — they hold the domain truth and the business judgment; you hold the codebase and the rigor. A shape produced without their decisions in it is not a shape; it is your guess wearing a shape's clothes.

The document that comes out is packaging: a way to bring people who weren't in the session to the same understanding. The real work is the live back-and-forth that reaches the a-ha moment. Shaping cannot be done alone — not by the user alone, and not by you alone.

**Before starting:** Read `docs/concepts/[name]/frame.md`. The status must be `frame-go`. If the problem section is still vague, return to framing — shaping without a clear frame produces the wrong solution.

## The Iron Laws

```
1. APPETITE DOES NOT MOVE. SCOPE ADJUSTS TO FIT IT.
2. SHAPING IS A DIALOGUE. THE USER MAKES THE CALLS.
```

**Appetite does not move.** If the solution doesn't fit the appetite, scope must be cut or the problem reframed — the appetite does not flex.

**The user makes the calls.** You draft, explore the codebase, generate options, hunt risks — but you decide nothing that shapes the outcome. Producing requirements, shapes, a fit check, a winner, and shape.md in one turn is a monologue, and a monologue violates this law no matter how good its content is. "The user was busy" does not suspend the law; it pauses the session.

Violating the letter of either law violates the spirit of it.

## Division of Labor

- **The user owns:** domain truth, business priority, and every trade-off call — what to cut, what to suck at, what is out of bounds, which shape advances, when it is shaped enough.
- **You own:** codebase truth (you are the senior technical person in the room — earn it by actually reading the code, not reasoning from outside), option generation, risk hunting, and framework rigor (notation, gates, abstraction level).

Neither overrides the other in the other's territory. If the user asserts something about the code, check it. If you have an opinion about a trade-off, give it as a recommendation — then let them decide.

## The Session Rhythm

Work in **rounds**. Each round: do your homework (read code, draft tables, sketch options) → bring findings back in digestible form → present **one decision point** → wait → record the user's call → next round. Never batch the whole shape into one message. A long session of small decisions is the method, not an inefficiency.

End every session with the takeaways and the unsolved-questions list; open the next by replaying them. Unsolved questions carried silently between sessions are the ones that resurface in week three.

**Decision points.** At every fork, present options with trade-offs and a recommendation, then stop and wait:

```
DECISION POINT: [the fork]
Stake: [what gets worse if we choose wrong]

Option A: [approach] — Pro: … Con: …
Option B: [approach] — Pro: … Con: …

Recommendation: [A/B] because [reasoning]. Your call.
```

Use the AskUserQuestion tool when available; the text form otherwise. Record the outcome: `Decision: [X] — user`. If a round genuinely has no fork, say so: "Decision points: none this round."

**Delegation rule.** "You decide" delegates only *secondary* choices (notation details, ordering, which spike to run first) — record them as `Decision: [X] — delegated`. **Load-bearing calls cannot be delegated:** which shape advances, any cut or patch that removes capability, the won't-dos, and Shape Go itself. For those, give your recommendation and get an explicit confirmation. If the user is too busy to make load-bearing calls, the session pauses — it does not proceed on your judgment.

**The two standing questions.** At every decision point, ask them out loud and answer them together:

1. **"Does this still solve the framed problem — and does the frame still say everything we now know?"** The frame is the acceptance test, so the check runs both ways: the shape against the frame, and the frame against everything learned since. "Still fits the frame" is worthless if the frame is stale — if a problem-fact surfaced that frame.md doesn't contain, run the frame-delta protocol before wiring on. Watch for language drift: if the shape says "payment status" where the frame says "missed payments," the solution is drifting from the problem.
2. **"What new problems would this shape create, and who inherits them?"** Every solution is the source of the next problem. Displace consciously or not at all — name the residue and its inheritor. These answers accumulate in shape.md under `## New Problems This Creates` and feed the betting decision.

## The Abstraction Discipline

Shaped work lives at the fat-marker sketch level.

**Keep:** named building blocks, macro-level connections, flow topology — the wiring of how things work together.
**Reject:** visual designs, exact copy, database schemas, component libraries, API specs, implementation detail of any kind.

A shaped solution is the blueprint of a house: where the walls go, where the pipes run. Not the tile, not the paint. Those decisions happen during building, by the people doing the work.

This axis has a name: **latitude** — how much is spelled out vs. left open for the builders. Both extremes fail: undershaped work (wish-list parts, "the team will figure it out") stalls inside the time box; overshaped work (the "beautiful monster" spec) blows the box and gets stuck with the first idea. When you suspect drift toward either extreme, check the symptom tables in `references/calibration.md`.

```
WHEN describing any shape part or flow step:
  IF you are specifying visual design, exact copy, component names, database schemas, or API specs
    → STOP, elevate the abstraction
  Ask: can the builder make this decision without needing to understand the problem?
  IF yes → leave it out of the shape
```

## One Understanding, Two Layers

The frame and the shape are not phases with a border — they are two layers of one understanding that deepen together. The frame precedes the shape *logically* (every shape decision must be justified by the current frame), not *temporally*: shaping is the sharpest probe the frame ever gets, and its concrete questions routinely surface problem-facts that no amount of framing would have found. Frame material arriving mid-shaping is the process working at its best. Harvest it — never ignore it, never treat it as an interruption.

**The invariant:** at every decision point, the shape is justified by the current frame, *and* the frame contains everything learned so far. Two documents, one truth. Adjusting the shape to a new fact while frame.md still tells the old story hands the betting table a stale acceptance test.

### The routing rule

Users do not speak in phases. Any remark — an aside, an SME anecdote, a complaint — may carry problem-material (who is affected, cost, workaround, why it persists, outcome), solution-material (mechanism, wiring, scope), both, or neither. Sort what each message carries and say so in one sentence: "That's frame material — it changes the problem from surfacing to solving; here's what it does to the shape." Routing is not a mode switch. It costs one sentence.

### The frame-delta protocol

```
WHEN problem-material surfaces mid-shaping:
  1. Name it as a frame delta, out loud.
  2. Quality-check it inline — the frame skill's verdict loop travels with the
     material ("two owners churned last quarter" — where does that live?).
     The frame skill is a quality bar, not a location.
  3. Reframe decision point: proposed frame change + what it does to the
     requirements and the shape. Reframes are load-bearing — never
     agent-authored, never delegated.
  4. Write the delta into frame.md (problem statement, affected topics,
     Evidence). Status stays frame-go when the user re-confirms in-session.
  5. Propagate: re-derive affected Rs, re-run the fit check, re-check the
     breadboard — 🟡-marked. Say out loud what dies and what is born.
     If the delta collides with the appetite, negotiate it openly:
     "I'm not sure we have time for both — if we could do only one thing,
     which?" Test provenance before cutting: "Did you tell me about X
     because it matters, or because I asked for more?"
  6. Continue. Same room, same breath.
```

**Escalation ladder — magnitude decides ceremony, not category:**
- **Small** (new fact fits the existing problem statement): inline delta, one confirmation.
- **Medium** (the problem statement itself changes — "surfacing" becomes "solving"): still inline, but explicit reframe decision point, frame.md revision, full propagation.
- **Large** (wrong problem; the cost evaporates; wrong segment): suspend shaping. frame.md drops to `status: candidate`; run the frame skill properly. This is the only case that leaves the room.

"Park it for a future pitch" is a valid *outcome* of the reframe decision point — never a substitute for running it. A parked frame-fact is still written into frame.md (Evidence, or as context under New Problems), so the betting table sees it.

When domain questions keep surfacing that neither of you can answer, name the person who can and pause for research rather than guessing — the same exit framing uses. Better: bring that person into the session so answers land on the spot.

## Phase 1: Read the Frame Together

**Goal:** Shared grounding before any solution thinking.

Read frame.md, then play your reading back to the user in two or three sentences: the problem, the appetite, the domain words that must carry through. Ask them to confirm or correct it. The frame's language is binding — shape parts and breadboard use the frame's words.

**Gate:** User has confirmed your reading. Appetite fixed. Language noted. No shaping operations begun.

## Phase 2: Requirements

**Goal:** Agree on what the solution must do before discussing how.

Draft R0, R1, R2… from the frame (notation: `references/notation.md`). Propose a status for each — Core goal / Must-have / Undecided / Nice-to-have / Out — but **the statuses are the user's call**: they are miniature scope decisions. Walk through them as one decision point (or a few, if contested). Requirements state what's needed, not how.

Test each requirement's provenance: "Did this come from the problem, or from me asking for more?" Requirements elicited by over-asking are cut candidates — the SME who mentioned class utilization "only because you said you needed more" was describing filler, not need. The sharpest probe: "If we could do only one thing, which?"

**Gate:** User has confirmed every requirement status. Core goal is singular and matches the frame.

## Phase 3: Explore Shapes

**Goal:** Genuinely different options on the table; the user rejects and picks.

Do your homework first: read the relevant code, understand what exists (CURRENT is the baseline shape). Then draft **at least two genuinely different shapes** — different trade-offs, not variations of one idea. One of them must be the **cheapest shape that passes the core goal**: the hot dog, not the ten-course dinner. "Good" is relative to appetite; making the user argue past the cheap shape is how they discover what is actually sufficient.

Present the shapes with the fit check (requirements × shapes, binary ✅/❌ — see `references/notation.md`), flag unknowns with ⚠️, and give your recommendation. Then the decision point: **the user rejects and picks.** People need to reject something to choose something — a single shape offers nothing to reject, which is why one shape is never enough.

**Gate:** ≥2 shapes plus CURRENT were on the table; the user picked the advancing shape; the pick is recorded.

## Phase 4: Spike the Unknowns

**Goal:** No ⚠️ survives into the chosen shape.

Spikes are your homework: investigate each flagged unknown in the actual code and return with mechanics, not opinions (structure in `references/notation.md`). Report findings back; if a finding changes the shape's cost or viability, that is a decision point — the user may re-pick.

**Gate:** All flags on the chosen shape resolved; fit check re-run; user informed of anything that moved.

## Phase 5: Breadboard

**Goal:** Wire the chosen shape end to end.

Invoke `shape-up:breadboarding`. Wiring choices that embed a trade-off (which place a flow starts from, what a user must do manually vs. what the system does) come back as decision points — they are design decisions, not notation.

**Gate:** Play-through complete with no gaps. Breadboard written into shape.md.

## Phase 6: Find the Rabbit Holes

**Goal:** Surface what could blow up the cycle, and patch every one — together.

Hunt: walk a use case in slow motion; ask what touches code we don't fully understand, which edge cases could force a bigger build, where this brushes existing complexity. For each rabbit hole, propose a patch — a specific constraint that prevents derailment. **Every patch that cuts capability or dictates a compromise is a load-bearing decision point** — the To-Do-Groups "completed items stay as they are" patch was a strategic product call, and so are yours.

**Gate:** Every rabbit hole has a user-confirmed patch. No open rabbit holes.

```
IF a rabbit hole has no acceptable patch:
  → redesign the shape, or return to framing to take it out of scope
  → do not proceed with an open rabbit hole
```

## Phase 7: Dos and Won't-Dos

**Goal:** Every reasonable scope assumption made explicit — by the user.

Propose the won't-dos (what could someone reasonably assume is included that we are not building?) with a rationale each. The user confirms every one — won't-dos are promises about what the business will not get, and only the user can make them. Restate decisions from framing; they do not carry over automatically.

**Gate:** Won't-Dos list produced and user-confirmed. Nothing left to inference.

## Phase 8: Three Properties and Shape Go

**Goal:** Verify readiness — then the user, not you, declares Shape Go.

State the evidence for each property (intentions don't count):
- **Rough:** parts are named mechanisms; no schema, no component names, no exact copy.
- **Solved:** all parts connected in the breadboard; no open ⚠️; open questions resolved and named.
- **Bounded:** fits the appetite; won't-dos explicit; every rabbit hole patched.

Then ask the two standing questions one final time, out loud. Then hand over the pen:

> "Here is the shape and the evidence. Do you call this Shape Go?"

**Shape Go means:** "We can give this to someone to build and they will know what to do. No material unknowns from a technical or interaction standpoint." It is the user's sentence. If they hesitate, the hesitation points at the weak phase — go back to it.

```
IF any property lacks evidence → keep shaping. Do not ask for Shape Go on hope.
IF the check passes in under a minute → you have not done it.
```

## Output

When the user declares Shape Go, write `docs/concepts/[name]/shape.md`:

```
---
shaping: true
status: shape-go
---
```

The document captures the a-ha moment in packaging form: requirements, shapes considered (including the rejected ones and why), fit check, spikes, breadboard, rabbit holes with patches, dos and won't-dos, and:

- **`## New Problems This Creates`** — the accumulated answers to standing question 2: each new problem, who inherits it, and why the trade is acceptable. The betting table reads this section.
- **`## Decisions`** — the log of decision points and who made each call (`user` / `delegated`). This is the shape's provenance: proof it was shaped, not generated.

`shape.md` is ground truth for R, shapes, fit checks, spikes, and breadboard. Changes here ripple to `slices.md` and any `S#-plan.md` files below it.

Table notation, re-render rules, and spike structure: `references/notation.md`.

## Red Flags

| If you're thinking... | Do this |
|---|---|
| "I'll draft the whole shape to save the user time" | STOP — that is a monologue. Work in rounds. |
| "Only one shape came to mind" | Nothing to reject means no real choice. Draft the cheap shape and a different-trade-off shape. |
| "It's obvious which shape wins" | Then confirming costs one message. Ask anyway. |
| "The user said 'you decide'" | Secondary choices only. Load-bearing calls need their explicit confirmation. |
| "The checks pass — I'll set shape-go" | Shape Go is the user's sentence. Ask for it. |
| "I'm continuing but there's an unresolved framing question" | STOP — return to framing, resume after frame-go |
| "The rabbit hole might not matter in practice" | Every rabbit hole needs a user-confirmed patch |
| "I'll add design details to make it clearer" | You've left fat-marker level |
| "I'm using different words than the frame" | Language drift — return to frame language |
| "I'll mark this TBD and resolve it in building" | Unresolved questions in shaping become blockers in building |
| "I haven't opened the codebase yet" | You are the technical person in the room. Read the code before proposing shapes. |
| "The team will figure that part out" | Undershaped — that unknown stalls the time box. Breadboard or spike it now (`references/calibration.md`). |
| "A styled mock would sell this better" | The beautiful monster. Hardline drawings become sacred. Stay at fat-marker. |
| "Nobody asked what this shape breaks" | Standing question 2 is due at every decision point |
| "About to write shape.md without `## New Problems This Creates`" | The betting table reads that section. Answer standing question 2 before writing. |
| "That's a different feature — back to the breadboard" | Route it first. Parking is a decision-point *outcome*, never a reflex. The fact still lands in frame.md. |
| "The shape still fits the frame" — checked against a frame you know is stale | The invariant has two halves. Update the frame, then re-check. |
| A new fact changed the shape but frame.md is untouched | Silent divergence — the betting table will read a stale acceptance test. Run the delta protocol. |

## Rationalization Table

| Excuse | Reality |
|---|---|
| "The appetite can flex a little" | Appetite is fixed. Scope adjusts. Not the other way. |
| "Producing it all at once is more efficient" | Efficiency at producing the wrong shape is negative efficiency. The decisions are the shaping. |
| "The user trusts me, so I can pick the shape" | Trust means they'll take your recommendation seriously — after you ask. |
| "Presenting options will overwhelm them" | Two shapes with clear trade-offs is less overwhelming than one fait accompli. |
| "This detail is necessary for clarity" | If the builder can make the decision, leave it out |
| "The rabbit hole probably won't come up" | Rabbit holes always come up. Patch them now or pay in week three. |
| "We can figure out the framing question as we go" | Shaping over an unresolved framing question produces the wrong solution |
| "The document IS the shaping" | The document is packaging. The shaping is the decisions in the session. |
| "We're late — I'll compress the final gate away" | Compress the prose, not the gate. The two standing questions and the evidence statement still happen — in one message if needed. |
| "It was just an aside, not a requirement" | Asides are where frame deltas hide. Route every remark. |
| "Updating frame.md mid-shaping is ceremony" | It's six lines. A stale acceptance test costs a betting cycle. |
| "We're too close to done to reframe" | The payment-recovery nugget arrived late too. Late frame-facts are usually the valuable ones. |

## Quick Reference

| Phase | Key Activity | Gate |
|---|---|---|
| 1. Read frame together | Play back problem, appetite, language | User confirms the reading |
| 2. Requirements | Draft R; propose statuses | User confirms every status |
| 3. Explore shapes | ≥2 shapes + CURRENT, incl. cheapest-that-passes; fit check | User rejects and picks |
| 4. Spike unknowns | Investigate ⚠️ in the code | Flags resolved; user re-confirms if shape moved |
| 5. Breadboard | Wire the chosen shape | No gaps; wiring trade-offs decided by user |
| 6. Rabbit holes | Hunt risks, propose patches | Every patch user-confirmed |
| 7. Dos / Won't-dos | Propose exclusions with rationale | User confirms every won't-do |
| 8. Three properties | Evidence per property + standing questions | **User** declares Shape Go |

Every round: homework → findings → one decision point → wait → record. Standing questions at every decision point: *does it still solve the framed problem — and does the frame say everything we now know?* and *what new problems does it create?* Route every remark: problem-material → frame-delta protocol; solution-material → current phase.
