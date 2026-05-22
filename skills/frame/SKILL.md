---
description: Use when a raw idea, request, or complaint surfaces and needs to be examined before any solution thinking begins. Guides the user through narrowing a candidate into a clear problem statement with appetite signal. Invoke at the start of any new work, before shaping.
---

# Framing

Framing is the work of finding out whether a candidate is worth shaping. It is entirely about the problem. No solution territory, no breadboards, no technical discussion. Those belong to shaping.

The output of framing is a concept document with the problem section filled in. This document carries the work through shaping, betting, and into building. Framing establishes the foundation every subsequent phase builds on.

The Frame is not a commitment to build. It is a commitment to shape.

## Before Starting: The Business Signal

Framing takes real time and attention. Before spending it, there needs to be an impetus: a business reason that this problem is worth investigating now. That reason might be a customer at risk, a recurring complaint, a strategic shift, or someone saying "we keep losing deals over this." Whatever the form, it must exist.

If no one can articulate why this problem matters right now, the conversation has not yet reached framing. It is still at the candidate stage. A candidate without a business impetus produces a framing conversation that circles without landing.

Appetite arrives with the impetus, not at the end of framing. Someone already has a sense of what this is worth: "if we can solve it in two weeks, that would be meaningful" or "this is small enough that a few days would do." Ask for that signal early. It constrains the entire framing conversation and defines what counts as a good enough answer.

## How to Frame

Work through the following questions in order. Do not move to the next question until the current one has a real answer. Push back on vague or label-level answers.

**1. What is the raw request?**
Write down the candidate exactly as it came in. "Improve the dashboard." "Users are churning." "We need notifications." This is the label, not the problem.

**2. Who specifically has this problem?**
Which user, role, or customer segment experiences this? Avoid "all users". That is almost never true. Narrow to the segment where the pain is sharpest.

**3. What are they doing today instead?**
The problem exists right now. People are working around it somehow. What is their current workaround? This question surfaces the real situation, not a hypothetical.

**4. What goes wrong because of that?**
What is the cost of the workaround? What breaks, gets delayed, creates risk, or causes frustration? This is the flip that makes framing decisive: from "what good happens if we do it" to "what goes wrong if we don't." The cost of inaction is the measure of the problem's actual weight.

**5. Why does this matter now?**
What makes this urgent at this moment? Is there a deadline, a customer at risk, a strategic shift? If the answer is "it's always been a problem," dig deeper. Something triggered this conversation now. Find it.

**6. Is this specific enough to shape?**
A well-framed problem can be handed to a shaper who knows exactly what to investigate. If the problem is still a label ("improve X"), keep narrowing. If it names a specific failure with a specific cost for a specific segment, it is ready.

**7. Calibrate the appetite.**
Given what you now know about the problem, is the original appetite still right? A smaller problem can be shaped in less time. A larger one may need a bigger appetite or a narrower problem definition. Appetite is fixed once confirmed: scope adjusts to fit it.

## Narrowing Moves

When the problem is still too broad, use these moves:

**Strip the label.** Restate the candidate as a failure, not a feature. "Notifications" is a label. "The old mailing list is not connected to SSO and we cannot verify identities" is a problem.

**Slice by segment.** If the problem affects different users differently, pick the segment where the cost is highest. Solve for them first.

**Question the scope.** If the problem has been sitting unaddressed, ask why. Usually the answer is that it was framed too broadly to shape. Narrowing is not a compromise. It is the work.

## The First Model Is Wrong

Expect the first framing to be wrong. The real problem is almost never what the candidate says it is. "Improve the dashboard" is not a problem. It is a label someone attached to a feeling. Keep asking until the real problem surfaces.

The signal that framing is done is not narrowness alone. It is language precision. When the problem is genuinely understood, the words change. Vague words ("improve", "better", "notifications") give way to specific domain terms ("payment recovery", "SSO-verified identity", "missed invoices"). These are the words the people who live with the problem would use themselves.

A practical test: try naming the problem in one sentence using only the words the affected people would use. If the sentence is clear and everyone who understands the domain nods at it, framing is done. If the sentence still needs explanation or uses product terms the affected people would not reach for naturally, it is not done yet.

This matters because language carries into shaping. The elements named in shaping, the places described in the breadboard, the won't-dos that bound the solution: all should use the same language as the frame. A frame that uses labels produces a shape that drifts from the problem. A frame that uses the domain's own words produces a shape that can be tested against the problem directly.

If the framing conversation keeps circling without landing on precise language, it usually means there is a domain expert who has not yet been consulted: someone who lives with the problem and has their own name for it. Find that person and that name.

## Output: The Concept Document

When the questions have real answers, write the concept document to `docs/concepts/[name].md`. Fill in the Frame section. Leave Solution, Bet, and Build as empty placeholders. Shaping, betting, and building will complete them.

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

## Checkpoint

A Frame is ready when someone outside the conversation can read it and understand exactly what problem is being solved, who it affects, what it costs them, and why it matters now. Three signals confirm this:

The problem is described in the domain's own language: specific terms the affected people would recognize and use, not labels or feature names.

The problem is precise enough that a shaper knows what to investigate without needing to re-ask what the problem is.

The appetite is confirmed and realistic: someone with business judgment has said this problem is worth that amount of time.

**Frame Go** — problem and outcome are tight, appetite is confirmed, language is precise, and a business reason exists to spend time shaping. Set `status: frame-go` in the document.

If the frame does not reach Frame Go, set `status: candidate` and note what still needs investigation before it is ready to shape.
