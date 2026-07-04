# Review Checklist

Quick-scan checklist for reviewing frontend code. Each item links to the relevant rule in the sub-files.

## HTML Structure

- [ ] Semantic elements used where appropriate (`<main>`, `<header>`, `<footer>`, `<nav>`, `<article>`, `<section>`, `<dialog>`, `<details>`)
- [ ] `<div>` only used for layout wrappers, not for semantic content
- [ ] DOM nesting is 6 levels or fewer from `<body>`
- [ ] Buttons for actions, links for navigation — never swapped
- [ ] No `<a href="#">` or `<div onclick>` for interactive elements
- [ ] Native HTML elements preferred over ARIA recreations (`<dialog>` not `<div role="dialog">`)
- [ ] IDs are unique, used for landmarks and JS targeting — never for styling
- [ ] Data attributes for JS behavior, classes for CSS styling — clean separation

## CSS Architecture

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
- [ ] `@supports` for progressive enhancement of newer CSS features

## Layout & Spacing

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

## Accessibility

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

## Component Quality

- [ ] Cards use `<article>` with `<header>`/`<footer>` — not all divs
- [ ] Dialogs use native `<dialog>` element — not `<div class="modal">`
- [ ] Dialog entry/exit uses `@starting-style` + `transition-behavior: allow-discrete`
- [ ] Disclosures use native `<details>`/`<summary>` where possible
- [ ] Forms have consistent field group structure (vertical stack with gap)
- [ ] Forms use native validation (`required`, `pattern`, `type`) before JS validation
- [ ] Buttons inside forms have explicit `type` (`submit` or `button`)
- [ ] View transition names on elements that persist across page navigations
- [ ] Badge/count elements hidden when zero
- [ ] Print stylesheet hides interactive UI and uses `break-inside: avoid` on cards

## CSS File Health

- [ ] One file per component/concern — flat directory, no nesting
- [ ] File names match primary block name (`buttons.css` → `.btn`)
- [ ] No preprocessor (Sass/Less) — pure modern CSS
- [ ] Custom properties defined centrally in one globals file
- [ ] Utility classes are lean — only what's actually used, not generated
- [ ] No descendant selectors coupling to DOM structure (`.parent .child`)
- [ ] `:has()` used for state-dependent styling instead of JS class toggling

## Quick Red Flags

These are almost always wrong:

| Red Flag | What to do |
|----------|-----------|
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
| Inline SVG icons | Use CSS mask + `currentColor` |
