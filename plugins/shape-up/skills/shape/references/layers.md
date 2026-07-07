# Why routing and frame deltas — the layer model

Background for the routing rule and frame-delta protocol in SKILL.md. Read when you want the reasoning; the protocol itself is binding without it.

## Layers, not phases

The frame and the shape are two layers of one understanding that deepen together. The frame precedes the shape *logically* — every shape decision must trace to the currently-believed frame, the way an implementation must satisfy its spec — but not *temporally*. You discover spec bugs while implementing; you fix the spec and the affected implementation together; what you never do is let them silently diverge.

Frame-go is an **economic** checkpoint, not an epistemic one: it means "understood enough to justify shaping's spend," not "understanding complete." Shaping is the sharpest probe the frame ever gets — its concrete questions (where does the data live? what happens after the owner sees the failure?) surface problem-facts that no amount of framing alone would find. In the payment-recovery case study, the decisive insight — the product offers *no way to act* on a failed payment, so the problem is solving, not surfacing — emerged only in the second shaping session, and it renamed the whole concept. The most valuable frame-facts routinely arrive late, mid-shape, disguised as asides.

## The four failure modes the protocol prevents

| Failure | What it looks like | Cost |
|---|---|---|
| **Drop** | Frame-material ignored to keep shaping momentum ("let's not get derailed") | The nugget is lost; the shape solves a shallower problem than the one just revealed |
| **Ceremony** | Full framing re-run for one small fact | The user is exhausted into skipping the loop next time |
| **Silent absorb** | Shape adjusted to the new fact, frame.md untouched | Two documents diverge; the betting table reads a stale acceptance test and bets on the wrong justification |
| **Agent-authored reframe** | Agent rewrites the problem statement on its own judgment | The acceptance test itself gets hallucinated — the worst possible authorship |

The routing rule beats drop (every remark gets sorted). The escalation ladder beats ceremony (magnitude decides how much process a delta gets). Step 4 of the protocol beats silent absorb (frame.md always receives the delta). Step 3 beats agent-authored reframes (a reframe is always a user decision point).

## Why "park it" must still touch frame.md

Parking a discovered problem for a future pitch is often right — appetite is fixed, and not every nugget belongs in this cycle. But a parked fact that lives only in the conversation evaporates. Written into frame.md (Evidence, or context under New Problems), it reaches the betting table, where "what did we learn that we're deliberately not doing?" is exactly the kind of input the five questions need.

## Why the appetite negotiation is spoken, not silent

In the case study, the shaper said to the SME: "I'm not sure we have time for all of this" — and the SME replied he'd only mentioned class utilization "because you said you needed more." The trade-off resolved itself the moment it was voiced: half the scope turned out to be filler elicited by over-asking. Silent descoping would have either kept the filler or cut the wrong thing. Hence the two spoken probes in protocol step 5: the one-thing question, and the provenance question.
