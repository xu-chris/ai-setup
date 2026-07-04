# The pivotal move and the bet pattern

Two expanded tools. The first is the technique that most determines whether the user accepts being pushed. The second is the structure that turns a strategy into something reality can test.

---

## The pivotal move: reframe identity-laden resistance as a constraint

### When it applies
The user resists a strategic direction, and the resistance sounds like values, identity, or principle rather than analysis. "Selling is against my values." "I didn't get into this to chase money." "I want the work to speak for itself." The resistance is real and the user means it. It is also blocking a choice the strategy needs.

### What not to do
The strong-agent default is to argue the user out of the value. Do not. These are the moves to avoid, observed verbatim in baseline testing:
- "I'd push on that, because I think you've fused two different things." (Splitting their value to dismantle it.)
- "Products don't speak — people do." (Telling them their belief is naive.)
- "That's two fears bundled into one comfortable decision." (Psychoanalyzing the user.)

Each of these attacks the identity. The user now has to defend who they are, and any direction you propose is something they must abandon themselves to accept. Pushing this way feels like domination, and it does not land.

### The move
Treat the aversion as a **constraint**, not a flaw or an error to be corrected. It is the same kind of input as "solo founder, twenty hours a week" or "no outside capital." A good strategist designs around real constraints rather than wishing them away.

"Your aversion to selling is not a position I am going to argue with. It is a constraint. The strategy has to work without you doing cold outreach or self-promotion. That rules some go-to-market mechanics out and leaves others in. Let's design inside that."

### Why it works — three things at once
1. **It honors the identity instead of attacking it.** The user keeps who they are. Nothing to defend.
2. **It dissolves a false axis.** The user thought the choice was commercial-versus-public-good. It was actually the go-to-market mechanic, which is compatible with either. (See the third-option pattern below.)
3. **It converts a blocker into a design input.** The aversion now shapes the strategy instead of stopping it.

The user accepts a direction he was resisting because he no longer has to stop being himself to take it.

### The third option that dissolves a false binary
The constraint-reframe usually exposes a false binary underneath the resistance. When a user is stuck between two unsatisfying options, suspect the binary itself.
- commercial vs. public-good → **the go-to-market mechanic**, which is compatible with either.
- coercion (lock-in) vs. hope (they convert on their own) → **ongoing differential value**, which is neither.

Name the binary, then name the axis it was hiding.

---

## The bet pattern

A strategy is a hypothesis (ch. 16). Make its claims testable so reality can confirm or refute them on a schedule. Build each load-bearing claim through these stages.

### 1. Observed vs. assumed
Pull each claim apart into what you have seen and what you are betting on.
> "Institutional openness is observed. Institutional payment-willingness is assumed."
The assumed half is the bet.

### 2. State it as a named bet
Lift the assumption out of the prose and write it as a discrete claim the strategy rests on.
> Bet A: the bottom-up free tier converts individual users into institutional buyers.
> Bet B: institutional openness translates into institutional payment.

### 3. Falsification condition + time horizon (ch. 17)
Commit the judgment to writing in advance, so you can tell slow-but-working from failing. Each bet gets a condition and a date.
> Bet B is refuted if, by month 18, no institution that adopted the free tier has converted to a paid license.

A strategy with a deliberately slow funnel needs this most — without a date, "still early" is indistinguishable from "not working."

### 4. Per-bet checkpoint vs. global kill-switch
- Map each checkpoint to the bet it actually tests. Do not attach two checkpoints to one bet and leave another bet with none.
- Reserve a separate **global kill-switch** for "the core strategy has not carried." Watch for a "neither X nor Y" condition that a few stray successes keep alive on paper while the core has failed — that is not a real kill-switch.
- Attach the fallback to the global trigger, not to an incidental signal.

### 5. Park recurring temptations as triggered contingencies
A direction the user keeps returning to but that is not the current strategy gets a defined home: the documented response to the global kill-switch firing. Neither adopted now nor banished.
> If the global kill-switch fires at month 24, the fallback is the open-source / non-profit version.

Keep the success-path structure and the failure-path fallback distinct in the document so they do not blur into each other.

---

## Reusable-test habit (worked instance)
When the same judgment keeps recurring, distil it into a portable rule the user can apply alone. The source session produced a two-part test for whether a feature carries paid value:
1. Can a static export reproduce it? (If yes, it does not carry paid value.)
2. Is it still wanted at the end of the use-lifecycle? (If no, it does not carry paid value.)

This replaced the fluffy principle "build features that create longing" — longing is the effect; the absent, non-reproducible, still-wanted function is the cause. State causes, and prefer a formulation that implies a test.
