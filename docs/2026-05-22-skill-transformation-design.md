# Shape-Up Skills Transformation Design

*2026-05-22*

## Goal

Transform all six Shape-Up skills (frame, shape, bet, kickoff, scope, ux-design) from documentary skills into behavioral skills without losing domain knowledge. The skills currently convey the Shape Up methodology accurately but do not enforce it. They tell agents what shaping is — not what to do, what to stop for, and what to check.

## The Problem

Documentary skills provide knowledge. Behavioral skills enforce process. Under pressure, agents follow the path of least resistance. A skill with rich prose knowledge but no stopping conditions, no gates, and no red flags will be read and then bypassed when a shortcut appears.

The Shape-Up skills' specific failure modes:
- Shaping at implementation-detail level (no abstraction gate)
- Continuing to shape over an unresolved framing question (no return-path rule)
- Betting on a fuzzy shape (no quality gate before betting)
- Organizing scopes by layer instead of vertical slice (no red flag)
- Breaking down all scopes upfront (no one-at-a-time constraint)

**Core principle: Agents have to behave, not only know.**

## Approach: Phase Reframe

Three approaches were considered:

| Approach | Description | Rejected Because |
|---|---|---|
| Machinery Injection | Keep prose, add components on top | Machinery feels bolted on; knowledge stays unscanned |
| Core + Reference Split | Tight behavioral SKILL.md + supporting files | Agents may skip supporting files in practice |
| **Phase Reframe** | Restructure around phases with gates | Best integration of knowledge and behavior |

Phase Reframe restructures each skill around named phases with explicit gate conditions. Domain knowledge relocates inside phases as the reasoning behind gates and red flags. Knowledge becomes constraint.

## Component Schema

Every transformed skill receives:

### Frontmatter
- `name:` field (add if missing)
- `description:` — triggering condition only. Cut all process summary. Starts with "Use when..."

### Iron Law
One non-negotiable rule as a code block. Immediately after the overview. Cannot be argued around.

### Phases with Gate Conditions
Sequential phases, each with:
- **Goal** — one sentence
- **Activities** — bullets drawn from existing domain knowledge
- **Gate** — explicit pass/fail condition blocking progress to next phase

### If-Else Blocks for Non-Linear Flows
Any branching, iterative, or return-path behavior as explicit if-else conditionals. No flowcharts — agents require a visual-to-rule translation step that flowcharts demand. If-else blocks are directly executable.

### Red Flags Table
| If you're thinking... | Do this |

### Rationalization Table
| Excuse | Reality |

### Quick Reference Table
| Phase | Key Activity | Gate Condition |

## Per-Skill Transformation Notes

### frame

**Frontmatter changes:**
- Add `name: frame`
- Description: keep "Use when a raw idea, request, or complaint surfaces and needs to be examined before any solution thinking begins." Cut everything after.

**Iron Law:** `NO SOLUTION TERRITORY IN FRAMING`

**Phases:**
1. Establish the impetus — confirm business reason exists and appetite signal given. Gate: impetus is explicit and appetite is named before moving to questions.
2. Work the 7 questions — one at a time, no moving on until a real answer exists. Gate: all 7 questions have specific, non-label answers.
3. Test for language precision — domain words, not feature labels. Gate: problem can be stated in one sentence using only words the affected people would use.

**Key if-else:**
```
IF problem is still stated as a label ("improve X", "fix notifications") → strip the label, narrow further
IF language is still vague after narrowing → find the domain expert who knows the real name for it
```

**Key red flags:**
- "It's always been a problem" — no impetus, still a candidate
- "Improve X" still in the problem statement
- Solution territory surfacing (breadboards, technical options)
- Accepting vague answers without pushing back

---

### shape

**Frontmatter changes:**
- Add `name: shape`
- Description: keep "Use when a concept document has reached Frame Go and the problem is clear enough to start defining a solution." Cut everything after.

**Iron Law:** `APPETITE DOES NOT MOVE. SCOPE ADJUSTS TO FIT IT.`

**Phases:**
1. Read the frame — absorb appetite, problem language, constraints. Gate: appetite is fixed in mind before any element naming begins.
2. Name the elements — 3–7, in domain language. Gate: each element can be described in one or two sentences; no element is a technical component.
3. Breadboard the flow — places, affordances, connections only. Gate: no visual design, exact copy, component library names, or layout in the breadboard.
4. Find rabbit holes — each risk identified. Gate: every rabbit hole has a specific patch. No open rabbit holes.
5. Define dos and won't-dos — explicit inclusions and exclusions. Gate: every reasonable assumption about scope is named explicitly as a do or won't-do.
6. Three properties check — rough, solved, bounded. Gate: all three pass before writing to the document.

**Key if-else (iterative boundary):**
```
WHEN a question surfaces during shaping:
  IF it concerns the solution (what to build, how it connects, what the flow looks like) → answer it here, stay in shaping
  IF it concerns the problem (is this the right failure, does this cost what we thought, who actually has this) → STOP, invoke frame skill, resolve the framing question, resume shaping after frame-go is confirmed
```

**Key if-else (abstraction gate):**
```
WHEN describing an element or breadboard step:
  IF you are specifying visual design, exact copy, database schemas, API specs, or component library names → STOP, elevate the abstraction
  Ask: can the builder make this decision? If yes, leave it out.
```

**Key red flags:**
- Continuing to shape over an unresolved framing question
- Rabbit hole listed without a patch
- Breadboard contains layout notes, styling, or component names
- Element count exceeds 7
- Solution language drifting from frame language

---

### bet

**Frontmatter changes:**
- Add `name: bet`
- Description: keep "Use when a concept has reached Shape Go and needs a deliberate decision before building begins." Cut everything after.

**Iron Law:** `A FUZZY SHAPE PRODUCES A BAD BET. THE BIAS IS TOWARD NO.`

**Phases:**
1. Verify shape quality — status must be shape-go, all rabbit holes patched, technical grounding visible in concept. Gate: if any of these fail, return to shaping before proceeding.
2. Work the 5 questions — the goal is to find reasons to say no, not to find permission to say yes. Gate: all 5 questions have been answered with specific evidence, not reassurances.
3. Make the binary decision — bet or no bet. Gate: the decision is binary. "Maybe" is a no bet.

**Key if-else:**
```
IF any rabbit hole has no patch → no bet, return to shaping
IF technical grounding is not visible in the concept (no evidence the relevant code was examined) → no bet, return to shaping
IF the decision is "both in parallel" → that is not a bet, that is two bets; make the choice
IF the decision is "maybe, let's see" → it is a no bet
```

**Key red flags:**
- "We'll figure out the rabbit hole during building"
- Betting on a concept because it has been waiting a long time
- "Both in parallel" or "both sequentially this cycle"
- Treating a no-bet as failure rather than as discipline

---

### kickoff

**Frontmatter changes:**
- Add `name: kickoff`
- Description: keep "Use when a concept has been bet on and building is about to begin." Cut everything after.

**Iron Law:** `SCOPES ARE VERTICAL SLICES. TACKLE HIGHEST UNCERTAINTY FIRST.`

**Phases:**
1. Read concept and flag ambiguities — absorb the full document, collect anything unclear. Gate: all ambiguities resolved with the user before proposing scopes.
2. Investigate the existing system — read relevant code before proposing scopes. Gate: can name at least the reusable components and the areas of new territory before proceeding.
3. Propose scopes — vertical slices, max 9, in domain language. Gate: each scope can answer "what will I be able to demo when this is done?"
4. Sequence by uncertainty — highest uncertainty first. Gate: the highest-uncertainty scope is assigned to be tackled first, not last.
5. Confirm against appetite — total scope vs. appetite set in framing. Gate: total scope fits the appetite, or explicit cuts have been made and confirmed.

**Key if-else:**
```
IF scope count exceeds 9 → too granular, regroup around demoable outcomes
IF ambiguities remain unresolved → do not propose scopes yet
IF total scope exceeds appetite:
  IF scopes can be cut → cut at scope level, not task level within a scope
  IF no scope can be cut → simplify one scope's boundary
  IF neither works → return concept to framing with the new understanding
```

**Key red flags:**
- Scopes organized by layer (all backend work, all frontend work)
- Starting with the easiest or most comfortable scope
- More than 9 scopes
- Writing the scopes document before user confirms the scope list

---

### scope

**Frontmatter changes:**
- Add `name: scope`
- Description: keep "Use when a scopes document exists and building is ready to begin on a specific scope." Cut everything after.

**Iron Law:** `ONE SCOPE AT A TIME. BREAK DOWN AT THE START OF THAT SCOPE, NOT ALL UPFRONT.`

**Phases:**
1. Understand what the scope delivers — read scope entry and concept document. Gate: can state the demoable outcome in one sentence before any task breakdown begins.
2. Work from the breadboard — flat list of what needs to exist for this flow. Gate: list covers all layers needed (not only backend or only UI).
3. Investigate relevant code — read code before sequencing tasks. Gate: can name existing patterns this scope reuses and the areas that are new territory.
4. Sequence by dependency and uncertainty — unknowns first, wiring before finish. Gate: task list is ordered with highest-uncertainty tasks first.
5. Write acceptance criteria — one to three observable conditions per task. Gate: each criterion describes behavior, not implementation.
6. Propose and confirm — present task list to user before writing. Gate: user has confirmed before tasks are written to the scopes document.

**Key if-else:**
```
IF task list exceeds 10 → STOP, do not continue; surface what was found and present options
IF code investigation reveals an unpatched rabbit hole:
  → STOP, state clearly: where it is, why it is more complex than expected, what the risk is
  → Get a decision before proceeding: patch with a constraint, narrow the scope, or return to shaping
IF tasks are organized by layer → regroup around behavior: what must come together to make this flow work?
```

**Key red flags:**
- Breaking down more than one scope at a time
- Tasks named by layer ("implement the backend", "build frontend components")
- Acceptance criteria describing implementation ("the query returns results") not behavior ("the panel shows the three most recent missed payments")
- Silently expanding or shrinking the scope without surfacing it

---

### ux-design

Lightest touch — already the most behavioral of the six skills. Decision lookup table and audit checklist are already present.

**Frontmatter changes:**
- Description is already strong — minor trim only if needed

**Add Iron Law:** `DESIGN FOR BEHAVIOR AND RECOVERY, NOT APPEARANCE`

**Add Red Flags table** (small, drawn from the existing principles):
| If you're thinking... | Do this |
|---|---|
| "Users will figure it out" | Apply "Look like what you do" — if it needs figuring out, redesign it |
| "We'll handle errors later" | Apply "Fail gracefully" — error states are not edge cases |
| "Generic 'Submit' is fine here" | Apply "Speak human" — every button needs verb + object |

**Add Rationalization table** (3–4 rows):
| Excuse | Reality |
|---|---|
| "That error state is unlikely" | Plan for every failure, not just common ones |
| "Users can read the label" | Users don't read — they click and discover |

## Execution Sequence

Transform in this order:

1. **frame** — foundation for everything else, cleanest structure to practice on
2. **shape** — most complex (iterative boundary, abstraction discipline, most failure modes)
3. **bet** — decision skill, needs the strongest rationalization machinery
4. **kickoff** — vertical slice concept is the key behavioral rule
5. **scope** — similar structure to kickoff, builds on it
6. **ux-design** — lightest touch, most already done

Each transformation is independent — they can be parallelized if needed.
