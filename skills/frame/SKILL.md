---
name: frame
description: Use when a raw idea, request, or complaint surfaces before any solution thinking begins.
---

# Framing

Framing is detective work on the problem. It narrows a vague candidate down to a specific failure with a specific cost, and confirms the business has urgency and appetite to invest in solving it.

The output is the Frame section of `docs/concepts/[name].md`. This document carries the work through shaping, betting, and building. The Frame is not a commitment to build — it is a commitment to shape.

**Framing is entirely about the problem. No solution territory, no breadboards, no technical discussion — those belong to shaping.**

## The Iron Law

```
NO SOLUTION TERRITORY IN FRAMING
```

Violating the letter of this rule is violating the spirit of it. If a breadboard appears, if a technical option is discussed, if implementation is mentioned — stop. Return to the problem.

## Phase 1: Confirm the Impetus

**Goal:** Establish that there is a business reason to spend time on this candidate now.

Someone already has a sense of urgency: a customer at risk, a recurring complaint, a strategic shift, a deal being lost. Find it. Framing without impetus produces a conversation that circles without landing.

Also ask for the appetite signal early — how much time would be worth spending if the problem turns out to be real? Appetite constrains the entire framing conversation and defines what counts as a good enough answer.

**Gate:** A business reason for investigating this problem *now* is explicit, and an appetite signal has been named.

```
IF no one can articulate why this matters now → this is still a candidate, not a framing conversation
IF appetite has not been named → ask for it before working the questions
```

## Phase 2: Work the Problem

**Goal:** Narrow the candidate from a label to a specific failure with a specific cost.

Framing is active detective work — live data, customer research, subject matter experts. The raw request is just the starting label. Work through these in order, and don't move on until each question has a real answer. Push back on vague or label-level responses.

**1. What is the raw request?**
Write it exactly as it came in: "Improve the dashboard." "Users are churning." This is the label, not the problem.

**2. Who specifically has this problem?**
Which user, role, or segment? Avoid "all users." Narrow to where the pain is sharpest.

**3. What are they doing today instead?**
The workaround. The problem exists right now — people are working around it. What is their current workaround? This surfaces the real situation, not a hypothetical.

**4. What goes wrong because of that?**
The cost of the workaround. What breaks, stalls, creates risk, or causes frustration? This is the key flip: from "what good happens if we do it" to "what goes wrong if we don't." The cost of inaction is the measure of the problem's actual weight.

**5. Why does this matter now?**
What triggered this conversation. "It's always been a problem" is not an answer — dig for the specific trigger.

**6. Is this specific enough to shape?**
A well-framed problem can be handed to a shaper who knows exactly what to investigate. If it's still a label, keep narrowing.

**7. Is the appetite still right?**
Given what you now know, does the original appetite match the problem's actual size?

**Gate:** All seven questions have specific, non-label answers. The problem is described as a failure with a cost for a specific segment — not a feature request or label.

```
IF the problem is still stated as a label ("improve X", "add notifications") → strip the label, narrow further
IF pushing back produces no more specificity → STOP. The room does not have enough knowledge to frame this. Find the domain expert who lives with the problem. Do not continue framing without them.
IF the cost of inaction is "not much" → the problem may not be urgent enough to invest shaping time in
```

### The Flip Technique

When comparing candidates or deciding if this one is worth framing, flip from benefit to cost:

Instead of: "What good happens if we do this?"
Ask: "What are they doing instead? What's bad about that?"

A workaround with meaningful cost (missed deadlines, churn risk, manual rework) is worth shaping. A workaround that is "inefficient but working" may not be. The flip makes trade-offs visible.

### Narrowing Moves

When the problem is still too broad:

- **Strip the label.** Restate as a failure, not a feature. "Notifications" → "The old mailing list is not connected to SSO and identities cannot be verified."
- **Slice by segment.** If the problem affects different users differently, pick the segment where the cost is highest.
- **Question the scope.** If the problem has sat unaddressed, ask why. Usually it was framed too broadly to shape.

## Phase 3: Test for Language Precision

**Goal:** Confirm the problem is stated in the affected people's own words.

Vague words ("improve," "better," "notifications") give way to specific domain terms ("payment recovery," "SSO-verified identity," "missed invoices") when framing is done. These are the words the people who live with the problem would use naturally.

**Test:** State the problem in one sentence using only the words the affected people would use. If anyone who understands the domain nods at it without needing explanation, framing is done. If the sentence still uses product terms the affected people would not reach for, it is not done.

This language carries into shaping. Elements, breadboards, and won't-dos must use the same words as the frame. Language drift between frame and shape is a signal the solution is drifting from the problem.

**Gate:** Problem stated in one sentence in domain language. Anyone who understands the problem recognizes it without needing explanation.

```
IF language is still vague after narrowing → find the domain expert who has their own name for it
```

## Output

When the three phases pass, write the concept document to `docs/concepts/[name].md`. Fill in the Frame section. Leave Solution, Bet, and Build as empty placeholders — shaping, betting, and building will complete them.

```markdown
---
status: frame-go
appetite:
cycle:
---

# [Concept Name]

## Problem
[What is actually going wrong, in one or two sentences. Not the label — the failure.]

## Who Is Affected
[The specific segment or role, and why them specifically.]

## What They Do Instead
[The current workaround.]

## What Goes Wrong
[The cost of the workaround. What breaks, what is at risk.]

## Why Now
[The urgency. What triggered this conversation.]

## Appetite
[How much time would be worth spending on this.]

---

## Solution

### Elements

### Breadboard

### Rabbit Holes

### Dos

### Won't-Dos

---

## Bet

### Decision

### Conditions

### Cycle

---

## Build

```

Set `status: frame-go` when the checkpoint passes. Set `status: candidate` and note what still needs investigation if it does not.

**Frame Go means:** "We are aligned on the problem and outcome, and we understand this enough to shape it."

## Red Flags

| If you're thinking... | Do this |
|---|---|
| "It's always been a problem" | No impetus — still a candidate |
| "Improve X" is still in the problem statement | Strip the label — that is not a problem |
| A breadboard or technical option has appeared | STOP — no solution territory in framing |
| The answer is vague but you're moving on | Push back — a vague answer is not an answer |
| You've worked through all questions but the problem is still fuzzy | The domain expert who knows the real name for this has not been consulted |
| The cost of the workaround is "inefficient but fine" | The problem may not be urgent enough to shape |

## Rationalization Table

| Excuse | Reality |
|---|---|
| "We know what the problem is" | If it's still stated as a label, you don't |
| "The appetite is obvious" | Unconfirmed appetite produces scope disputes during shaping |
| "The urgency is self-evident" | Urgency that can't be named is a feeling, not a business reason |
| "We can refine the problem during shaping" | Shaping over a vague frame produces the wrong solution |
| "The workaround isn't great but it works" | Use the flip: what specifically goes wrong because of it? |

## Quick Reference

| Phase | Key Activity | Gate |
|---|---|---|
| 1. Impetus | Business reason + appetite signal | Both explicit before working questions |
| 2. Work the Problem | Seven questions, flip technique | All 7 answered specifically; failure + cost + segment |
| 3. Language Precision | One-sentence domain-language test | Anyone who knows the domain nods at it |
