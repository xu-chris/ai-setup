# Latitude calibration — undershaped vs overshaped

**Latitude** is the amount of detail in the shaped concept: how much is spelled out and how much is left open for the team to decide later. Shaping fails at both extremes. Use this file when you suspect the current shape is drifting toward one of them — the tells below are checkable mid-session.

The target, in Ryan Singer's words (talk linked from `the-cost-of-not-shaping.md`):

> Between over-shaped and under-shaped there's shaped work. We explain in words the broad idea of the project, the main elements and how they fit together to form the solution, and we often add some rough sketches that show the key relationships. This gives the team the understanding of what we're trying to do without boxing them in… When the work is defined at the right level of latitude we can give the team autonomy over the project.

A well-shaped concept specifies **a space of valid configurations, not one configuration** — the relationships that qualify a build as "some version" of the design (Singer, "Shaping with pattern languages").

## Tells you're undershaping

The #1 failure mode of Shape Up adoptions (Singer, pitfalls post). Unsolved unknowns move into the time box, the work stalls, and the team never gets a fair chance at its six weeks.

| Tell | What it predicts | Corrective move |
|---|---|---|
| A part reads like a wish — "teachers should easily see all assessments in one place" — magic-wand language, no mechanism | The team must figure out what it means, where it fits, how it connects — inside the box | Convert the wish to mechanism parts; breadboard the flow |
| A part is a bare noun: "dashboard", "notifications", "a settings area" | Grab-bag; no boundary on scope | Ask ch. 4's questions: where does it fit, how do you get to it, what are the key interactions, where does it take you |
| "The designer/team will figure that part out" for a problem you couldn't solve yourself | The abandoned Basecamp home-screen bet: no viable approach existed; fat-tailed 3× overrun | Validate a viable approach exists now — sketch it or spike it, or descope |
| Engineers respond with big padded estimates ("anything of value takes months") | Rational padding of fuzziness, not obstruction | Sharpen the itch and the trade-offs in dialogue; don't take scope at face value |
| Open ⚠️ flags or TBDs surviving toward Shape Go | Week-three time bombs | Spike or descope; a flagged unknown cannot pass a fit check |
| Fit check passes suspiciously easily | Requirements as vague as the shape — both unfalsifiable | Rewrite Rs as specific needs; re-run |

## Tells you're overshaping

The "beautiful monster": a completely detailed specification — the giant Figma file, 30 screens, finest detail. Its certainty is an illusion, and it costs twice:

1. **The build exceeds the box.** Programmers discover the details cost more time than they have, chop the project up themselves, and their in/out choices don't match the designer's or the business's intent. Frustrating for everybody.
2. **Stuck with the first idea.** "Anytime something goes into a hardline drawing it becomes sacred" — people can't let go of it when reality demands changes.

| Tell | What it predicts | Corrective move |
|---|---|---|
| High-fidelity artifacts appearing during shaping (Figma, styled mocks, hardline drawings) | Sacred first idea; certainty illusion | Retreat to fat-marker / breadboard; keep only the key relationships. High fidelity comes last, in the build cycle |
| Debating placement, exact copy, colors, component names | You've left fat-marker level | The abstraction test: can the builder make this decision without understanding the problem? Then leave it out |
| The spec keeps getting more specific and the estimate keeps getting *less* certain | Ch. 2's counterintuitive law: "just so" interfaces hide complexities; fixed scope kills the team's ability to reconsider costly decisions | Reopen scope variability: name what's core vs. peripheral instead of pinning the form |
| The team's only remaining job is transcription | No room for judgment; a better product was foreclosed (ch. 10) | Delete detail until open spaces reappear where their contributions go |
| The shape dictates one exact configuration | No "some version" latitude; unexpected constraints have nowhere to flex | Restate parts as relationships and mechanisms, not layouts |
| Senior person's sketch treated as direction | "They'll take every detail as direction even though you didn't intend it" (ch. 4) | Strip the sketch to fat-marker; add the disclaimer about builder latitude |

## Sources

- Shape Up ch. 2 (the axis: too vague / too concrete; Dot Grid as calibrated example), ch. 4 (room for designers), ch. 5 (fat-tailed risk, abandoned home-screen bet), ch. 6 (pitch-level detail), ch. 10 (team autonomy).
- Felt Presence: pitfalls post (undershaped = #1 adoption failure; high fidelity last), "What's the right level of detail when shaping?" (detail depends on the doc's purpose), "When engineers say that'll take months" (padding as undershaping symptom), "Shaping with pattern languages" (space of configurations), and the over/under-shaping talk transcript quoted above.
