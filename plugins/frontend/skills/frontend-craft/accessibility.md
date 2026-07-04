# Accessibility

## 1. Skip Navigation

The first focusable element on every page must be a skip link to `#main`:

```html
<body>
  <header>
    <a href="#main" class="skip-navigation btn">Skip to main content</a>
    <!-- header content -->
  </header>
  <main id="main">
    <!-- page content -->
  </main>
</body>
```

```css
.skip-navigation {
  position: absolute;
  inset-block-start: -100%;
}

.skip-navigation:focus-visible {
  inset-block-start: 0;
}
```

**Rule**: Every page has a `<main id="main">` and a skip link targeting it. The link is visually hidden until focused.


## 2. Visually Hidden Text

Use a utility class to hide text visually while keeping it in the accessibility tree:

```css
.visually-hidden,
.for-screen-reader {
  block-size: 1px;
  clip-path: inset(50%);
  inline-size: 1px;
  overflow: hidden;
  position: absolute;
  white-space: nowrap;
}
```

**When to use**:
- Icon-only buttons that need labels
- Context that's visually obvious but not to screen readers
- Form field hints that complement visual design

```html
<!-- Icon button — icon is visual, text is for screen readers -->
<button class="btn btn--circle">
  <svg class="icon" aria-hidden="true">...</svg>
  <span class="visually-hidden">Close menu</span>
</button>

<!-- Card number — "#" is visual context, label is for SR -->
<span class="card__id">
  <span class="visually-hidden">Card number</span>
  42
</span>

<!-- Contextual action — screen reader needs more context -->
<button class="btn">
  <svg class="icon" aria-hidden="true">...</svg>
  <span class="visually-hidden">Unpin this card (Shift+P)</span>
</button>
```


## 3. Icon-Only Buttons Must Have Labels

Every button or link with only an icon needs accessible text. Two approaches:

### Approach A: Visually Hidden `<span>` (Preferred)

```html
<button class="btn btn--circle">
  <svg class="icon" aria-hidden="true">...</svg>
  <span class="visually-hidden">Settings</span>
</button>
```

### Approach B: `aria-label` (When no child text possible)

```html
<button class="btn btn--circle" aria-label="Settings">
  <svg class="icon" aria-hidden="true">...</svg>
</button>
```

**Prefer Approach A** because:
- Visually hidden text is translatable
- It's visible in the DOM for testing/debugging
- `aria-label` overrides all child text, which can cause surprises

**Rule**: Icons are always `aria-hidden="true"`. Decorative images get `alt=""`. The label comes from text, not from the icon.


## 4. Focus Visible Styling

Use `:focus-visible` (not `:focus`) for keyboard-only focus indicators:

```css
:is(a, button, input, textarea, select, [tabindex]) {
  &:focus-visible {
    outline: var(--focus-ring-size, 2px) solid var(--focus-ring-color, var(--color-link));
    outline-offset: var(--focus-ring-offset, 2px);
    border-radius: 0.25ch;
  }
}
```

**Rules**:
- `:focus-visible` shows the ring only for keyboard navigation, not mouse clicks
- Use custom properties so focus ring color can match the component (e.g., negative buttons use `--color-negative`)
- Never `outline: none` without a replacement — focus indicators are required
- Focus ring must have sufficient contrast against the background (3:1 minimum)

```css
/* Component-specific focus ring color */
.btn--negative {
  --focus-ring-color: var(--color-negative);
}

.btn--link {
  --focus-ring-color: var(--color-link);
}
```


## 5. Keyboard Navigation Patterns

### Interactive Lists (Arrow Keys)

Lists of selectable items support arrow key navigation with `aria-activedescendant`:

```html
<ul role="listbox" aria-label="Choose assignee">
  <li role="option" id="user-1" tabindex="-1">Alice</li>
  <li role="option" id="user-2" tabindex="-1">Bob</li>
  <li role="option" id="user-3" tabindex="-1">Charlie</li>
</ul>
```

**Expected keyboard behavior**:
- `ArrowUp` / `ArrowDown`: Move selection
- `Enter`: Activate selected item
- `Escape`: Close (if in a popup)
- `Home` / `End`: Jump to first/last item

### Dialogs (Escape to Close)

```html
<dialog>
  <!-- Tab cycles through focusable content -->
  <!-- Escape closes -->
  <button data-action="dialog#close">Cancel</button>
</dialog>
```

### Global Hotkeys

Document-level keyboard shortcuts for power users:

```html
<!-- Hotkey hint visible on non-touch devices -->
<button>
  Search
  <kbd class="kbd txt-xx-small hide-on-touch">K</kbd>
</button>
```

**Rules**:
- Hotkeys must not fire inside `<input>`, `<textarea>`, or `[contenteditable]`
- Show hotkey hints with `<kbd>` elements
- Hide hints on touch devices (`.hide-on-touch`)


## 6. ARIA for Custom Widgets

Use ARIA only when native HTML elements can't provide the interaction pattern.

### Custom Radio Group

```html
<fieldset>
  <legend class="visually-hidden">Choose a column for this card</legend>
  <div role="radiogroup" aria-labelledby="column-label">
    <button role="radio" aria-checked="false">To Do</button>
    <button role="radio" aria-checked="true">In Progress</button>
    <button role="radio" aria-checked="false">Done</button>
  </div>
</fieldset>
```

### Custom Listbox (Combobox)

```html
<div role="combobox" aria-expanded="true" aria-haspopup="listbox">
  <input type="text" aria-activedescendant="option-2" />
  <ul role="listbox">
    <li role="option" id="option-1">Option A</li>
    <li role="option" id="option-2" aria-selected="true">Option B</li>
    <li role="option" id="option-3">Option C</li>
  </ul>
</div>
```

### Multi-Select with Checkboxes

```html
<ul role="listbox" aria-label="Filter by tag" aria-multiselectable="true">
  <li role="option" aria-selected="true">Bug</li>
  <li role="option" aria-selected="false">Feature</li>
  <li role="option" aria-selected="true">Urgent</li>
</ul>
```

### Collapsible Sections

```html
<button aria-expanded="false" aria-controls="section-1">
  Details
</button>
<div id="section-1" hidden>
  <!-- collapsible content -->
</div>
```

Or, preferably, use native `<details>`:

```html
<details>
  <summary>Details</summary>
  <div>Collapsible content</div>
</details>
```


## 7. Platform-Aware Focus

Touch devices and mouse/keyboard devices need different focus behavior:

```css
/* Focus ring only on keyboard navigation */
:focus-visible { outline: 2px solid var(--focus-ring-color); }

/* No focus ring on mouse click */
:focus:not(:focus-visible) { outline: none; }
```

For dialogs, consider which element to autofocus based on input method:
- **Keyboard**: Focus the first interactive element (input, button)
- **Touch**: Focus a larger target or the close button

```html
<dialog>
  <!-- Keyboard users: focus this input -->
  <input type="text" data-focus-mouse-target />

  <!-- Touch users: focus this button (larger target) -->
  <button data-focus-touch-target>Done</button>
</dialog>
```


## 8. Reduced Motion

Respect `prefers-reduced-motion` for all animations and transitions:

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

**Rule**: This should be a global reset. No component should need to individually check for reduced motion — the reset handles it.


## 9. Decorative vs Meaningful Content

Mark decorative elements so screen readers skip them:

```html
<!-- Decorative icon — hidden from SR -->
<svg aria-hidden="true">...</svg>

<!-- Decorative image — empty alt -->
<img src="decoration.png" alt="" />

<!-- Decorative separator — hidden from SR -->
<hr aria-hidden="true" />

<!-- Meaningful image — descriptive alt -->
<img src="chart.png" alt="Monthly revenue chart showing 15% growth" />
```

**Decision**: If removing the element changes the meaning of the content, it's meaningful (needs alt/label). If it's purely visual, it's decorative (`aria-hidden` or `alt=""`).


## 10. Form Accessibility

```html
<!-- Always associate labels with inputs -->
<label for="card-title">Card title</label>
<input id="card-title" type="text" required />

<!-- Or wrap the input in the label -->
<label>
  Card title
  <input type="text" required />
</label>

<!-- Grouped controls need fieldset + legend -->
<fieldset>
  <legend>Card status</legend>
  <label><input type="radio" name="status" value="open" /> Open</label>
  <label><input type="radio" name="status" value="closed" /> Closed</label>
</fieldset>

<!-- Use native validation attributes -->
<input type="email" required placeholder="you@example.com" />
<input type="url" required pattern="https?://.*" title="Must be a URL" />
```

**Rules**:
- Every input has a visible or visually-hidden label
- Use `required`, `pattern`, `type` for native validation before JS
- Group related controls with `<fieldset>` and `<legend>`
- Disable submit buttons until form is valid (use `:has()` or JS)


## Antipatterns

| Antipattern | Fix |
|-------------|-----|
| Icon button with no label | Add `<span class="visually-hidden">Label</span>` |
| `outline: none` on focus | Use `:focus-visible` with a visible ring |
| `<div onclick="...">` | `<button>` — divs aren't keyboard accessible |
| `tabindex="5"` (positive) | Use `tabindex="0"` or `-1` only |
| `aria-hidden="true"` on interactive element | Remove it — hides from screen readers |
| Custom checkbox without `aria-checked` | Use native `<input type="checkbox">` or add ARIA |
| Animations with no reduced-motion check | Add global `prefers-reduced-motion` reset |
| Placeholder text as label | Placeholders disappear on input — use `<label>` |
| `role="button"` on a `<div>` | Use `<button>` — it's free keyboard support |
