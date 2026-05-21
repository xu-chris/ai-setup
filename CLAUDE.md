# Shape Up for Claude Code

This project is a Claude Code plugin encoding the Shape Up product methodology as skills, agents, and commands. Read the [README](README.md) first — it is the concept paper for this project and the authoritative reference for the methodology, phases, and constraints.

## Plugin Architecture

### One skill per phase, one command per skill

Each phase has a dedicated skill in `skills/[phase]/SKILL.md` and a companion command in `commands/[phase].md`. The skill is model-invoked based on context. The command is user-invoked to explicitly enter a phase. Both should be kept small and anchored strictly to their phase.

Phases and their skill directories:
- `skills/frame/` — framing
- `skills/shape/` — shaping
- `skills/bet/` — betting
- `skills/kickoff/` — building kickoff
- `skills/scope/` — scope breakdown

### The concept document

Every piece of work lives in a single document under `docs/concepts/[name].md`. Skills do not create separate documents per phase. They write to sections of the same document. The document evolves through the phases:

- **Framing** creates the document and fills the Frame section (problem, who is affected, current workaround, cost, urgency, appetite)
- **Shaping** adds the Solution section (elements, breadboard, rabbit holes, dos, won't-dos)
- **Betting** adds the Bet section (decision, conditions, cycle)
- **Building kickoff** reads the full document and produces a separate `docs/concepts/[name].scopes.md`

The `status` field in the frontmatter tracks the lifecycle:
`candidate` → `frame-go` → `shape-go` → `bet` → `building`

Each skill should check the status before starting and write the status when done.

### Document section ownership

Each skill owns specific sections and leaves others alone:

| Section | Owner |
|---------|-------|
| Problem, Who Is Affected, What They Do Instead, What Goes Wrong, Why Now, Appetite | `frame` |
| Elements, Breadboard, Rabbit Holes, Dos, Won't-Dos | `shape` |
| Decision, Conditions, Cycle | `bet` |
| Build (link to scopes doc) | `kickoff` |

## Working in This Project

When processing material from `inbox/`:
- Strip project-specific details and generalize
- Reframe content around the four phases (candidate, framing, shaping, building) and three constraints (problem, appetite, scope)
- Route to `skills/`, `agents/`, `commands/`, or `hooks/` as appropriate

When writing skill content:
- Skills should guide thinking, not replace it. The output of a skill should be a better human decision.
- Framing skills surface problems. Shaping skills define solutions. Keep them anchored to their phase.
- Both phases require domain knowledge. Do not treat shaping as a purely technical exercise.

When writing prose for this project:
- No em-dashes
- No "not X, but Y" constructions
