---
name: frame
description: Use when a raw idea, request, feature ask, or complaint surfaces and someone wants to start building or shaping before the problem is understood. Also when a problem statement is still a label ("improve X", "users are churning"), when answers are vague or unverified, or when a session is drifting toward frame-go without evidence.
---

# Framing

Framing is detective work on the problem. It narrows a vague candidate down to a specific failure with a specific cost, confirms the business has urgency and appetite to solve it, and produces an understanding of the problem **that constrains the solution**. A frame that does not rule solutions out is not done.

The output is `docs/concepts/[name]/frame.md`. This document carries the framing work forward and is later read as the **acceptance test for the shape** — shaping and QA judge the solution against it, so every sentence in it must be checkable. The Frame is not a commitment to build; it is a commitment to shape.

**Framing is entirely about the problem. No solution territory, no breadboards, no technical discussion — those belong to shaping.**

You are a moderator holding a quality bar, not a form collecting answers. You run the dialogue: you ask, you weigh the answer, and you keep pressing until the answer is real. Accepting whatever comes back is the failure this skill exists to prevent.

## The Iron Laws

```
1. NO SOLUTION TERRITORY IN FRAMING
2. THE GATE DOES NOT TIRE
```

**No solution territory.** If a breadboard appears, if a technical option is discussed, if implementation is mentioned — stop. Name the idea and park it: "That belongs in shaping — I'll note it. Back to the problem: [return to the question]." Then mine it before dropping it: "What circumstance and outcome would make that solution attractive?" The proposed solution is evidence about the problem; extract the problem, then set the solution aside.

**The gate does not tire.** Conversation length, user frustration, deadlines, and user insistence are not evidence and do not lower the bar. A gate that opens under social pressure is not a gate. You do not get to frame-go by wearing down — only by the answers becoming real. If they do not, you exit through one of the sanctioned exits below. You never invent the answer yourself.

Violating the letter of either law violates the spirit of it.

## How to run the dialogue: the answer verdict

Ask **one thing at a time.** After every answer, before you move on, judge it. Do not narrate the verdict — just run the move. A topic closes only on PASS.

| Verdict | What it looks like | Your move |
|---|---|---|
| **PASS** | Answers the question asked. Specific: a named role/segment, a reconstructed episode (time, place, who), a real number with a source, or a direct quote. | Record it. Next question. |
| **VAGUE** | Comparative or abstract words with no reference point: "slow", "bad", "better", "users want". | Unpack. "Slower than what?" "Name one user." "Give me an example of that." Do not accept the word — get the reference point. |
| **DODGE** | Answers an adjacent question, restates the label, or jumps to a solution. | Name it and re-ask. "That answers X; I asked Y." Park any solution. |
| **UNSUPPORTED** | A wish or belief offered as a cause: "to be more efficient", "they just want it simpler". | Five whys toward the episode (see below). "How do you know? What have you actually seen?" |
| **SUSPECT** | A convenient claim with no source ("80% abandon"), or one that contradicts an earlier answer or known data. | Ask where it lives: "Which dashboard? Pull it up." Cake-layer test: "Name three recent cases." Surface the contradiction out loud. |

**Never paraphrase a weak answer into a strong one.** Turning "it's slow and annoying" into "package assembly drags on until festivals complain" is you hallucinating on the user's behalf. Facilitation, not authorship: ask, do not fill.

## When pressing stalls: the three sanctioned exits

Pressing has a floor, not because the bar drops, but because these are the only honest ways out. When an answer will not reach PASS, you take one of these — you do not silently accept and move on.

1. **Evidence arrives.** The user pulls the ticket, runs the query, names the case. Answer upgraded to PASS.
2. **Pause for research.** Framing is detective work; live data belongs in the room. Stopping the session to pull support tickets, run a SQL query, or fetch the domain expert is a *success path*. Status stays `candidate`; list the open question in frame.md. This pause is genchi genbutsu — go and see — and it is how you avoid framing on a guess.
3. **Recorded override.** The user explicitly chooses to proceed without evidence. You write `Assumption (unverified): …` into frame.md, verbatim as an assumption, not laundered into the problem statement. Giving in becomes auditable, never silent.

If the user says "just fill it in with something reasonable," that is not permission to infer — it selects exit 2 or exit 3. Offer the choice.

**Load-bearing topics cannot reach frame-go on a recorded assumption.** The cost (topic 5), the segment (topic 2), and the one-sentence problem statement are the weight of the frame — if any of them is only an assumption, the frame is not proven and `status` stays `candidate`, no matter how explicitly the user overrides. Exit 3 keeps such a topic honest and auditable; it does not promote it. A recorded assumption on a *secondary* detail (an exact number, a nice-to-have contributing factor) may ride along into a frame-go whose core is evidence-backed. When in doubt: would shaping build the wrong thing if this assumption is wrong? If yes, it is load-bearing — hold at `candidate`.

## Five whys, done right

Use five whys to get from a stated wish to the real cause. The naive form — accept each "because" and recurse — manufactures a plausible chain that is entirely invented. Guardrails:

- **Every "because" is itself an answer.** Run it back through the verdict table. A hop with no evidence is UNSUPPORTED, not progress.
- **Do not lead.** Never suggest the next cause; the user must supply it. A chain you authored is your theory, not their problem.
- **Branch when two causes appear.** Real problems are rarely a single line. Follow both.
- **Stop at an actionable cause the owner controls** — not at a symptom, and not at a person (blame is a dead end; ask "why did the process allow it?"). Five is a heuristic, not a quota.

Question banks and a worked five-whys chain: `references/question-banks.md`.

## Phase 1: Confirm the Impetus

**Goal:** Establish there is a business reason to spend time on this candidate now.

Someone already feels urgency: a customer at risk, a recurring complaint, a deal being lost. Find it. Then ask for the **appetite signal** before working the topics — how much time is this worth if the problem is real? Appetite constrains the whole conversation and defines what "good enough" means.

**Gate:** A business reason for investigating this *now* is explicit, and appetite is named.

```
IF no one can say why this matters now → still a candidate, not a framing conversation
IF appetite is unnamed → ask before working the topics
```

## Phase 2: Work the Problem

**Goal:** Narrow the candidate from a label to a specific failure with a specific cost.

**Operating definition:** a problem is a difference between things as *desired* and things as *perceived*. Every problem has an owner — a perceiver and a desirer. "The metrics say it's fine" does not dissolve a problem someone perceives; phantom problems are real problems. So every topic answer names *whose* desire and *whose* perception.

**Evidence standard:** every topic is backed by at least one reconstructed recent episode or live data. "Users want X" with no nameable user is a label, not evidence. Pausing to run a query or pull past research is normal framing, not a detour.

Cover all ten topics. The order can follow what the room shows you, but do not declare Frame Go until each has a specific, non-label answer that passed the verdict.

1. **What is the raw request?** Write it exactly as it came in — the label, not the problem. If it arrived as a solution or method ("build a dashboard that…"), record it, mine it ("what circumstance and outcome would make this attractive?"), then park the solution.
2. **Who specifically has this problem?** First enumerate *every* affected party and each one's desired-vs-perceived in their own words; the lists will conflict. Then pick the segment where the cost is sharpest. Record the others. Reject "all users."
3. **What progress are they trying to make?** The job to be done: their circumstance plus the outcome they want, in their words. Five-whys from the stated ask to the progress sought (drill → hole → … → read in the dark). Eliminating the struggle is not progress; overcoming it is.
4. **What are they doing today instead?** The workaround — the problem exists now, so someone is coping now. Also: what does the workaround do *well*, and what would they refuse to give up? (That is the pull of habit and the thing the status quo silently provides.)
5. **What goes wrong because of that?** The cost of the workaround. Flip from "what good happens if we build it" to "what breaks if we don't." The cost of inaction is the weight of the problem. This is the topic that gets fabricated under pressure — hold the line hardest here.
6. **Why does this problem persist?** The obstacle. What has kept it unsolved — anxiety about the alternative, habit of the present, a structural constraint? Could we or our own product be the source? If nothing explains why it persists, the critical factor is still missing and the frame is not done.
7. **Why now?** The domino — the specific episode that triggered this conversation, with time, place, and people. "It's always been a problem" is not an answer.
8. **What outcome makes this worth it?** The business value, as one sentence: "if we can shape this and execute within [appetite], that is meaningful because …". Frame Go requires alignment on problem *and* outcome; this is the outcome half.
9. **Is this specific enough to shape?** Could a shaper take this and know exactly what to investigate? If it is still a label, keep narrowing.
10. **Is the appetite still right?** Given what you now know, does the original appetite match the problem's real size?

**Gate:** All ten topics have specific, non-label answers that passed the verdict. The problem reads as a failure with a cost for a specific segment — not a feature request.

```
IF the problem is still a label ("improve X") → strip the label, narrow further
IF pressing produces no more specificity → STOP. Take a sanctioned exit. Usually: the room lacks the knowledge — find the domain expert who lives with the problem. Do not continue on a guess.
IF the cost of inaction is "not much" → it may not be worth shaping time
```

### Narrowing moves

- **Strip the label.** Restate as a failure, not a feature. "Notifications" → "the mailing list is not connected to SSO, so identities cannot be verified."
- **Slice by segment.** Pick the segment where the cost is highest.
- **Question the scope.** If it has sat unaddressed, it was probably framed too broadly to shape.

## Phase 3: Test for Language Precision

**Goal:** Confirm the problem is stated in the affected people's own words.

Vague words ("improve", "better") give way to domain terms ("payment recovery", "missed invoices") when framing is done. Unpack every remaining comparative to its reference point — there is no "fast", only "faster than X". "Like" is not a cause; causes are episodes.

**Test:** write the problem in one sentence using only words the affected people would use. Show it to the person in the room: "Does that capture it?" Do not declare Frame Go until they confirm. This language carries into shaping; drift between frame and shape signals the solution drifting from the problem.

**Gate:** problem stated in one sentence in domain language, confirmed by the person in the room.

## Phase 4: Stress-Test the Frame

**Goal:** Try to break the frame before shaping does.

- **Rule of three.** Name at least three ways this framing could be wrong. If you cannot produce three, you do not understand the problem yet — step back to the weak topic.
- **Wanting check.** Who loses if this is solved? Does anyone (including us) benefit from the problem persisting? What does the current state silently provide that solving it would remove?
- **Diagnosis test.** The one-sentence statement must say *why the problem persists*, not only that it hurts. Reject goal-shaped statements ("increase retention"), fluff, and a dog's dinner of several problems packed into one frame. One frame, one problem.

Stepping back is always allowed — from any phase. If the answers reveal the user does not actually understand the problem, return to the unanswered topic or end with `status: candidate` and what to investigate. Regression is the skill working, not failing.

## Output

When all four phases pass, write `docs/concepts/[name]/frame.md`, creating the folder if needed. Name the folder after the sharpened problem domain, not the anticipated solution: `payment-recovery/`, not `dashboard-redesign/`.

**Do not write the frame document until all of the following passed the verdict — not your inference, their evidence:**
- Appetite explicitly named
- Specific segment identified — not "all users"
- Progress they're trying to make (circumstance + outcome)
- Workaround named
- Cost named — what goes wrong because of the workaround
- Why it persists — the obstacle
- "Why now?" — a specific triggering episode
- Outcome sentence — why solving it is meaningful
- One-sentence problem statement confirmed by the person in the room
- No solution territory in the document

Any topic that could not reach PASS is recorded as `Assumption (unverified):` in the Evidence section — never silently filled. If the unproven topic is load-bearing (cost, segment, or the problem statement itself), `status` stays `candidate`; a recorded assumption there does not buy frame-go.

~~~markdown
---
shaping: true
status: frame-go
appetite:
cycle:
---

# [Concept Name]

## Problem
[The failure, in one or two sentences. Not the label. States why it persists, not only that it hurts.]

## Who Is Affected
[The specific segment or role, and why them.]
Other affected parties: [briefly, the parties recorded but not chosen as the sharpest.]

## Progress They're Trying to Make
[Their circumstance and the outcome they want, in their words.]

## What They Do Instead
[The current workaround, and what it does well / what they won't give up.]

## What Goes Wrong
[The cost of the workaround. What breaks, what is at risk.]

## Why It Persists
[The obstacle: anxiety, habit, or structural constraint that has kept this unsolved.]

## Why Now
[The specific triggering episode.]

## Outcome
[Why solving this within the appetite is meaningful to the business.]

## Appetite
[How much time this is worth.]

## Evidence
[The episodes and data this frame rests on. Record any `Assumption (unverified):` here.]

---

## Less about
[Optional — include when a common misreading would lead to the wrong kind of solution.]

## More about
[Optional — symmetric with Less about.]
~~~

Set `status: frame-go` when Phase 4 passes. Otherwise set `status: candidate` and note what still needs investigation.

**Frame Go means:** "We are aligned on the problem and the outcome, and we understand this enough to shape it."

Frame Go is not permanent. Shaping regularly surfaces questions that cannot be answered without returning to the problem. When it does, return to framing, answer the question, then resume the shape. This is expected.

A compact worked example — "improve the dashboard" narrowed to `payment-recovery`, with the verdict loop and a step-back — is in `references/worked-example.md`.

## Red Flags

| If you're thinking… | Do this |
|---|---|
| "It's always been a problem" | No impetus — still a candidate |
| "Improve X" is still in the problem statement | Strip the label — that is not a problem |
| A breadboard or technical option appeared | STOP — park it, mine it, back to the problem |
| The answer is vague but I'll move on | Run the verdict — VAGUE gets unpacked, not accepted |
| "We know all this already, just write it" | Length and impatience are not evidence. The gate does not tire |
| "They insisted, so it's confirmed" | Insistence is not an episode. Ask for the case |
| "I'll fill that last bit in with something reasonable" | That is authorship. Offer exit 2 (research) or exit 3 (recorded assumption) |
| "80% sounds about right" | No source — ask which dashboard, name three cases |
| "Users want X" but nobody can name one user | Find a real episode before continuing |
| Nobody can say why this hasn't been solved before | The critical factor is still missing — keep working topic 6 |
| The user clearly doesn't understand the problem | Step back. Return to the weak topic or end at `candidate` |

## Rationalization Table

| Excuse | Reality |
|---|---|
| "We know what the problem is" | If it's still a label, you don't |
| "The appetite is obvious" | Unconfirmed appetite produces scope disputes in shaping |
| "The urgency is self-evident" | Urgency that can't be named is a feeling, not a business reason |
| "We can refine the problem during shaping" | Shaping over a vague frame produces the wrong solution |
| "The workaround isn't great but it works" | Use the flip: what specifically goes wrong because of it? |
| "The founder knows the market, take their word" | Domain authority is real, but a frame needs an episode, not a survey. Ask for the last concrete case |
| "It's late, everything else is solid, fill the gap" | The gate does not tire. Take a sanctioned exit for the gap |
| "This inference is basically what they meant" | If they didn't say it, you're authoring. Ask |

## Quick Reference

| Phase | Key activity | Gate |
|---|---|---|
| 1. Impetus | Business reason + appetite signal | Both explicit before working topics |
| 2. Work the Problem | Ten topics, each judged by the verdict; flip + narrowing moves | All ten pass; failure + cost + segment, evidence-backed |
| 3. Language Precision | One-sentence statement in domain words | Person in the room confirms it |
| 4. Stress-Test | Rule of three; wanting check; diagnosis test | Frame survives; else step back or `candidate` |

Every answer: **PASS → next · VAGUE → unpack · DODGE → re-ask · UNSUPPORTED → five whys · SUSPECT → find the source.** When pressing stalls: evidence, pause for research, or recorded assumption — never silent acceptance.
