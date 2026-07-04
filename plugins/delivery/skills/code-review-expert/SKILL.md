---
name: code-review-expert
description: Expert code review of current git changes with a senior engineer lens. Use when reviewing a diff, PR, branch, or current working tree for correctness, architecture, SOLID violations, security risks, missing tests, performance issues, and removal candidates. Defaults to review-only output unless the user explicitly asks for fixes.
---

# Code Review Expert

## Overview

Perform a structured review of the current git changes with focus on SOLID, architecture, removal candidates, and security risks. Default to review-only output unless the user asks to implement changes.

Be critical. Assume changes are not correct until verified. Use subagents when available and useful for independent review passes. If subagents are not available, run the same layers inline.

Start them on multiple layers:

Backend
1. Following code style: Do all code changes follow AGENTS.md?
2. Migrations complete: Is the migration complete and haven't we forgotten any relationship, view, form field that we shall port over?
3. Relations complete: Are all relations in place we were asked and tasked for?
4. Following frameworks and newest features: Do we follow all standards of the codebase and do not follow old ones? Did we replicated old patterns / standards somewhere?
5. Tests: Can we verify that our business logic works as intended in the concepts and according to the business and domain logic? Are there any irregulatories that make conceptually not any sense or are conceptually wrong? Did we have sufficient tests in place that verify the workings of our code (check books for how to test sufficiently in the realm of Ash)?
6. Security: Are all dependencies up-to-date? Do we have any code that can execute code from a user based input or an input of a third party (like APIs)?
7. Performance: Is our implementation performant, following the newest standards and best practices of a highly performant, low memory Elixir, Ash and Phoenix app? Do we have sufficient indexes in place? Are we using anywhenre `String.to_atom` (which is really bad)?
8. Composability and Reusability / Anti codebase bloating: Do we reuse existing code or is the new code definitely and for sure valuable and necessary? Do we use our custom types or did we re-create new ones? Could existing code be slightly altered to widen its reusability so we can remove certain code?
9. Elixir / Erlang Style: Is our code assertive, except for in the case of third party content or code? Double check for all `try` error catchers if the called function is actually throwing errors. If you cannot determine it, we need `try` block, if not, use `case` or `with`.
10. Workers: Are we certain that our workers do work with the domain model?
11. Names: Are all namings correctly in place or do we have some old names still in the code- or database that are in conflict with our domain model?


Frontend
1. Following code style: Do all code changes follow AGENTS.md?
2. Performant, real-time best practices: Do we have everywhere PubSub (also using `events.ex`) and Streams in place? Is our implementation performant, following the newest standards and best practices of a highly performant, low memory Elixir, Ash and Phoenix app?
3. DOM quality: Do we have a semantic, flat and clean HTML / HEEx DOM? Check if utility classes can be directly applied instead of boxing into another `<div>`.
4. Frontend Accessibility: Is the code following WCAG 2.2 Level AA / AAA standards sufficiently?
5. Routing: Are all routes sufficiently in place and working and do we have sufficient verifications in place to verify that?
6. Reachability: Are we certain that we can show an indexed list, show page, and form for all of the different entities we just have created (do not test if certain form fields are there but if the page can load via tests without failing)?
7. Composability and Reusability / Anti codebase bloating: Do we reuse existing code or is the new code definitely and for sure valuable and necessary? Do we reuse given components and existing formatters (`translations/`) sufficiently? Do we apply localization correctly? Is any new code redundant and could be removed by reusing existing ones or altering existing ones for optimized reusability for the changes we were tasked to apply?

## Severity Levels

| Level | Name | Description | Action |
|-------|------|-------------|--------|
| **P0** | Critical | Security vulnerability, data loss risk, correctness bug | Must block merge |
| **P1** | High | Logic error, significant SOLID violation, performance regression | Should fix before merge |
| **P2** | Medium | Code smell, maintainability concern, minor SOLID violation | Fix in this PR or create follow-up |
| **P3** | Low | Style, naming, minor suggestion | Optional improvement |

## Workflow

### 1) Preflight context

- Use `git status -sb`, `git diff --stat`, and `git diff` to scope changes.
- If needed, use `rg` or `grep` to find related modules, usages, and contracts.
- Identify entry points, ownership boundaries, and critical paths (auth, payments, data writes, network).

**Edge cases:**
- **No changes**: If `git diff` is empty, inform user and ask if they want to review staged changes or a specific commit range.
- **Large diff (>500 lines)**: Summarize by file first, then review in batches by module/feature area.
- **Mixed concerns**: Group findings by logical feature, not just file order.

### 2) SOLID + architecture smells

- Load `references/solid-checklist.md` for specific prompts.
- Look for:
  - **SRP**: Overloaded modules with unrelated responsibilities.
  - **OCP**: Frequent edits to add behavior instead of extension points.
  - **LSP**: Subclasses that break expectations or require type checks.
  - **ISP**: Wide interfaces with unused methods.
  - **DIP**: High-level logic tied to low-level implementations.
- When you propose a refactor, explain *why* it improves cohesion/coupling and outline a minimal, safe split.
- If refactor is non-trivial, propose an incremental plan instead of a large rewrite.

### 3) Removal candidates + iteration plan

- Load `references/removal-plan.md` for template.
- Identify code that is unused, redundant, or feature-flagged off.
- Distinguish **safe delete now** vs **defer with plan**.
- Provide a follow-up plan with concrete steps and checkpoints (tests/metrics).

### 4) Security and reliability scan

- Load `references/security-checklist.md` for coverage.
- Check for:
  - XSS, injection (SQL/NoSQL/command), SSRF, path traversal
  - AuthZ/AuthN gaps, missing tenancy checks
  - Secret leakage or API keys in logs/env/files
  - Rate limits, unbounded loops, CPU/memory hotspots
  - Unsafe deserialization, weak crypto, insecure defaults
  - **Race conditions**: concurrent access, check-then-act, TOCTOU, missing locks
- Call out both **exploitability** and **impact**.

### 5) Code quality scan

- Load `references/code-quality-checklist.md` for coverage.
- Check for:
  - **Error handling**: swallowed exceptions, overly broad catch, missing error handling, async errors
  - **Performance**: N+1 queries, CPU-intensive ops in hot paths, missing cache, unbounded memory
  - **Boundary conditions**: null/undefined handling, empty collections, numeric boundaries, off-by-one
- Flag issues that may cause silent failures or production incidents.

### 6) Output format

Structure your review as follows:

```markdown
## Code Review Summary

**Files reviewed**: X files, Y lines changed
**Overall assessment**: [APPROVE / REQUEST_CHANGES / COMMENT]

---

## Findings

### P0 - Critical
(none or list)

### P1 - High
- **[file:line]** Brief title
  - Description of issue
  - Suggested fix

### P2 - Medium
...

### P3 - Low
...

---

## Removal/Iteration Plan
(if applicable)

## Additional Suggestions
(optional improvements, not blocking)
```

**Inline comments**: Use this format for file-specific findings:
```
::code-comment{file="path/to/file.ts" line="42" severity="P1"}
Description of the issue and suggested fix.
::
```

**Clean review**: If no issues found, explicitly state:
- What was checked
- Any areas not covered (e.g., "Did not verify database migrations")
- Residual risks or recommended follow-up tests

### 7) Next steps confirmation

After presenting findings, ask user how to proceed:

```markdown
---

## Next Steps

I found X issues (P0: _, P1: _, P2: _, P3: _).

**How would you like to proceed?**

1. **Fix all** - I'll implement all suggested fixes
2. **Fix P0/P1 only** - Address critical and high priority issues
3. **Fix specific items** - Tell me which issues to fix
4. **No changes** - Review complete, no implementation needed

Please choose an option or provide specific instructions.
```

**Important**: Do NOT implement any changes until user explicitly confirms. This is a review-first workflow.

## Resources

### references/

| File | Purpose |
|------|---------|
| `solid-checklist.md` | SOLID smell prompts and refactor heuristics |
| `security-checklist.md` | Web/app security and runtime risk checklist |
| `code-quality-checklist.md` | Error handling, performance, boundary conditions |
| `removal-plan.md` | Template for deletion candidates and follow-up plan |
