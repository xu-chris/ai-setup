# Layout & Spacing

## 1. Flexbox vs Grid — Decision Guide

This is the most common layout decision. The rule is simple:

```
One direction (row OR column)?  →  Flexbox
Two directions (rows AND columns)?  →  Grid
Centering a single element?  →  Grid (place-content: center)
```

### Use Flexbox For

- **Inline content flow**: Button groups, navigation items, tag lists
- **Stacking**: Vertical card content, form field groups, menus
- **Wrapping content**: Items that overflow naturally to next line
- **Variable-width children**: Items that size to their content

```css
/* Button group — single row, items size to content */
.btn__group {
  display: flex;
  flex-wrap: wrap;
  gap: var(--inline-space-half);
}

/* Card content — single column stack */
.card {
  display: flex;
  flex-direction: column;
}

/* Menu items — vertical list */
.popup__list {
  display: flex;
  flex-direction: column;
}

/* Toolbar — horizontal with alignment */
.toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--inline-space);
}
```

### Use Grid For

- **Page scaffold**: Full page layout with header, main, footer
- **Multi-zone alignment**: Headers/footers with left/center/right zones
- **Even columns**: Card columns, image grids, emoji pickers
- **Named areas**: Complex layouts where elements fill designated regions
- **Centering**: `place-content: center` is the simplest way to center

```css
/* Page scaffold — rows of header/main/footer */
body {
  display: grid;
  grid-template-rows: auto 1fr auto;
  min-block-size: 100dvh;
}

/* Three-zone header — left actions, centered title, right actions */
.header {
  display: grid;
  grid-template-columns: var(--actions-width) 1fr var(--actions-width);
  grid-template-areas: "start title end";
  align-items: center;
}

.header__actions--start { grid-area: start; }
.header__title { grid-area: title; text-align: center; }
.header__actions--end { grid-area: end; justify-self: end; }

/* Card columns — equal-width responsive columns */
.card-columns {
  display: grid;
  grid-template-columns: 1fr auto 1fr;
  gap: var(--column-gap);
}

/* Icon centering */
.icon-container {
  display: grid;
  place-content: center;
}

/* Emoji grid — fixed column count */
.emoji-grid {
  display: grid;
  grid-template-columns: repeat(10, 1fr);
}
```

### Decision Flowchart

```
Is it a page-level scaffold with header/main/footer?
  YES → Grid with grid-template-rows

Does it need left/center/right alignment zones?
  YES → Grid with grid-template-columns and named areas

Are all children the same width in a fixed grid?
  YES → Grid with repeat()

Is it a single row or column of variable-width items?
  YES → Flexbox

Do items need to wrap onto new lines naturally?
  YES → Flexbox with flex-wrap

Are you centering one thing?
  YES → Grid with place-content: center

Still unsure?
  → Start with flexbox. Refactor to grid if you need 2D control.
```


## 2. Spacing System

Use design tokens for all spacing. Never hard-code pixel values.

### The Dual-Axis Token System

```css
:root {
  --inline-space: 1ch;       /* Horizontal — scales with font */
  --block-space: 1rem;       /* Vertical — consistent rhythm */
}
```

**Why two axes?**
- `1ch` (inline) = width of the "0" character. Horizontal spacing that scales with font size.
- `1rem` (block) = root font size. Vertical rhythm stays consistent regardless of font changes.

### Utility Classes for Spacing

```css
/* Padding */
.pad { padding: var(--block-space) var(--inline-space); }
.pad-block { padding-block: var(--block-space); }
.pad-inline { padding-inline: var(--inline-space); }

/* Margins */
.margin-block { margin-block: var(--block-space); }
.center { margin-inline: auto; }

/* Gap (on flex/grid parents) */
.gap { column-gap: var(--inline-space); row-gap: var(--block-space); }
.gap-half { column-gap: var(--inline-space-half); row-gap: var(--block-space-half); }
```

### Use Logical Properties

Always use logical (`block`/`inline`) instead of physical (`top`/`left`) directions:

```css
/* Good — works in any writing direction */
padding-block: var(--block-space);
padding-inline: var(--inline-space);
margin-block-end: var(--block-space-half);
margin-inline-start: var(--inline-space);
inline-size: 100%;
block-size: auto;

/* Bad — assumes left-to-right, top-to-bottom */
padding-top: 1rem;
padding-left: 1ch;
margin-bottom: 0.5rem;
width: 100%;
height: auto;
```


## 3. Gap over Margins

Use `gap` on the parent instead of margins on children. This eliminates first/last-child hacks.

```css
/* Good — gap on parent, children don't know about spacing */
.form-fields {
  display: flex;
  flex-direction: column;
  gap: var(--block-space-half);
}

/* Bad — margins on children with overrides */
.form-field {
  margin-block-end: 0.5rem;
}
.form-field:last-child {
  margin-block-end: 0;    /* Hack to remove last margin */
}
```

**Rule**: If children are in a flex or grid container, spacing is the parent's job via `gap`. Children should not have margins for inter-sibling spacing.


## 4. Fluid Sizing with `clamp()`

Use `clamp()` for values that should scale with viewport but stay within bounds:

```css
/* Good — fluid padding that works across all viewports */
.main {
  padding-inline: clamp(1rem, 3vw, 3rem);
  max-inline-size: 1400px;
}

/* Good — fluid typography */
h1 {
  font-size: clamp(1.5rem, 4vw, 2.75rem);
}

/* Good — fluid sidebar */
.sidebar {
  inline-size: clamp(12rem, 25dvw, 24rem);
}

/* Bad — breakpoint-based classes */
.padding-sm { padding: 1rem; }
.padding-md { padding: 2rem; }
.padding-lg { padding: 3rem; }
/* And then: class="padding-sm md:padding-md lg:padding-lg" */
```

**clamp(minimum, preferred, maximum)**: The value is `preferred`, but never below `minimum` or above `maximum`. This replaces most media query breakpoints for sizing.


## 5. Container Queries for Component Responsiveness

Use `container-type: inline-size` on parent elements, then `cqi` units (container query inline) for children that should scale relative to their container — not the viewport.

```css
/* The container context */
.card-columns {
  container-type: inline-size;
}

/* Children scale to container, not viewport */
.card-columns .card {
  font-size: clamp(var(--text-x-small), 2cqi, var(--text-normal));
}
```

**When to use container queries vs media queries**:
- **Container queries** (`cqi`, `@container`): Component adapts to its own container size. Use for reusable components that appear in different contexts.
- **Media queries** (`vw`, `@media`): Page layout adapts to viewport. Use for page-level structure changes.


## 6. Responsive Patterns

### Mobile-First with `@media` for Larger Screens

```css
/* Default = mobile layout */
.card-columns {
  display: flex;
  flex-direction: column;
}

/* Expand to grid at wider viewports */
@media (min-width: 640px) {
  .card-columns {
    display: grid;
    grid-template-columns: 1fr auto 1fr;
  }
}
```

### Touch-Safe Hover Effects

**All hover effects must be wrapped in `@media (any-hover: hover)`**. Without this, hover styles activate on first tap on touch devices and stay stuck.

```css
/* Good — hover only fires on devices with a pointer */
@media (any-hover: hover) {
  .card:hover {
    box-shadow: var(--shadow);
  }

  .btn:hover {
    filter: brightness(var(--btn-hover-brightness, 0.9));
  }
}

/* Bad — hover fires on tap, stays stuck on mobile */
.card:hover {
  box-shadow: var(--shadow);
}
```

**Rule**: Every `:hover` rule should be inside `@media (any-hover: hover)` unless you intentionally want it on touch.

### Reduced Motion

```css
/* Respect user preference */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    transition-duration: 0.01ms !important;
    animation-duration: 0.01ms !important;
  }
}
```

### Scroll Snap for Touch Navigation

```css
/* Horizontal scroll with snap points */
.columns-scroll {
  overflow-x: auto;
  scroll-snap-type: inline mandatory;
  overscroll-behavior-inline: contain;
}

.column {
  scroll-snap-align: center;
}
```


## 7. Safe Area Insets

For mobile devices with notches or system bars:

```css
:root {
  --safe-inset-top: env(safe-area-inset-top, 0px);
  --safe-inset-bottom: env(safe-area-inset-bottom, 0px);
}

.header {
  padding-block-start: var(--safe-inset-top);
}

.footer {
  padding-block-end: var(--safe-inset-bottom);
}
```


## 8. Dynamic Viewport Units

Use `dvh`/`dvw` (dynamic viewport) instead of `vh`/`vw` for mobile compatibility:

```css
/* Good — accounts for mobile browser chrome */
body {
  min-block-size: 100dvh;
}

/* Bad — 100vh includes hidden address bar on mobile */
body {
  min-height: 100vh;
}
```


## 9. Tap Target Sizing

Interactive elements must be at least 44px on touch devices. Use a pseudo-element to enlarge the tap area without changing visual size:

```css
.btn--small {
  /* Visual size can be compact */
  padding: 0.25em 0.5em;
  font-size: var(--text-x-small);

  /* But tap target is always 44px */
  position: relative;
  &::before {
    content: "";
    position: absolute;
    inset: 50% auto auto 50%;
    transform: translate(-50%, -50%);
    block-size: max(100%, 44px);
    inline-size: max(100%, 44px);
  }
}
```

**Rule**: All buttons, links, and interactive elements need a minimum 44x44px touch target. Use `::before` when the visual size is smaller.


## 10. Overscroll Behavior

Prevent scroll chaining from modals and sidepanels to the page behind:

```css
/* Good — modal scrolling stays contained */
dialog {
  overscroll-behavior: contain;
}

.tray__content {
  overflow-y: auto;
  overscroll-behavior: contain;
}

/* Bad — scrolling past the end of a modal scrolls the page */
dialog {
  overflow-y: auto;
  /* no overscroll-behavior → scroll leaks to body */
}
```


## 11. View Transitions

For smooth page-to-page animations, name elements that persist across navigations:

```css
/* Elements with matching view-transition-name animate between pages */
.tray--pins {
  view-transition-name: tray-pins;
}

.card {
  view-transition-name: var(--card-transition-name);  /* set via inline style */
}

/* Control transition layering */
::view-transition-group(tray-pins) {
  z-index: 100;
}
```

**Rules**:
- `view-transition-name` must be unique per page — no two elements can share a name
- Set via inline `style` attribute when the name is dynamic (e.g., per-record ID)
- Use `::view-transition-group()` to control z-index during the transition


## Antipatterns

| Antipattern | Fix |
|-------------|-----|
| `margin-bottom: 16px` on every child | `gap: 1rem` on parent |
| `width: 100%; max-width: 1200px; margin: 0 auto;` | `inline-size: 100%; max-inline-size: 1200px; margin-inline: auto;` |
| Breakpoint utility classes (`sm:flex md:grid`) | `clamp()` and container queries |
| `padding: 10px 20px 15px 20px` | Tokens: `padding: var(--block-space) var(--inline-space)` |
| `height: 100vh` on mobile | `min-block-size: 100dvh` |
| Grid for a single row of buttons | Flexbox |
| Flexbox for a page scaffold | Grid with grid-template-rows |
| `float: left` for layout | Flexbox or grid |
| Negative margins for alignment | Grid with named areas |
| `.card:hover` without `@media (any-hover: hover)` | Wrap in hover media query |
| Small button with no tap target expansion | Use `::before` for 44px minimum |
| Scrollable modal without `overscroll-behavior` | Add `overscroll-behavior: contain` |
