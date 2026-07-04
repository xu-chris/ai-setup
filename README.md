# My AI Setup

AI setup for product work, split into installable plugins plus a flat browsing layer.

This repository follows the same structural idea as Basecamp's `house-skills`: real skill files live inside their owning plugin, while top-level `skills/` contains symlinks for a unified view.

## Install

Install from the marketplace, then choose the plugin you need:

```bash
/plugin marketplace add xu-chris/ai-setup
/plugin install shape-up@ai-setup
/plugin install interface-design@ai-setup
/plugin install frontend@ai-setup
/plugin install ai@ai-setup
/plugin install security@ai-setup
/plugin install elixir@ai-setup
/plugin install tools@ai-setup
/plugin install delivery@ai-setup
```

Other agents can install the standalone skills view:

```bash
npx skills add xu-chris/ai-setup
```

Use `shape-up` for dedicated project setup. Use `elixir` for Elixir/Phoenix/Ash/BEAM projects. Use `delivery` when Basecamp cards are the work queue. Use `interface-design`, `frontend`, `ai`, `security`, and `tools` as user-level setups when you want those capabilities available across projects.

## Plugins

| Plugin | Use | Contents |
| --- | --- | --- |
| `shape-up` | Dedicated project workflow | Strategy facilitation, frame, shape, bet, kickoff, scope, breadboarding, breadboard reflection, DAG |
| `interface-design` | User-level design setup | UX design and usability audit skill |
| `frontend` | User-level frontend setup | Semantic HTML, CSS architecture, layout, accessibility, component patterns |
| `ai` | AI setup authoring | Skill crafting and install documentation |
| `security` | CI security setup | GitHub Actions hardening |
| `elixir` | Elixir/Phoenix/Ash/BEAM setup | Architecture, Ash code, BEAM security, cleanup, dependency updates |
| `tools` | Tool operation setup | Firecrawl web search, scraping, research, content extraction |
| `delivery` | Card delivery setup | Basecamp card implementation, expert code review, worktree isolation, verified commits, PR handoff |

## Skills

| Skill | Plugin | Description |
| --- | --- | --- |
| [frame](skills/frame) | shape-up | Turn a raw idea, request, or complaint into a clear problem frame |
| [shape](skills/shape) | shape-up | Define a solution at Shape Up abstraction: rough, solved, bounded |
| [bet](skills/bet) | shape-up | Decide whether shaped work deserves protected build time |
| [kickoff](skills/kickoff) | shape-up | Move a bet into build by mapping vertical scopes |
| [scope](skills/scope) | shape-up | Break one scope into concrete tasks at the start of that scope |
| [breadboarding](skills/breadboarding) | shape-up | Prototype the wiring: places, affordances, stores, flows |
| [breadboard-reflection](skills/breadboard-reflection) | shape-up | Sync breadboards to implementation and inspect design smells |
| [dag](skills/dag) | shape-up | Render scope or task dependency graphs |
| [facilitating-strategy](skills/facilitating-strategy) | shape-up | Develop, sharpen, and pressure-test real strategy before shaping work |
| [ux-design](skills/ux-design) | interface-design | Design UI behavior, copy, errors, empty states, and audits |
| [frontend-craft](skills/frontend-craft) | frontend | Write and review semantic, accessible HTML and maintainable CSS |
| [skill-crafting](skills/skill-crafting) | ai | Create, edit, and refine agent skills through co-development and eval loops |
| [install-md](skills/install-md) | ai | Create installation docs optimized for autonomous agent execution |
| [harden-github-actions](skills/harden-github-actions) | security | Resolve zizmor warnings and harden GitHub Actions workflows |
| [elixir-architect](skills/elixir-architect) | elixir | Design Elixir/Phoenix/Ash architecture and handoff documentation |
| [writing-ash-code](skills/writing-ash-code) | elixir | Write production-grade Ash resources, actions, policies, forms, and jobs |
| [beam-security-hardening](skills/beam-security-hardening) | elixir | Harden BEAM/Phoenix code, deployments, LiveView, and Zero Trust decisions |
| [codebase-cleanup](skills/codebase-cleanup) | elixir | Run focused BEAM cleanup and remediation passes |
| [updating-dependencies](skills/updating-dependencies) | elixir | Update Elixir/Phoenix dependencies safely |
| [firecrawl](skills/firecrawl) | tools | Use Firecrawl CLI for web search, scraping, research, and extraction |
| [programming-a-card](skills/programming-a-card) | delivery | Take a Basecamp card from ready to implemented with evidence, review, PR, and card updates |
| [code-review-expert](skills/code-review-expert) | delivery | Review diffs with senior-engineer rigor for bugs, architecture, security, tests, and removal candidates |

## Commands

Top-level `commands/` mirrors plugin commands with symlinks for browsing.

| Command | Plugin | What it does |
| --- | --- | --- |
| `/shape-up:frame` | shape-up | Examine a candidate idea and produce a problem statement |
| `/shape-up:shape` | shape-up | Define solution elements, breadboard, rabbit holes, dos, and won't-dos |
| `/shape-up:bet` | shape-up | Decide whether to commit build time |
| `/shape-up:kickoff` | shape-up | Tour the concept and map vertical scopes |
| `/shape-up:scope` | shape-up | Break one scope into concrete tasks |
| `/shape-up:dag` | shape-up | Generate a dependency graph for scopes or tasks |

## Structure

```text
plugins/
  shape-up/
    .claude-plugin/plugin.json
    commands/
    hooks/
    skills/
  interface-design/
    .claude-plugin/plugin.json
    skills/
  frontend/
    .claude-plugin/plugin.json
    skills/
  ai/
    .claude-plugin/plugin.json
    skills/
  security/
    .claude-plugin/plugin.json
    skills/
  elixir/
    .claude-plugin/plugin.json
    skills/
  tools/
    .claude-plugin/plugin.json
    skills/
  delivery/
    .claude-plugin/plugin.json
    skills/
skills/      # symlinks to plugins/{plugin}/skills/{skill}
commands/    # symlinks to plugins/shape-up/commands/{command}.md
scripts/
bin/
tests/
```

Real files belong inside `plugins/{plugin}/`. The top-level `skills/` directory must contain only symlinks. This keeps plugin extraction self-contained and still gives agents and humans one flat skill index.

Run validation before publishing:

```bash
bin/ci
```

## Hooks

`shape-up` includes a ripple-check hook. It fires when a Markdown file carries `shaping: true` in the first five lines of frontmatter and reminds the agent to keep downstream shaping documents consistent:

- Breadboard diagram changed: update affordance tables first, then re-render Mermaid.
- Requirements in `shape.md` changed: update the Fit Check and `slices.md` when needed.
- Shape parts changed: update the Fit Check.
- `slices.md` changed: update affected `S#-plan.md` files.
- `S#-plan.md` changed: update the slice summary in `slices.md` if scope changed.

## Sources

- [Shape Up](https://basecamp.com/shapeup)
- [rjs/shaping-skills](https://github.com/rjs/shaping-skills)
- [obra/superpowers](https://github.com/obra/superpowers)
- [basecamp/house-skills](https://github.com/basecamp/house-skills)

[MIT License](LICENSE)
