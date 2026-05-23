# Shape Up for Claude Code

This project is a Claude Code plugin encoding the Shape Up product methodology as skills, agents, and commands. Read the [README](README.md) first — it is the concept paper for this project and the authoritative reference for the methodology, phases, and constraints.

## Plugin Architecture

### One skill per phase, one command per skill

Each phase has a dedicated skill in `skills/[phase]/SKILL.md` and a companion command in `commands/[phase].md`. The skill is model-invoked based on context. The command is user-invoked to explicitly enter a phase. Both should be kept small and anchored strictly to their phase.

Phase skills (one per phase):
- `skills/frame/` — framing
- `skills/shape/` — shaping
- `skills/bet/` — betting
- `skills/kickoff/` — building kickoff
- `skills/scope/` — scope breakdown

Specialist skills (invoked from within a phase, not standalone phases):
- `skills/breadboarding/` — invoked from within shaping; writes the breadboard into `shape.md`
- `skills/breadboard-reflection/` — invoked after implementation to sync the breadboard to code
- `skills/ux-design/` — invoked from within shaping for UI behavior and copy
- `skills/dag/` — invoked by kickoff (scope DAG into slices.md) and scope (task DAG into S#-plan.md)

### The concept folder

Every piece of work lives in a folder at `docs/concepts/[name]/`. Each phase writes its own file into that folder. The folder is created when the first file is written.

| File | Owner | Written when |
|------|-------|--------------|
| `frame.md` | `frame` | Frame Go |
| `shape.md` | `shape` | Shape Go |
| `slices.md` | `kickoff` | Kickoff complete |
| `S#-plan.md` | `scope` | Scope breakdown for slice # |

The bet skill appends its decision to `frame.md`. It does not create a new file.

The `status` field in `frame.md` frontmatter tracks the lifecycle:
`candidate` → `frame-go` → `shape-go` → `bet` → `building`

All shaping files carry `shaping: true` in their frontmatter so the ripple-check hook fires on edits.

### Hooks

`hooks/ripple-check.sh` fires after every Write or Edit on a file that carries `shaping: true` in its first five lines. It injects a reminder into Claude's context to keep downstream documents consistent when requirements, shapes, or breadboard diagrams change. The hook is registered in `hooks/hooks.json`.

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
