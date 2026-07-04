---
name: bet
description: Use when a concept has reached Shape Go and needs a deliberate decision before building begins.
---

# Betting

Betting is the decision to commit build time to a shaped concept. It is a weighted choice: given everything else that could be done, is this the right thing to build now?

A bet has three properties. It has a payout - something meaningful is finished at the end of the cycle. It is a commitment - time is protected and the work gets uninterrupted attention. It has a capped downside - the maximum loss is one cycle, never an open-ended extension.

In most companies, betting is one-to-one: one candidate is framed, shaped, and green-lit. Alignment is built progressively through framing and shaping - by the time the concept reaches Shape Go, the team already knows this is the thing. The betting step is the final stamp of approval, not a competition between pitches.

**Before starting:** Read `docs/concepts/[name]/frame.md` and `docs/concepts/[name]/shape.md`. The status in `frame.md` must be `shape-go`. If shaping is incomplete, return to shaping. A fuzzy shape produces a bad bet.

## The Iron Law

```
A FUZZY SHAPE PRODUCES A BAD BET. THE BIAS IS TOWARD NO.
```

Violating the letter of this rule is violating the spirit of it. The five questions exist to find reasons to say no, not to find permission to say yes. If any question cannot be answered with specific evidence - not reassurance - the concept is not ready to bet on.

The bias toward no is not just a quality gate - it is the mechanism by which teams achieve conviction. Eliminating many options aligns the team on one thing. "No, no, no... YES!" produces more confidence than a weak yes ever can.

## Phase 1: Verify Shape Quality

**Goal:** Confirm the concept is actually shaped before evaluating it.

Check three things:
- All rabbit holes have patches - no open ends
- Technical grounding is visible - there is evidence in the concept that the relevant code was actually examined, not just reasoned about from the outside
- The three properties (rough, solved, bounded) have been validated

**Gate:** All three hold. If any fail, return to shaping before proceeding.

```
IF any rabbit hole has no patch → return to shaping. Do not bet on a concept with open rabbit holes.
IF no evidence of technical grounding in the concept → return to shaping.
  A guess dressed as a plan surfaces its problems in week three of a six-week cycle.
```

## Phase 2: Work the Five Questions

**Goal:** Find every reason to say no before committing build time.

Work through these looking for problems, not for reassurance. If a reason to say no surfaces, either resolve it consciously or accept it as known before committing.

In most cases these questions are answered quickly - alignment was built progressively through framing and shaping, and the betting step is confirmation, not discovery. If the questions are hard to answer, that is a signal the alignment was not built.

**1. What goes wrong if this does not get built?**
Separate the problem from the solution. What breaks, stalls, or deteriorates if this cycle ends and nothing was built? If the answer is "not much," the problem is not urgent enough to bet on.

**2. Is the appetite right?**
Appetite was set during framing. Does it still feel accurate given what shaping revealed? If shaping surfaced more complexity than expected, the appetite may need revisiting. If the solution feels overbuilt for the problem, the appetite may be too large.

**3. Is the solution sound?**
Does the shaped solution actually address the problem? Are the won't-dos acceptable given the problem's real cost? Are the rabbit hole patches convincing? Can you point to specific decisions in the concept that reflect knowledge of how the existing system works?

**4. Is this the right time, with the right people?**
Consider what has just shipped, what technical state the codebase is in, and what momentum exists. Consider who is available - will the people needed to execute this concept have the time and focus the cycle requires?

**5. Is this the one thing?**
A bet is a commitment to one thing for the duration of the cycle. If two shaped concepts are competing, the choice is "which one" - not "both in parallel" or "both sequentially this cycle."

**Gate:** All five questions answered with specific evidence, not general reassurance.

## Phase 3: Make the Binary Decision

**Goal:** Commit or decline - no middle ground.

The decision is binary.

**Bet** - the concept moves to building. Set `status: bet`. Fill in the Bet section with the decision rationale, conditions that must hold, and the cycle assigned.

**No bet** - the concept does not move forward this cycle. It does not go into a backlog. If it still matters, it returns to framing or shaping when the time is right. Set `status: candidate` and note briefly why this cycle is not the right time. A no-bet is discipline, not failure.

```
IF the decision is "maybe, let's see" → it is a no bet
IF the decision is "both in parallel" → that is not a bet; make the choice
IF the decision is "both sequentially this cycle" → that is not a bet; one thing per cycle
```

**Gate:** Decision is bet or no bet, written to the concept document.

## Output

When the decision is bet, append a Bet section to `docs/concepts/[name]/frame.md`. Do not create a separate file. The bet record lives in `frame.md` alongside the frame that produced it.

```markdown
## Bet

**Decision:** [One or two sentences stating the bet and the primary reason it was chosen.]

**Conditions:** [Anything that must remain true for the bet to hold.]

**Cycle:** [The cycle this is assigned to - date range, cycle number, or label.]
```

Update `status: bet` in `frame.md` frontmatter.

If no bet, update `status: candidate` in `frame.md` frontmatter and add a brief note explaining why this cycle is not the right time. This is not a permanent judgment.

## Red Flags

| If you're thinking... | Do this |
|---|---|
| "We'll figure out the rabbit hole during building" | STOP - open rabbit holes are a no bet |
| "The shape is probably good enough" | STOP - verify phase 1 before evaluating |
| "Both in parallel is more efficient" | That is not a bet. Make the choice. |
| "We've been waiting on this one for a while" | Age of a concept is not a reason to bet on it |
| "A no bet feels like failure" | No bets are discipline. They protect the cycle. |
| "The technical concerns are minor" | If technical grounding is not visible in the concept, it is a gap |
| "I'll write the bet to a separate bet.md file" | STOP - append to frame.md. The bet does not get its own file. |

## Rationalization Table

| Excuse | Reality |
|---|---|
| "The shape is close enough" | Fuzzy shapes produce bad bets. Return to shaping. |
| "We can fix it if something comes up in building" | Week-three discoveries leave no room to recover |
| "The bias toward no is too conservative" | Most bets fail from insufficient shaping, not insufficient optimism |
| "Partial commitment this cycle, rest next" | A cycle with split attention ends without a finished thing |
| "We said we'd ship this quarter" | Dates don't fix fuzzy shapes. Bet when the shape is ready. |

## Quick Reference

| Phase | Key Activity | Gate |
|---|---|---|
| 1. Verify Shape | Rabbit holes patched, technical grounding visible, three properties validated | All three hold before evaluating |
| 2. Five Questions | Look for reasons to say no | All five answered with evidence |
| 3. Binary Decision | Bet or no bet | Written to concept document |
