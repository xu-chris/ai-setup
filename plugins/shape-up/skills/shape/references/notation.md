# Shaping notation

Table formats and rules for requirements, shapes, fit checks, and spikes. The process and gates live in SKILL.md; this file is only the notation.

## R — Requirements

Requirements define the problem space.

- Number them R0, R1, R2…
- Track status per requirement: Core goal / Must-have / Undecided / Nice-to-have / Out. Statuses are the user's call.
- R states what's needed, not how to satisfy it. Satisfaction is shown in a fit check.
- Never more than 9 top-level requirements. Group related ones as R3.1, R3.2 if needed.

```
| ID | Requirement | Status |
|----|-------------|--------|
| R0 | [statement] | Core goal |
| R1 | [statement] | Must-have |
```

Always show the full requirements table — never summarize or abbreviate. When re-rendering after changes, mark changed cells with 🟡.

## S — Shapes

Shapes are solution options. Letters A, B, C… are mutually exclusive — you pick one.

- Each shape gets a short descriptive title: `A: [title]`.
- Parts use the shape's letter plus a number: A1, A1.1… Start flat; add hierarchy only when grouping aids understanding.
- Shape parts describe mechanisms — what to BUILD or CHANGE. Not intentions, not constraints.
- Mark flagged unknowns with ⚠️ in a Flag column: mechanism described at a high level but HOW is not yet known.

```
| Part | Mechanism | Flag |
|------|-----------|:----:|
| A1   | [mechanism] | |
| A2   | [mechanism] | ⚠️ |
```

**CURRENT** is a reserved shape name for the existing system baseline. Use it in fit checks as the starting point.

Always show full shape tables — never summarize or abbreviate. When re-rendering after changes, mark changed cells with 🟡.

## Fit Check

The decision matrix comparing shapes against requirements. Requirements are rows; shapes are columns.

```
| ID | Requirement | Status | CURRENT | A | B |
|----|-------------|--------|---------|---|---|
| R0 | [statement] | Core goal | ❌ | ✅ | ✅ |
| R1 | [statement] | Must-have | ✅ | ✅ | ❌ |
```

Rules:
- Binary only: ✅ or ❌. No other values.
- A flagged unknown (⚠️) on any part makes the fit check ❌ for requirements that part addresses. You cannot claim what you don't know.
- Shape columns contain only ✅/❌ — explanations go in a Notes section below the table.
- Always show full requirement text. Never abbreviate.
- When re-rendering after changes, mark changed cells with 🟡.

If a shape passes all checks but still feels wrong, there is a missing requirement. Articulate the implicit constraint as a new R, then re-run the fit check.

## Spikes

A spike investigates a flagged unknown (⚠️) and returns concrete information about how to build the mechanism. Spikes are homework in the actual code — not reasoning from outside.

Write spikes as sub-sections in `shape.md` (not separate files):

- **Context** — why we're investigating
- **Questions** — specific questions about mechanics, not effort
- **Findings** — what was learned

Good spike questions ask about mechanics: "Where is the X logic?", "What changes are needed to achieve Y?", "How do we perform Z?" Avoid effort estimates, vague questions, and yes/no questions that don't reveal mechanics.

A spike is complete when you can describe the concrete steps needed. After a spike resolves a ⚠️, update the part's mechanism description and re-run the fit check.

## Detailing a Shape

When expanding the selected shape into affordances, use "Detail A" notation — not a new letter. Shape letters (A, B, C) are mutually exclusive alternatives; detailing is a breakdown of the selected shape, not a sibling option.

```
A, B, C   = alternatives (pick one)
Detail A  = expansion of A (not a choice)
```
