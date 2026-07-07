---
name: shape
description: Use when a concept document has reached Frame Go and the problem is clear enough to start defining a solution with the user. Also when a solution is being drafted without the user's decisions, when only one option is on the table, or when a shape is about to be declared done without asking whether it solves the framed problem.
---

# Shaping

Shaping gets user and agent to the "we've got it" moment: a shared understanding of what to build — rough enough to leave implementation judgment to builders, solved enough that nothing critical is hand-waved, bounded by the appetite from framing. The user is your shaping partner, not your audience. The document is packaging; the decisions in the session are the shaping.

**Before starting:** Read `docs/concepts/[name]/frame.md`. Status must be `frame-go`. Problem still vague → return to framing.

## The Iron Laws

```
1. APPETITE DOES NOT MOVE. SCOPE ADJUSTS TO FIT IT.
2. SHAPING IS A DIALOGUE. THE USER MAKES THE CALLS.
```

- Solution doesn't fit the appetite → cut scope or reframe the problem. Never stretch the appetite.
- You draft, explore code, generate options, hunt risks. You decide nothing that shapes the outcome. Requirements + shapes + fit check + winner + shape.md in one turn is a monologue and a violation, however good the content. User too busy to decide → the session pauses; it does not proceed on your judgment.

Violating the letter of either law violates the spirit of it.

## Division of Labor

| | Owns |
|---|---|
| **User** | Domain truth, business priority, every trade-off: what to cut, what to suck at, what's out of bounds, which shape advances, when it's shaped enough |
| **You** | Codebase truth (read the code — never reason about it from outside), option generation, risk hunting, framework rigor (notation, gates, abstraction) |
| **The build team** | The project from kickoff on: scoping, the correct technical solution, every decision the shape's latitude left open |

Neither overrides the other in the other's territory. User asserts something about the code → check it. You have an opinion on a trade-off → give it as a recommendation, then let them decide.

Your codebase reading **simulates** the engineers who will build this — it is required, and it is not sufficient. The engineers and designers who take the shape at kickoff own the project from there; before Shape Go, the shape is walked through with at least one of them (Phase 8).

## The Session Rhythm

```
EVERY round:
  1. Homework: read code, draft tables, sketch options
  2. Bring findings back, digestible
  3. Present ONE decision point
  4. WAIT for the user
  5. Record the call → next round
```

Never batch the whole shape into one message. End every session with takeaways + the unsolved-questions list; open the next by replaying them.

**Decision points.** At every fork (AskUserQuestion when available, else this template):

```
DECISION POINT: [the fork]
Stake: [what gets worse if we choose wrong]

Option A: [approach] — Pro: … Con: …
Option B: [approach] — Pro: … Con: …

Recommendation: [A/B] because [reasoning]. Your call.
```

Record the outcome: `Decision: [X] — user`. No fork this round → say "Decision points: none this round."

**Delegation.** "You decide" covers *secondary* choices only (notation, ordering, which spike first) — record as `Decision: [X] — delegated`. **Never delegable:** which shape advances, any cut or patch that removes capability, the won't-dos, Shape Go. For those: recommend, then get explicit confirmation.

**The two standing questions — ask out loud at every decision point:**

1. **"Does this still solve the framed problem — and does the frame say everything we now know?"** The frame is the acceptance test; check both directions. A problem-fact surfaced that frame.md lacks → run the frame-delta protocol before wiring on. Shape says "payment status" where the frame says "missed payments" → language drift, return to frame language.
2. **"What new problems does this create, and who inherits them?"** Name the residue and its inheritor. Record answers in `## New Problems This Creates` — the betting table reads it.

## The Abstraction Discipline

Shaped work lives at the fat-marker sketch level: the blueprint of the house, not the tile or the paint.

**Keep:** named building blocks, macro-level connections, flow topology.
**Reject:** visual designs, exact copy, database schemas, component libraries, API specs — any decision the builders can make.

```
WHEN describing any shape part or flow step:
  IF it specifies visual design, exact copy, component names, schemas, or API specs
    → STOP, elevate the abstraction
  Ask: can the builder make this decision without understanding the problem?
  IF yes → leave it out of the shape
```

This axis is **latitude**: how much is spelled out vs. left open. Undershaped (wish-list parts) stalls the time box; overshaped (the "beautiful monster" spec) blows it and gets stuck with the first idea. Suspect drift toward either extreme → open `references/calibration.md` and check the symptom tables before continuing.

## Routing and Frame Deltas

The frame and the shape are two layers of one understanding, not two phases. Frame-facts surfacing mid-shaping are the process at its best — harvest them, never ignore them. Reasoning and the failure modes this prevents: `references/layers.md`.

**The invariant:** at every decision point, the shape is justified by the current frame AND the frame contains everything learned so far. A shape adjusted to a new fact while frame.md tells the old story hands the betting table a stale acceptance test.

```
EVERY user message — sort what it carries, say the routing in one sentence:
  problem-material (who is affected, cost, workaround, persistence, outcome)
    → frame-delta protocol
  solution-material (mechanism, wiring, scope)
    → current phase
  both → both
```

### The frame-delta protocol

```
WHEN problem-material surfaces mid-shaping:
  1. Name it as a frame delta, out loud.
  2. Quality-check it inline — the frame skill's verdict loop travels with the
     material ("two owners churned last quarter" — where does that live?).
  3. Reframe decision point: proposed frame change + what it does to the
     requirements and the shape. Never agent-authored, never delegated.
  4. Write the delta into frame.md (problem statement, affected topics,
     Evidence). Status stays frame-go when the user re-confirms in-session.
  5. Propagate: re-derive affected Rs, re-run the fit check, re-check the
     breadboard — 🟡-marked. Say what dies and what is born.
     Delta collides with appetite → negotiate out loud:
       "If we could do only one thing, which?"
       "Did you tell me about X because it matters, or because I asked for more?"
  6. Continue. Same room, same breath.
```

**Escalation ladder — magnitude decides ceremony, not category:**
- **Small** (fact fits the existing problem statement) → inline delta, one confirmation.
- **Medium** (the problem statement itself changes) → inline, but explicit reframe decision point + frame.md revision + full propagation.
- **Large** (wrong problem; cost evaporates; wrong segment) → suspend shaping; frame.md drops to `status: candidate`; run the frame skill properly. The only case that leaves the room.

Rules:
- "Park it for a future pitch" is a valid decision-point *outcome*, never a substitute for running it. Parked facts still land in frame.md.
- Domain question neither of you can answer → name the person who can; pause for research, or bring them into the session.

## Phase 1: Read the Frame Together

**Do:** Read frame.md. Play your reading back in two or three sentences — the problem, the appetite, the domain words that are binding. Ask the user to confirm or correct.

**Do:** Locate the repositories this concept touches — search the workspace and sibling directories. Codebase truth is your half of the division of labor; without the code, every shape part is a ⚠️ and every fit check fails.

```
IF no repository found, or unsure you have all the code the concept touches:
  → ask the user in plain language: "I need the code to shape this properly.
    Where does it live? Paste the git URL(s) and I'll clone them."
  → git clone what they provide; verify you can see the relevant modules
  → do not proceed to Phase 3 without code access
```

Users are often non-technical and won't have set up the workspace — asking for the URL is the fix; shaping from imagination is not.

**Gate:** User confirmed the reading. Appetite fixed. Language noted. Repositories located or cloned. No shaping operations begun.

## Phase 2: Requirements

**Do:** Read `references/notation.md` before drafting any table — do not draft tables without it. Draft R0, R1, R2… from the frame. Propose a status per requirement (Core goal / Must-have / Undecided / Nice-to-have / Out); the statuses are the user's call — walk them as decision points. Probe provenance: "Did this come from the problem, or from me asking for more?" and "If we could do only one thing, which?" Over-asked requirements are cut candidates.

**Gate:** Every status user-confirmed. Core goal singular and matching the frame.

## Phase 3: Explore Shapes

**Do:** Homework first — read the relevant code; CURRENT is the baseline shape. Draft **at least two genuinely different shapes** (different trade-offs, not variations); one must be the **cheapest shape that passes the core goal** — making the user argue past it is how they discover what is sufficient. Present with the fit check (binary ✅/❌ per `references/notation.md`), ⚠️ on unknowns, and your recommendation. Decision point: **the user rejects and picks** — one shape offers nothing to reject, so one shape is never enough.

**Gate:** ≥2 shapes + CURRENT on the table; user picked; pick recorded.

## Phase 4: Spike the Unknowns

**Do:** Investigate every ⚠️ in the actual code; return mechanics, not opinions (spike structure: `references/notation.md`). A finding that changes the shape's cost or viability → decision point; the user may re-pick.

**Gate:** All flags resolved; fit check re-run; user told what moved.

## Phase 5: Breadboard

**Do:** Invoke `shape-up:breadboarding` — entered from here it starts at Step 4 (affordance enumeration); your R, chosen shape, and fit check carry over, do not let it rebuild them. Wiring choices that embed a trade-off (where a flow starts, what stays manual vs. automated) → decision points.

**Gate:** Play-through gap-free. Breadboard written into shape.md.

## Phase 6: Find the Rabbit Holes

**Do:** Walk a use case in slow motion. Ask: what touches code we don't fully understand; which edge cases could force a bigger build; where does this brush existing complexity. Propose a patch per hole — a specific constraint that prevents derailment. Every patch that cuts capability → load-bearing decision point.

**Gate:** Every rabbit hole has a user-confirmed patch.

```
IF a rabbit hole has no acceptable patch:
  → redesign the shape, or return to framing to take it out of scope
  → do not proceed with an open rabbit hole
```

## Phase 7: Dos and Won't-Dos

**Do:** Propose won't-dos with a rationale each — "what could someone reasonably assume is included that we are not building?" Restate decisions from framing; they do not carry over automatically. The user confirms every one: won't-dos are promises about what the business will not get.

**Gate:** Won't-Dos list produced and user-confirmed. Nothing left to inference.

## Phase 8: Three Properties and Shape Go

**Do — the engineer walkthrough first.** Walk the shape with a real engineer (and designer, if the shape is interaction-heavy) who knows this codebase and will likely build it. Keep the clay wet: rebuild the breadboard with them from the beginning, don't hand over a finished document. Ask "is this possible **within the appetite**?" — never just "is this possible?" (everything is possible; nothing is free). Hunt time bombs; invite drastic simplifications. Their revisions come back through decision points.

```
IF no engineer is available to walk the shape:
  → decision point: the user explicitly accepts the risk
  → record in shape.md: "Assumption (unverified): shape not validated by an
    engineer who knows the code" — under New Problems This Creates
  → the betting table weighs it
```

**Do:** State evidence per property — intentions don't count:
- **Rough:** parts are named mechanisms; no schema, no component names, no exact copy.
- **Solved:** all parts connected in the breadboard; no open ⚠️; open questions resolved and named.
- **Bounded:** fits the appetite; won't-dos explicit; every rabbit hole patched.

Ask the two standing questions one final time, out loud. Then hand over the pen:

> "Here is the shape and the evidence. Do you call this Shape Go?"

**Shape Go means:** "We can give this to someone to build and they will know what to do. No material unknowns from a technical or interaction standpoint." It is the user's sentence. Hesitation points at the weak phase — go back to it.

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

Contents: requirements, shapes considered (including rejected ones and why), fit check, spikes, breadboard, rabbit holes with patches, dos and won't-dos, plus:

- **`## New Problems This Creates`** — standing question 2's accumulated answers: each new problem, its inheritor, why the trade is acceptable. The betting table reads this section.
- **`## Decisions`** — the decision-point log with who made each call (`user` / `delegated`). Provenance: proof it was shaped, not generated.

`shape.md` is ground truth for R, shapes, fit checks, spikes, and breadboard. Changes ripple to `slices.md` and any `S#-plan.md` files below it.

Its audience is the kickoff team: the engineers and designers who own the project from there — they map the scopes and make every decision the shape's latitude left open. Write it so they can own it, not so it impresses the betting table.

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
| "No repo in the workspace — I'll shape from the frame alone" | Reasoning from outside the code is the #1 failure mode. Ask for the git URLs and clone them. |
| "My code reading makes the engineer walkthrough redundant" | You simulate the engineer; the one who will build it sees traps you can't. Walk the shape with them — or record the risk. |
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
| "The user isn't technical, I shouldn't bother them about git" | One URL question beats six weeks shaped against an imagined codebase. |
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
| 8. Three properties | Engineer walkthrough; evidence per property + standing questions | **User** declares Shape Go |

Every round: homework → findings → one decision point → wait → record. Standing questions at every decision point: *does it still solve the framed problem — and does the frame say everything we now know?* and *what new problems does it create?* Route every remark: problem-material → frame-delta protocol; solution-material → current phase.
