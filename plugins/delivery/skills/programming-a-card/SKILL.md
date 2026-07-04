---
name: programming-a-card
description: Use when the user wants a Basecamp card fully implemented or continued in the current session (feature, bug, refactor, or review follow-up). Steers the agent to read the card as the spec, work in isolation, implement in small verified commits, update the card, open a PR, and leave evidence. Requires a card ID; optional branch name continues existing work.
---

# Programming a Card

Senior product engineer. Take one Basecamp card from "ready" to "implemented" in the current session, inside an isolated worktree. The card is the spec and your live status board.

## Iron law

Nothing is "done" without proof — full tests green, compile clean, card updated. Can't show the evidence? It isn't done. Keep the card in progress and say why.

## Verify or ask — never assume

Act only on verified facts or stated decisions.
- Unknown **fact** (how code, a dep, or a framework behaves) → look it up: source (`get_source_location`/Grep), `project_eval`, usage-rules/`mcp__tidewave__get_docs`. Never recall it.
- Unknown **decision** (ambiguous spec, thin card, unsettled product choice) → ask the user (options + your recommendation).

Assuming is a bug.

## Project facts

- Card table ID must come from project instructions, command arguments, or the user. If missing, ask before using Basecamp card commands. Never hardcode or guess a card table.
- Prefer project-provided worktree tooling when present. If project instructions define `EnterWorktree` / `ExitWorktree`, use them. Otherwise create or enter an isolated git worktree according to project conventions before coding.
- Conventions live in `AGENTS.md` / `CLAUDE.md` at workspace and project level. Read them; they override your defaults.
- Basecamp content is HTML. Verify skill flags before running; `cards update`/`files update` have content/title gotchas (see the `basecamp` skill).

## Inputs

- Require a **card ID**. No card ID → stop and ask. Never guess one.
- Optional: a branch name to continue after review.
- Optional: card table ID. If absent, discover it from project instructions or ask.

## Workflow

YOU MUST FOLLOW THESE STEPS IN ORDER.

### Prepare

0. Enter a worktree:
   - Already inside an isolated worktree? Read the project worktree notes and continue.
   - Project has `EnterWorktree`? Call it with `name: "card-<id>"`, then read the generated worktree notes.
   - No project worktree tool? Create or enter a git worktree using project branch conventions before coding.
1. Read the card (and any linked spec/concept doc) fully before coding. Spec wins over instinct.
2. Set up your working branch — one of:
   - **Branch handed to you** (continuing after review): `git fetch origin && git checkout <branch>`. Its prior commits and review history come with it.
   - **No branch** (fresh card): derive `feature|fix|refactor/<card-id>-<short-title>` (short title slugified from the card title), then `git branch -m <name>` to rename the auto branch.
   Never add a second branch or leave work on a temporary auto-created branch. Commits must land on the working branch you set up here.
3. Spec unclear, contradictory, or the card is thin → ask the user (options + your recommendation) and note it on the card. Do not guess.
4. Read the actual code paths (`get_source_location`, Grep) and verify behavior — don't plan from assumed structure. Plan a vertical slice of tasks.
5. Write the plan to the card description; one step per task (reuse existing steps).
6. Move the card to "In progress" (look up column IDs via `basecamp cards columns --card-table <id> --json`, never hardcode).

### Implement

One task at a time; each commit is a readable step in the story (A→B, never in circles).

7. Implement one task, TDD where it fits. Keep it the smallest coherent slice; separate happy path from error path. Compile clean.
8. Run the full suite (`mix test`) and `mix compile --warnings-as-errors`. Green before committing.
9. Commit the task — one concern, conventional format, body says why. Never tangle refactor with feature. The pre-commit hook re-runs the suite, so every commit is provably green. Follow the `committing-changes` skill. Commit per task as you go; do not batch into one mega-commit at the end.
10. Complete the matching card step and comment what changed.
11. Self-review the diff before the next task: if you can't understand it at a glance, split it. Carve off redundant state, needless processes/macros, and single-caller abstractions rather than accreting them.
12. Update `README.md` if how-to-run/setup changed; log what was done and why to the card (and concept doc).

### Review & hand off

13. Confirm every card step is done and committed.
14. Run a full code review of your changes. Use skills and additional sources where applicable.
15. Fix every issue found (as further small commits), then run another review. Repeat until a review comes back clean.
16. If the slice grew past what a reviewer can hold in one sitting (rough budget: ~400 lines), stop at a coherent boundary and put the roadmap — done / deferred / next — on the card and PR description. Don't push an unreviewable PR.
17. Once the review is clean: push the branch and open a PR. Put the branch (GitHub link) and PR link on the card description.
18. Move the card to "In review".

### Wrap up

19. Report status (see Output). Then ask the user whether to leave the worktree:
    - With `ExitWorktree`: use `action: "keep"` for follow-up work, or `action: "remove"` only after confirming the branch is pushed and the user approves cleanup.
    - Without `ExitWorktree`: leave the worktree in place unless the user explicitly approves removal.
    Never remove a worktree without asking.

## Standards

- Test behavior, not implementation details. Given/When/Then shape; every value a reader needs is visible in the test — no magic numbers buried in fixtures. Push mechanical noise into named helpers (private, or `test/support`). Separate happy-path and error-path tests. Never conditionally skip a test (the "run only if X is available" trap silently runs nothing). No dynamically-generated modules, compile-time macro magic, or processes where plain data works. Real assertions, no duplication; coverage evolves with code.
- For Elixir/Phoenix/Ash projects: all data through Ash actions with `scope:` threaded. No `Repo.*`/raw `Ecto.Changeset` unless project instructions explicitly allow it.
- For Elixir projects: `@spec` in production modules where project convention expects it. Tests `async: true` when safe.
- Match the style of the code you touch. Fix adjacent smells; don't refactor untouched code.
- Consult usage-rules / `mcp__tidewave__get_docs` before using or writing helpers for any framework feature (Ash, Phoenix, Ecto, auth, forms) — verify, don't recall.

## Safe practices

- Never assume an API. Verify return types with `project_eval`. Check empirically.
- Don't change test assertions during refactoring. Don't skip failing tests.
- Never `mix clean`, `--no-verify`, or `MIX_ENV=test` prefixes.
- Unrelated issues → basecamp card, not inline fixes.
- Don't move the card to "Done"; surface status and let the user close it.
- User-facing copy: what happened + what to do. No em dashes, no exclamation marks.

## Commits

- One concern per commit, conventional format, body says why. Only commit working code.
- Commit per task as you go — not one mega-commit at the end. The history reads as the story of the build, A→B, never in circles. Never tangle refactor with feature; separate happy path from error path.
- Amend/reorder local commits to keep the story clean, but stop if it triggers a conflict. Never `git stash` to do it.
- Follow the `committing-changes` skill.

## Red flags — stop

Each thought means you're rationalizing. Stop and do the right thing.

- "I already know how this works" → never assume; check empirically, NEVER REASON ABOUT!
- "I'll run the full suite later" → run it now.
- "Too small to test" → write the test.
- "I'll guess the API" → verify with `project_eval` or ask.
- "I'll fix this unrelated thing while I'm here" → file a new basecamp card.
- "Close enough to the spec" → re-read it; log any deviation.
- "Tests are flaky, skip them" → never skip; fix the root cause.
- "Squash it all into one commit" → one concern per commit.
- "I'll commit everything at the end" → commit per task; the history is the story.
- "This commit is big but it's all related" → if you can't understand the diff at a glance, split it. Big-but-related is still unreviewable.
- "More structure will make this robust" → check for over-engineering. Redundant state, needless processes/macros, single-caller abstractions — carve off, don't add.
- "I'll skip the worktree, the repo is clean" → never; isolation is non-negotiable, enter the worktree first.
- "I'll mark the card done" → never; surface status, let the user close it.

## Completion audit

Before claiming done, every box checked. Any unchecked → not done.

- [ ] Spec followed; deviations logged on the card.
- [ ] Commits are on the working branch (`feature|fix|refactor/...`), never on a temporary auto-created branch.
- [ ] One-concern commits, one per task, telling the story A→B; only working code; no unrelated changes (adjacent smells fixed or filed as a basecamp card).
- [ ] PR reviewable in one sitting, or split with a roadmap (done / deferred / next) on the card and PR.
- [ ] Tests assert behavior, not implementation; no buried magic numbers; no conditionally-skipped tests.
- [ ] `mix test` full suite green; `mix compile --warnings-as-errors` clean.
- [ ] README updated if how-to-run/setup changed.
- [ ] Every card step done, each with a progress comment.
- [ ] Implementation summary logged to the card/concept doc.
- [ ] Code review run; all findings fixed; a final review came back clean.
- [ ] Pushed; PR opened; branch + PR links on the card.
- [ ] Card moved to "In review".

## Output

Concise summary, not a transcript:

- Card ID, title, branch.
- What you built, mapped to card steps.
- `mix test` + compile results.
- README touched? Spec logged? Yes/no.
- Anything blocked, basecamp card filed, card column, steps still open.
- Worktree status (kept, removed, or still active).

Never fabricate. Skipped step or failed test → say so with the evidence.
