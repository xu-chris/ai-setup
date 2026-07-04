---
name: frontend-craft
description: Use when reviewing, rewriting, or generating HTML, CSS, or accessible frontend code. Guides DOM structure, CSS architecture, layout decisions, and accessibility patterns for clean, idiomatic, production-quality interfaces.
---

# Frontend Craft

## Overview

A comprehensive guide for writing clean, semantic, accessible frontend code. Covers CSS architecture, HTML structure, layout decisions, and accessibility — distilled from production codebases that prioritize readability, maintainability, and user experience.

Use this skill to **review** existing code for violations, **rewrite** messy code into clean patterns, or **generate** new frontend code that meets high standards from the start.

## When to Use

- Writing or reviewing HTML templates and CSS stylesheets
- Deciding between flex and grid, div and semantic elements, classes and IDs
- Building interactive components (dialogs, forms, menus, cards)
- Ensuring accessibility (ARIA, keyboard nav, focus management, screen readers)
- Refactoring deeply nested or div-heavy markup into flat, semantic structure
- Structuring a CSS codebase (naming, layers, custom properties, file organization)

## Sub-Files — Read Before Editing

Each file is self-contained. **You MUST read the relevant sub-file(s) before writing or editing code in that area.**

| File | Read before... | Covers |
|------|---------------|--------|
| `css-architecture.md` | Writing or editing any CSS/stylesheet | Layers, custom properties, BEM naming, file org, component variants, state classes, dark mode, `:has()` patterns |
| `html-structure.md` | Writing or editing any HTML template | Semantic elements, DOM flatness, div discipline, IDs vs classes, button vs link, native elements over ARIA, data attributes |
| `layout-and-spacing.md` | Making any layout decision or adding spacing | Flexbox vs grid decision guide, spacing tokens, logical properties, `clamp()`, container queries, responsive patterns, gap vs margins |
| `accessibility.md` | Adding any interactive element, icon, form, or keyboard behavior | ARIA, keyboard nav, focus management, screen reader text, `:focus-visible`, reduced motion, form accessibility |
| `component-patterns.md` | Building cards, dialogs, forms, lists, toolbars, or trays | Named patterns: Card, Dialog, Disclosure, Form, Navigable List, Icon Button, Toolbar, Tray |
| `review-checklist.md` | Reviewing or completing any frontend PR | Quick-scan checklist for all concerns — also included below |

## Core Principles

1. **Semantic first** — reach for the right HTML element before adding ARIA or classes
2. **Flat over nested** — extract components instead of nesting deeper
3. **Tokens over magic numbers** — spacing, color, typography via custom properties
4. **Variants via custom properties** — not class explosion
5. **Native over custom** — `<dialog>` over JS modals, `<details>` over accordion JS
6. **Behavior in data attributes, styling in classes** — clean separation
7. **Accessibility is structure** — not an afterthought bolted on with ARIA
8. **Structure before style** — build the DOM skeleton first, add visual hierarchy step by step

## Development Order — Structure Before Style

**Never style and structure at the same time.** Build frontend in deliberate layers, getting user confirmation between steps. Each step must be correct before moving to the next.

### The Steps

```
1. DOM Structure    →  Correct semantic elements, flat nesting, proper hierarchy
2. Layout           →  Flex/grid, positioning, spacing, alignment
3. Font weight      →  Bold vs normal — establish what's important vs secondary
4. Font color       →  Ink vs subtle vs muted — reinforce the visual hierarchy
5. Font size        →  Scale — confirm heading/body/caption proportions
6. Decoration       →  Borders, shadows, backgrounds, border-radius, icons
7. Interaction      →  Hover, focus, transitions, animations
```

**Why this order matters**:
- Steps 1-2 establish the **skeleton** — if the DOM or layout is wrong, everything built on top is wasted work
- Steps 3-5 establish **visual hierarchy** — the user must confirm what's important (bold), what's secondary (lighter color), and what the proportions are (size scale) before decoration
- Steps 6-7 are **polish** — decoration and interaction are meaningless on a broken structure

**Ask the user** after steps 1-2 and after steps 3-5. Don't assume what's important — the user defines hierarchy.

### CSS Property Ordering Within Rules

Within a single CSS rule, follow the same progression:

```css
.card {
  /* 1. Layout structure */
  display: flex;
  flex-direction: column;
  position: relative;
  z-index: 1;

  /* 2. Sizing and spacing */
  inline-size: 100%;
  padding: var(--block-space) var(--inline-space);
  gap: var(--block-space-half);

  /* 3. Typography */
  font-weight: normal;
  color: var(--color-ink);
  font-size: var(--text-normal);
  text-align: start;

  /* 4. Visual decoration */
  background-color: var(--color-canvas);
  border-radius: 0.5rem;
  box-shadow: var(--shadow);

  /* 5. Interaction */
  transition: box-shadow 100ms ease-out;
}
```

---

## Review Checklist

Quick-scan checklist for reviewing frontend code.

### HTML Structure

- [ ] Semantic elements used where appropriate (`<main>`, `<header>`, `<footer>`, `<nav>`, `<article>`, `<section>`, `<dialog>`, `<details>`)
- [ ] `<div>` only used for layout wrappers, not for semantic content
- [ ] DOM nesting is 6 levels or fewer from `<body>`
- [ ] Buttons for actions, links for navigation — never swapped
- [ ] No `<a href="#">` or `<div onclick>` for interactive elements
- [ ] Native HTML elements preferred over ARIA recreations (`<dialog>` not `<div role="dialog">`)
- [ ] IDs are unique, used for landmarks and JS targeting — never for styling
- [ ] Data attributes for JS behavior, classes for CSS styling — clean separation

### CSS Architecture

- [ ] All rules inside `@layer` blocks — nothing unlayered
- [ ] No magic numbers — all values reference custom properties (spacing, color, z-index, shadow)
- [ ] BEM naming: `.block__element--modifier` — no camelCase, no single underscores
- [ ] State classes use `is-` prefix (`.is-expanded`, `.is-active`)
- [ ] Component variants via custom property overrides — not duplicated rules
- [ ] No `!important` — use `@layer` ordering for specificity
- [ ] No `z-index` without token (`--z-popup`, `--z-nav`, etc.)
- [ ] No hard-coded colors — all via semantic custom properties
- [ ] Dark mode is a custom property swap — no component-level theme checks
- [ ] Transitions list explicit properties — never `transition: all`
- [ ] Transition durations and easing via custom property tokens
- [ ] Icons via CSS masks (`currentColor` + `mask-image`) — not inline SVG per instance
- [ ] `text-wrap: balance` on headings, `text-wrap: pretty` on paragraphs
- [ ] `accent-color` on form inputs for themed native controls

### Layout & Spacing

- [ ] Flex for 1D (rows or columns), Grid for 2D (page scaffolds, multi-zone headers)
- [ ] `gap` on parents — not margins on children for inter-sibling spacing
- [ ] Logical properties used (`inline-size`, `block-start`) — not physical (`width`, `top`)
- [ ] Spacing uses tokens (`--inline-space`, `--block-space`) — not `px` literals
- [ ] Fluid sizing via `clamp()` — not breakpoint utility classes
- [ ] `100dvh` not `100vh` for mobile viewport
- [ ] Grid `place-content: center` for centering single items
- [ ] Three-zone toolbars use grid with equal outer columns — not flex with spacers
- [ ] All `:hover` rules wrapped in `@media (any-hover: hover)` — touch-safe
- [ ] Tap targets are at least 44px (use `::before` pseudo-element when visual size is smaller)
- [ ] `overscroll-behavior: contain` on scrollable modals/trays/panels
- [ ] View transition names set on elements that persist across page navigations

### Accessibility

- [ ] Skip navigation link to `#main` as first focusable element
- [ ] Icon-only buttons have visually hidden text or `aria-label`
- [ ] All icons are `aria-hidden="true"`
- [ ] Decorative images have `alt=""`
- [ ] `:focus-visible` styling on all interactive elements — never `outline: none` without replacement
- [ ] `prefers-reduced-motion: reduce` respected globally
- [ ] Every `<input>` has an associated `<label>` (via `for`/`id` or nesting)
- [ ] Custom widgets have appropriate ARIA roles (`listbox`, `option`, `radiogroup`, `checkbox`)
- [ ] Keyboard navigation works: arrow keys for lists, Escape for dismissal, Enter for activation
- [ ] Collapsible controls use `aria-expanded` or native `<details>`

### Component Quality

- [ ] Cards use `<article>` with `<header>`/`<footer>` — not all divs
- [ ] Dialogs use native `<dialog>` element — not `<div class="modal">`
- [ ] Disclosures use native `<details>`/`<summary>` where possible
- [ ] Forms have consistent field group structure (vertical stack with gap)
- [ ] Forms use native validation (`required`, `pattern`, `type`) before JS validation
- [ ] Buttons inside forms have explicit `type` (`submit` or `button`)
- [ ] View transition names on elements that persist across page navigations

### CSS File Health

- [ ] One file per component/concern — flat directory, no nesting
- [ ] File names match primary block name (`buttons.css` → `.btn`)
- [ ] No preprocessor (Sass/Less) — pure modern CSS
- [ ] Custom properties defined centrally in one globals file
- [ ] Utility classes are lean — only what's actually used, not generated
- [ ] No descendant selectors coupling to DOM structure (`.parent .child`)
- [ ] `:has()` used for state-dependent styling instead of JS class toggling

### Quick Red Flags

| Red Flag | Fix |
|----------|-----|
| `<div class="header">` | Use `<header>` |
| `z-index: 999` | Use `--z-*` token |
| `margin-bottom: 16px` on list items | Use `gap` on parent |
| `color: #3b82f6` | Use `var(--color-link)` |
| `outline: none` on `:focus` | Use `:focus-visible` with ring |
| Icon button with no text | Add `.visually-hidden` span |
| `<a href="#" onclick="...">` | Use `<button>` |
| `width: 100%` | Use `inline-size: 100%` |
| `height: 100vh` | Use `min-block-size: 100dvh` |
| `.card .header` selector | Use `.card__header` (BEM) |
| `!important` | Rethink cascade / use `@layer` |
| Empty `alt` on meaningful image | Write descriptive alt text |
| `tabindex="3"` | Use `0` or `-1` only |
| `transition: all 0.3s` | List explicit properties + use duration token |
| `.card:hover` without hover media query | Wrap in `@media (any-hover: hover)` |
| Small icon button with no tap expansion | Add `::before` for 44px target |
| Scrollable modal without overscroll containment | Add `overscroll-behavior: contain` |
