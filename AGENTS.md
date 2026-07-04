# Shape Up AI Setup

Skills and commands for AI coding assistants following the Agent Skills structure.

## Repository Structure

This repo serves three development surfaces:

- **Plugins**: `plugins/{shape-up,interface-design,frontend,ai,security,elixir,tools,delivery}/` are self-contained install units.
- **Standalone skills**: `skills/` is a unified symlink view for browsing and skill installers that dereference symlinks.
- **Commands**: `commands/` is a unified symlink view for user-invoked Claude Code commands.

Real skill files live inside their owning plugin at `plugins/{plugin}/skills/{name}/`.
Top-level `skills/` contains only symlinks pointing into plugin subdirectories.

This is load-bearing. Plugin extraction only includes the selected plugin directory, so any file a plugin needs must physically exist inside that plugin.

## Plugins

- `shape-up`: project workflow setup for strategy facilitation, framing, shaping, betting, kickoff, scope breakdown, breadboarding, breadboard reflection, dependency graphs, and ripple-check hooks.
- `interface-design`: user-level setup for UX behavior, copy, error states, empty states, and usability audits.
- `frontend`: user-level setup for semantic HTML, CSS architecture, layout, accessibility, and component patterns.
- `ai`: user-level setup for crafting agent skills and install documentation.
- `security`: project or user-level setup for GitHub Actions hardening and CI security.
- `elixir`: project setup for Elixir/Phoenix/Ash/BEAM architecture, Ash code, BEAM security, cleanup, and dependency updates.
- `tools`: user-level setup for Firecrawl web search, scraping, research, and content extraction.
- `delivery`: project setup for taking Basecamp cards through implementation, verification, expert code review, PR handoff, and card updates.

## Adding A Skill

1. Decide which plugin owns the skill.
2. Create `plugins/{plugin}/skills/{skill}/SKILL.md` with YAML frontmatter.
3. Add supporting files under that skill directory.
4. Create a top-level symlink: `cd skills && ln -s ../plugins/{plugin}/skills/{skill} {skill}`.
5. Add the skill path to `plugins/{plugin}/.claude-plugin/plugin.json`.
6. Add an entry to `README.md`.
7. Run `bin/ci`.

## Moving A Skill

1. Move the real directory between plugin `skills/` folders.
2. Update the top-level symlink target.
3. Update both plugin manifests.
4. Run `bin/ci`.

## Adding A Command

Commands belong to the plugin that owns the workflow they invoke.

1. Create `plugins/{plugin}/commands/{command}.md`.
2. Create a top-level symlink: `cd commands && ln -s ../plugins/{plugin}/commands/{command}.md {command}.md`.
3. Add an entry to `README.md`.
4. Run `bin/ci`.

## CI Gate

Run:

```bash
bin/ci
```

It validates:

- Every top-level skill is a symlink into `plugins/{plugin}/skills/{name}`.
- Every plugin skill has a top-level symlink.
- Every plugin manifest references real skill directories.
- No plugin skill directory is itself a symlink.
- Every top-level command symlink resolves into a plugin command directory.
- Hook tests pass.

## Do Not

- Do not create real files directly in `skills/`.
- Do not keep plugin-required files only at the repository root.
- Do not add a skill to `skills/` without adding it to an owning plugin manifest.
- Do not add commands to root `commands/` as real files.
