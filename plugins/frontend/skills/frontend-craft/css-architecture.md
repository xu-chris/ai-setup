# CSS Architecture

## 1. Use CSS Cascade Layers

Declare layer order upfront to control specificity without hacks. Every rule belongs to a layer.

```css
@layer reset, base, components, modules, utilities;
```

| Layer | Purpose | Examples |
|-------|---------|---------|
| `reset` | Normalize browser defaults | Box-sizing, margin reset |
| `base` | Element-level styles (no classes) | `body`, `a`, `h1`-`h6`, `input` |
| `components` | Reusable UI pieces | `.btn`, `.card`, `.input` |
| `modules` | Complex, page-specific compositions | `.card-columns`, `.card-perma` |
| `utilities` | Single-purpose overrides | `.flex`, `.gap`, `.txt-small` |

```css
/* Good — every rule lives in a layer */
@layer components {
  .btn { display: inline-flex; gap: 0.5em; }
}

@layer utilities {
  .flex { display: flex; }
}

/* Bad — unlayered rules fight specificity battles */
.btn { display: inline-flex; }
.flex { display: flex; }
```

**Rule**: No CSS outside a `@layer` block (except the layer declaration itself and custom property definitions on `:root`).


## 2. Design Tokens as Custom Properties

Define all values — colors, spacing, typography, z-index, shadows — as custom properties. Never hard-code magic numbers in component styles.

### Spacing Tokens (Logical Properties)

Use a dual-axis system with logical names for internationalization (RTL support):

```css
:root {
  --inline-space: 1ch;                                  /* horizontal */
  --inline-space-half: calc(var(--inline-space) / 2);
  --inline-space-double: calc(var(--inline-space) * 2);

  --block-space: 1rem;                                  /* vertical */
  --block-space-half: calc(var(--block-space) / 2);
  --block-space-double: calc(var(--block-space) * 2);
}
```

Use `1ch` for inline (character-width-relative) and `1rem` for block (root-relative). This creates natural rhythm — inline spacing scales with font, block spacing stays consistent.

### Typography Tokens

Define a scale with semantic names, not arbitrary sizes:

```css
:root {
  --text-xx-small: 0.65rem;
  --text-x-small: 0.75rem;
  --text-small: 0.875rem;
  --text-normal: 1rem;
  --text-medium: 1.15rem;
  --text-large: 1.35rem;
  --text-x-large: 1.85rem;
  --text-xx-large: 2.75rem;
}
```

### Color Tokens (Semantic over Primitive)

Define primitives, then map to semantic names:

```css
:root {
  /* Primitives — never use directly in components */
  --blue-500: oklch(55% 0.15 250);
  --red-500: oklch(55% 0.2 25);

  /* Semantic — use these in component styles */
  --color-ink: var(--blue-900);
  --color-canvas: var(--white);
  --color-link: var(--blue-500);
  --color-negative: var(--red-500);
  --color-positive: var(--green-500);
}
```

### Z-Index Tokens

Never hard-code z-index. Use a declared scale:

```css
:root {
  --z-popup: 10;
  --z-nav: 20;
  --z-flash: 30;
  --z-tooltip: 40;
  --z-bar: 50;
  --z-overlay: 100;
}
```

### Shadow Tokens

Define shadows once, override per theme:

```css
:root {
  --shadow: 0 1px 3px oklch(0% 0 0 / 0.1), 0 4px 12px oklch(0% 0 0 / 0.08);
}
```


## 3. BEM Naming Convention

Use **Block__Element--Modifier** for all component classes.

| Part | Separator | Example |
|------|-----------|---------|
| Block | none | `.card` |
| Element | `__` | `.card__header` |
| Modifier | `--` | `.card__header--current` |

```css
/* Good */
.card { }
.card__header { }
.card__body { }
.card__footer { }
.card--placeholder { }
.card__title--current { }

/* Bad — no clear relationship */
.card-header { }        /* Is this a block or element? */
.cardTitle { }           /* camelCase */
.card_title { }          /* single underscore */
.card .header { }        /* descendant selector couples to DOM */
```

**Guidelines**:
- Block names are lowercase, hyphen-separated for multi-word: `card-columns`, `card-perma`
- Elements belong to one block — don't nest elements (`card__header__title` is wrong, use `card__title`)
- Modifiers describe *what varies*, not implementation: `--negative`, `--left`, `--current`, `--system`
- Don't use modifiers alone — always pair with the base: `class="btn btn--link"` not `class="btn--link"`


## 4. State Classes Use `is-` Prefix

Separate state from structure. State classes toggle; component classes are permanent.

```css
/* Good — state is a separate concern */
.column.is-expanded { }
.column.is-collapsed { }
.item.is-active { }
.element.is-off-screen { }

/* Bad — state baked into modifier */
.column--expanded { }   /* Modifiers are for variants, not runtime state */
.active-item { }         /* No prefix, ambiguous */
```

**Rule**: If JavaScript toggles it, prefix with `is-`. If it's a permanent visual variant, use `--modifier`.


## 5. Component Variants via Custom Properties

Define a component's visual axes as custom properties on the base class. Modifiers override only the properties that change — not the entire rule.

```css
/* Base component defines the API */
.btn {
  background-color: var(--btn-background, var(--color-canvas));
  border: var(--btn-border-size, 1px) solid var(--btn-border-color, var(--color-ink-light));
  color: var(--btn-color, var(--color-ink));
  padding: var(--btn-padding, 0.5em 1.1em);
  gap: var(--btn-gap, 0.5em);
  display: inline-flex;
  align-items: center;
  border-radius: 99rem;
  transition: filter 100ms ease-out;
}

/* Variants override only what differs */
.btn--link {
  --btn-background: var(--color-link);
  --btn-border-color: var(--color-canvas);
  --btn-color: var(--color-ink-inverted);
}

.btn--negative {
  --btn-background: var(--color-negative);
  --btn-border-color: var(--color-negative);
  --btn-color: var(--color-ink-inverted);
}

.btn--plain {
  --btn-background: transparent;
  --btn-border-size: 0;
  --btn-padding: 0;
}
```

```css
/* Bad — duplicating the entire rule per variant */
.btn--link {
  background-color: var(--color-link);
  border: 1px solid var(--color-canvas);
  color: white;
  padding: 0.5em 1.1em;     /* repeated */
  display: inline-flex;       /* repeated */
  align-items: center;        /* repeated */
  border-radius: 99rem;       /* repeated */
}
```

**Why**: Custom properties create a component API. Variants are minimal diffs. Adding a new variant is one line per changed property.


## 6. Use `:has()` for State-Dependent Styling

Prefer `:has()` over JavaScript class toggling when the styling depends on child/sibling state:

```css
/* Good — CSS reacts to child state, no JS needed */
.btn:has(input:checked) {
  --btn-background: var(--color-ink);
  --btn-color: var(--color-ink-inverted);
}

.card-columns:has(.is-expanded) {
  grid-template-columns: auto var(--column-width-expanded) auto;
}

/* Hide a section when all its children are hidden */
.section:has([hidden]):not(:has(:not([hidden]))) {
  display: none;
}

/* Parent responds to child focus */
.input-wrapper:has(:focus-visible) {
  outline: 2px solid var(--color-link);
}
```

**When to use `:has()`**:
- Parent layout changes based on child state (expanded, checked, hidden)
- Showing/hiding containers based on whether they have visible children
- Focus/hover delegation to parent elements
- Conditional styling without JavaScript


## 7. Dark Mode via Custom Properties

Support both explicit theme choice and system preference:

```css
/* Light mode defaults are the base custom properties */
:root {
  --color-ink: oklch(20% 0 0);
  --color-canvas: oklch(100% 0 0);
  --shadow: 0 1px 3px oklch(0% 0 0 / 0.1);
}

/* Explicit user choice — highest priority */
html[data-theme="dark"] {
  --color-ink: oklch(90% 0 0);
  --color-canvas: oklch(15% 0 0);
  --shadow: none;
}

/* System preference — fallback when no explicit choice */
@media (prefers-color-scheme: dark) {
  html:not([data-theme]) {
    --color-ink: oklch(90% 0 0);
    --color-canvas: oklch(15% 0 0);
    --shadow: none;
  }
}
```

**Rule**: Theme changes swap custom properties only — component CSS never mentions light/dark. Components consume `--color-ink`, `--color-canvas`, etc. without knowing which theme is active.


## 8. File Organization

One file per component or concern. Flat directory — no subdirectories.

```
stylesheets/
  _global.css         # Custom properties, layer declaration
  reset.css           # CSS reset
  base.css            # Element-level styles
  layout.css          # Page scaffold (body grid)
  buttons.css         # .btn and variants
  cards.css           # .card component
  dialog.css          # .dialog component
  inputs.css          # Form inputs
  nav.css             # Navigation
  utilities.css       # Utility classes
  animation.css       # @keyframes
  print.css           # @media print
```

**Guidelines**:
- File name = primary block name (`buttons.css` for `.btn`)
- Global custom properties in a single file (often prefixed with `_`)
- No imports between component files — each is self-contained within its layer
- Utilities are lean — only classes actually used, not a generated framework


## 9. Pure CSS — No Preprocessors

Modern CSS has custom properties, nesting, `:has()`, `@layer`, `color-mix()`, `oklch()`, `clamp()`, and container queries. These eliminate the need for Sass/Less/PostCSS.

```css
/* Modern CSS nesting — no preprocessor needed */
.card {
  display: flex;
  flex-direction: column;

  &__header {
    display: flex;
    align-items: center;
  }

  &__body {
    flex: 1;
  }

  &:hover {
    box-shadow: var(--shadow);
  }

  @media (prefers-reduced-motion: reduce) {
    transition: none;
  }
}
```

**Rule**: If you reach for a preprocessor feature, check if native CSS supports it. It probably does.


## 10. Utility Classes — Lean and Token-Based

Utilities are single-purpose classes in the `utilities` layer. They use design tokens, not hard-coded values.

```css
@layer utilities {
  /* Typography */
  .txt-small { font-size: var(--text-small); }
  .txt-normal { font-size: var(--text-normal); }
  .txt-bold { font-weight: bold; }
  .txt-uppercase { text-transform: uppercase; }

  /* Flexbox */
  .flex { display: flex; }
  .flex-column { flex-direction: column; }
  .flex-wrap { flex-wrap: wrap; }
  .align-center { align-items: center; }
  .justify-center { justify-content: center; }

  /* Spacing (using tokens) */
  .gap { column-gap: var(--inline-space); row-gap: var(--block-space); }
  .gap-half { column-gap: var(--inline-space-half); row-gap: var(--block-space-half); }
  .pad { padding: var(--block-space) var(--inline-space); }

  /* Sizing */
  .full-width { inline-size: 100%; }
  .center { margin-inline: auto; }
  .overflow-ellipsis { text-overflow: ellipsis; white-space: nowrap; overflow: hidden; }
}
```

**Rule**: Don't generate hundreds of utility classes. Define only what you use. If a pattern repeats across 3+ components, it earns a utility class. Otherwise, keep it in the component.


## 11. Transitions & Animations

### Duration and Easing Tokens

Define transition timing as custom properties — never hard-code durations inline:

```css
:root {
  --dialog-duration: 150ms;
  --tray-duration: 350ms;
  --ease-out-expo: cubic-bezier(0.16, 1, 0.3, 1);
  --ease-out-overshoot: cubic-bezier(0.22, 1.2, 0.36, 1);
}
```

### Explicit Transition Properties

Never use `transition: all`. List exactly which properties transition:

```css
/* Good — explicit properties */
.btn {
  transition-property: background-color, border-color, box-shadow, outline;
  transition-duration: 100ms;
  transition-timing-function: ease-out;
}

/* Bad — all transitions, unexpected layout shifts */
.btn {
  transition: all 100ms ease-out;
}
```

### Dialog Entry/Exit with `@starting-style`

Use `@starting-style` for smooth dialog and popup animations without JavaScript:

```css
dialog {
  opacity: 0;
  transform: scale(0.85);
  transition-property: display, opacity, overlay, transform;
  transition-duration: var(--dialog-duration);
  transition-behavior: allow-discrete;  /* enables transition on display property */

  &[open] {
    opacity: 1;
    transform: scale(1);
  }

  @starting-style {
    &[open] {
      opacity: 0;
      transform: scale(0.85);
    }
  }
}
```

**Key**: `transition-behavior: allow-discrete` enables transitions on `display` and `overlay` (normally discrete properties). `@starting-style` defines the "from" state when the element first appears.


## 12. Icons via CSS Masks

Render icons as masked backgrounds so they inherit `currentColor` and work in any context:

```css
.icon {
  background-color: currentColor;
  display: inline-block;
  block-size: var(--icon-size, 1em);
  inline-size: var(--icon-size, 1em);
  mask-image: var(--svg);
  mask-position: center;
  mask-repeat: no-repeat;
  mask-size: var(--icon-size, 1em);
  -webkit-touch-callout: none;  /* prevent long-press menu on mobile */
}

.icon--settings { --svg: url("settings.svg"); }
.icon--trash { --svg: url("trash.svg"); }
.icon--search { --svg: url("search.svg"); }
```

**Why masks over inline SVG**:
- Icons automatically inherit text color via `currentColor`
- Sizing controlled by `--icon-size` custom property
- Dark mode works without any icon changes
- Print-safe with `print-color-adjust: exact`


## 13. Text Wrapping

Use modern text wrapping for better typography:

```css
/* Headings — balanced line lengths */
h1, h2, h3 {
  text-wrap: balance;
}

/* Body text — avoids orphaned words on last line */
p {
  text-wrap: pretty;
}

/* Utility text that must stay on one line */
.nowrap {
  text-wrap: nowrap;
}
```

**Note**: `text-wrap: balance` can conflict with `-webkit-line-clamp` in Safari. Unset it when clamping lines:

```css
.card__title--clamped {
  text-wrap: unset;
  -webkit-line-clamp: 3;
}
```


## 14. `accent-color` for Native Form Controls

Theme native checkboxes, radios, and range sliders with one property:

```css
.input {
  accent-color: var(--input-accent-color, var(--color-ink));
}
```

No need to rebuild checkbox/radio UI from scratch — `accent-color` respects the design system.


## 15. `@supports` for Progressive Enhancement

Use feature detection for modern CSS that lacks universal support:

```css
/* Auto-sizing textareas where supported */
@supports (field-sizing: content) {
  textarea {
    field-sizing: content;
    max-block-size: 50vh;
  }
}

/* color-mix where supported */
@supports (color: color-mix(in oklch, red, blue)) {
  .hover-overlay {
    background: color-mix(in srgb, var(--card-color) 90%, var(--color-ink));
  }
}
```

**Rule**: Ship the baseline experience without `@supports`. Enhance progressively inside `@supports` blocks.


## 16. Print Styles

Print is a first-class output. Key conventions:

```css
@media print {
  /* Hide interactive UI */
  nav, button, .btn, footer, dialog { display: none; }

  /* Ensure icon backgrounds print */
  .icon { print-color-adjust: exact; }

  /* Prevent card/content from splitting across pages */
  .card { break-inside: avoid; }

  /* Typography control */
  p { orphans: 3; widows: 2; }

  /* Page margins */
  @page { margin: 1cm; }
}
```


## Antipatterns

| Antipattern | Why it's wrong | Fix |
|------------|----------------|-----|
| `z-index: 9999` | Escalation arms race | Use `--z-*` tokens |
| `margin-left: 12px` | Magic number, physical direction | Use `margin-inline-start: var(--inline-space)` |
| `color: #3b82f6` | Hard-coded, no theme support | Use `var(--color-link)` |
| `.card .title` | Descendant selector couples to DOM | Use `.card__title` (BEM) |
| `.active` | Ambiguous, no prefix | Use `.is-active` |
| Sass `@extend` | Creates unexpected selector bloat | Use custom property variants |
| `!important` | Breaks cascade | Use `@layer` ordering |
| Generated utility classes | Bloat from unused classes | Write only what you use |
| `transition: all` | Transitions unintended properties | List properties explicitly |
| Inline SVG for every icon | Verbose, can't inherit color | CSS mask + `currentColor` |
| Hard-coded `transition: 0.3s` | No consistency | Use duration tokens |
