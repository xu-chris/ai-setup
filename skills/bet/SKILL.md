---
description: Use when a concept has reached Shape Go and needs a deliberate decision before building begins. Evaluates the shaped concept against competing priorities and available time. Adds the Bet section to the concept document.
---

# Betting

Betting is the decision to commit time to building a shaped concept. It is not a planning ceremony or a review meeting. It is a weighted choice: given everything else that could be done, is this the right thing to build now?

A bet has three properties. It has a payout — something meaningful is finished at the end of the cycle. It is a commitment — the time is protected and the work gets uninterrupted attention. It has a capped downside — the maximum loss is one cycle, never an open-ended extension.

Before starting: read the concept document at `docs/concepts/[name].md`. The status must be `shape-go`. If shaping is incomplete or the three properties of shaped work have not been validated, return to shaping. A fuzzy shape produces a bad bet.

## The Five Questions

Work through these questions critically. The goal is not to find a reason to say yes. It is to find any reason to say no — and either resolve it or accept it before committing.

**1. Does the problem still matter?**
Separate the problem from the solution. Is the problem described in the Frame section still the most important thing to address? Compare it honestly against whatever else is competing for this cycle. Ask: what goes wrong if this does not get built now?

**2. Is the appetite right?**
The appetite was set during framing. Does it still feel accurate given what shaping revealed? If shaping surfaced more complexity than expected, the appetite may need revisiting. If the solution feels overbuilt for the problem, the appetite may be too large. Appetite is a business signal — how much is this actually worth?

**3. Is the solution sound?**
Does the shaped solution actually address the problem? Are the won't-dos acceptable given the problem's real cost? Are the rabbit hole patches convincing? A shaped solution that only partially solves the problem, or that has unpatched rabbit holes, is not ready to bet on.

**4. Is this the right time?**
Good concepts can still be wrong for this moment. Consider what has just shipped, what technical state the codebase is in, and what momentum exists. A concept that requires working in an area that is in flux is a riskier bet than one that is cleanly isolated.

**5. Is this the one thing?**
A bet is a commitment to one thing for the duration of the cycle. If there are two shaped concepts competing, the choice is not "do both" — it is "which one, and why not the other right now?" Making this explicit prevents half-committed cycles where attention is split.

## Making the Decision

After the five questions, the decision is binary: bet or no bet.

**Bet** — the concept moves to building. Set `status: bet`. Fill in the Bet section of the document with the decision rationale, any conditions that must hold, and the cycle it is assigned to.

**No bet** — the concept does not move forward in this cycle. It does not go into a backlog. If it still matters, it will come back to framing or shaping when the time is right. Set `status: candidate` and note briefly why this cycle is not the right time.

There is no "maybe" or "partial bet." A concept that cannot survive the five questions needs more framing, more shaping, or a different moment.

## Output

When the decision is bet, write to the Bet section of `docs/concepts/[name].md`:

**Decision** — one or two sentences stating the bet and the primary reason it was chosen over alternatives.

**Conditions** — anything that must remain true for the bet to hold. If a dependency shifts or a constraint changes, these conditions surface whether the bet needs revisiting.

**Cycle** — the cycle this is assigned to. Can be a date range, a cycle number, or any label that makes the timing concrete.

Set `status: bet` in the frontmatter.

If the decision is no bet, update `status: candidate` and add a brief note under the Bet section explaining why — not as a permanent judgment, but as context for when the concept comes back.
