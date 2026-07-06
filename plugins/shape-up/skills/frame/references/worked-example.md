# Worked example: "improve the dashboard" → payment-recovery

A compact trace of a real framing arc (adapted from Ryan Singer's end-to-end case study). It shows the verdict loop pressing, a solution getting parked and mined, a step-back to a domain expert, and a topic dropped on the way to a sharp frame. Watch what the moderator does after each answer — that judgment is the skill.

---

**Candidate:** "We should improve the gym-owner dashboard. It feels cluttered."

**Impetus / appetite.** "Why now?" → "Sales keeps hearing it on calls." "How much is it worth if real?" → "About one cycle." Impetus + appetite: PASS. (The raw request is a *solution* — "improve the dashboard." Recorded as label; mined below.)

**Topic 1 — raw request.** Recorded verbatim: "improve the gym-owner dashboard, it feels cluttered." Mine it: "What would a cleaner dashboard let a gym owner *do* that they can't today?" → routes into the real problem.

**Topic 2 — who specifically?** → "Gym owners." Verdict: VAGUE — a category, not a segment. Press: "Which gym owners — big chains, single-location, franchises?" → "I actually don't know the specifics." **Step back / sanctioned exit 2:** pause and find the domain expert. The CTO names a sales rep who was a gym owner. Session resumes with him.

**Topic 3 — progress they're trying to make.** With the expert: "When a small gym owner opens this dashboard on a Monday, what are they trying to find out?" → "Whether anyone's payment failed, and whether classes are filling up." Two candidate jobs. PASS, with a branch noted.

**Topic 4 — what they do instead.** → "They export the payments CSV and eyeball it, and they scroll the class roster." Reconstructed, specific. PASS.

**Topic 5 — what goes wrong.** Flip: "They can't easily see failed payments — what's bad about the CSV workaround?" → "It's a bit tedious." Verdict: VAGUE — "tedious" is not a cost. Press for the episode: "When did that last bite someone?" → "One owner didn't notice three failed memberships for two months — lost about $400 before catching it." PASS. Now there's a cost with a number.

Contrast the class-utilization branch: "And missing the class-fill view — what's the cost there?" → "Honestly, nice-to-know. Nobody's lost anything over it." Verdict: cost is "not much." **Topic dropped** — class utilization leaves the frame. This is narrowing by segment/job, not scope-cutting a solution.

**Topic 6 — why it persists.** "Why hasn't this been solved already?" → "The dashboard shows everything at once, so the money-critical stuff is buried in noise. And owners assume our system already alerts them — it doesn't." Obstacle named (habit of the layout + a false assumption). PASS.

**Topic 7 — why now.** "The specific trigger this week?" → "Two owners on Monday's calls said they'd been burned by missed payments." Episode, dated, with people. PASS.

**Topic 8 — outcome.** → "If we can surface failed payments so owners act on them within the cycle, that's meaningful because payment recovery is money they keep and a reason not to churn off us." PASS.

**Topics 9–10.** Specific enough to shape? Yes — a shaper knows exactly what to investigate. Appetite still right? One cycle now looks generous for "surface and act on failed payments"; noted.

**Phase 3 — language precision.** One sentence, in the owner's words: *"Small gym owners can't see which memberships have failed payments, so they lose recurring revenue before they notice."* Shown to the expert: "Does that capture it?" → "Yes, that's exactly it." Note the drift: the frame is no longer about "the dashboard" (a solution surface) — it's about payment recovery. Folder named `payment-recovery/`, not `dashboard-redesign/`.

**Phase 4 — stress-test.**
- Rule of three: (1) maybe owners *do* notice and the real gap is acting on it, not seeing it; (2) maybe failed payments are rare and the $400 case is an outlier; (3) maybe the churn link is assumed, not shown. Three produced → understood enough. Each becomes an `Evidence`/assumption note.
- Wanting check: who loses if solved? Nobody internal; the current CSV export can be retired safely.
- Diagnosis test: the sentence names *why it persists* (buried in noise + false assumption of alerts), not just that it hurts. Not a goal, not fluff, one problem. PASS.

**Frame Go.** `status: frame-go`. Written with the `payment-recovery` frame.

---

**The step-back loop, later.** During shaping, a question surfaces: does "act on a failed payment" mean retrying the charge, or just notifying the owner? That can't be answered from the solution side — it depends on what recovery the owner actually does today. Shaping pauses; framing resumes for one topic; the answer ("owners just want to know so they can text the member") folds into the frame. Then shaping continues. Regression is the process working.
