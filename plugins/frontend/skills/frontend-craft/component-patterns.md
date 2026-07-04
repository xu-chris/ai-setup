# Component Patterns

Named patterns for common UI components. Each pattern shows the canonical structure — adapt to your needs but preserve the semantic and accessibility bones.

---

## The Card

A standalone content item with header, body, and footer zones.

**Structure**: `<article>` with internal `<header>`, content `<div>`, and `<footer>`.

```html
<article class="card" style="--card-color: #4a90d9;">
  <header class="card__header">
    <span class="card__board">Design</span>
    <div class="card__tags">
      <span class="tag">Bug</span>
      <span class="tag">P1</span>
    </div>
  </header>

  <div class="card__body">
    <h3 class="card__title">Fix navigation overflow on mobile</h3>
    <p class="card__excerpt">The hamburger menu clips on devices narrower than...</p>
  </div>

  <footer class="card__footer">
    <span class="card__meta">
      <span class="visually-hidden">Card number</span>#42
    </span>
    <div class="card__assignees">
      <img src="avatar.jpg" alt="" class="avatar" />
    </div>
  </footer>
</article>
```

```css
@layer components {
  .card {
    --card-color: var(--color-canvas);
    display: flex;
    flex-direction: column;
    background: var(--color-canvas);
    border-radius: 0.5rem;
    box-shadow: var(--shadow);
  }

  .card__header {
    display: flex;
    align-items: center;
    gap: var(--inline-space-half);
    padding: var(--block-space-half) var(--inline-space);
  }

  .card__body {
    flex: 1;
    padding-inline: var(--inline-space);
  }

  .card__footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: var(--block-space-half) var(--inline-space);
  }
}
```

**Key decisions**:
- `<article>` because a card is standalone content
- Flex column because card content flows in one direction
- Header/footer are `<header>`/`<footer>` (semantic)
- Body is `<div>` (no semantic element for "main content area" inside article)
- CSS custom property `--card-color` for per-card theming via inline style
- Card number has visually hidden label for screen readers


## The Dialog

A modal or popup using the native `<dialog>` element.

**Structure**: Controller wrapper → trigger button → `<dialog>` element.

```html
<div data-controller="dialog" data-dialog-modal-value="true">
  <!-- Trigger -->
  <button type="button" class="btn" data-action="dialog#open">
    Delete
  </button>

  <!-- Dialog -->
  <dialog class="dialog panel" data-dialog-target="dialog">
    <h3>Delete this card?</h3>
    <p>This action cannot be undone.</p>
    <div class="flex gap justify-center">
      <button type="button" class="btn" data-action="dialog#close">
        Cancel
      </button>
      <form method="post" action="/cards/123">
        <input type="hidden" name="_method" value="delete" />
        <button class="btn btn--negative">Delete card</button>
      </form>
    </div>
  </dialog>
</div>
```

```css
@layer components {
  dialog {
    border: none;
    padding: 0;
    background: transparent;
    max-inline-size: min(90dvw, 50ch);
  }

  dialog::backdrop {
    background: oklch(0% 0 0 / 0.4);
  }

  .dialog {
    padding: var(--block-space) var(--inline-space);
    background: var(--color-canvas);
    border-radius: 0.5rem;
    box-shadow: var(--shadow);
  }
}
```

**Key decisions**:
- Native `<dialog>` provides: focus trapping, backdrop, escape-to-close, `showModal()`/`show()`, proper inert behavior on content behind
- Trigger and dialog are siblings inside a controller wrapper
- Destructive actions use a `<form>` with method POST + hidden `_method` field
- Cancel uses `type="button"` to prevent form submission
- `::backdrop` for the overlay — no extra div needed


## The Disclosure

Expandable content using native `<details>`/`<summary>`.

```html
<details class="disclosure">
  <summary class="btn txt-small">
    <svg class="icon" aria-hidden="true">...</svg>
    <span>Show advanced options</span>
  </summary>

  <div class="disclosure__content">
    <p>Advanced content that was hidden...</p>
  </div>
</details>
```

```css
@layer components {
  details > summary {
    list-style: none;
    cursor: pointer;
  }

  details > summary::-webkit-details-marker {
    display: none;
  }

  .disclosure__content {
    padding-block-start: var(--block-space-half);
  }
}
```

**Key decisions**:
- Native `<details>` provides: toggle behavior, keyboard support, `open` attribute, no JS needed
- Remove default marker with `list-style: none` and `::-webkit-details-marker`
- Summary styled as a button for visual consistency
- Content wrapper for top padding (gap doesn't work inside details)


## The Form

A structured form with labeled field groups.

```html
<article class="panel center">
  <form class="flex flex-column gap" data-controller="form">
    <!-- Text field group -->
    <div class="flex flex-column gap-half">
      <label for="webhook-name"><strong>Name</strong></label>
      <input id="webhook-name" type="text" class="input"
        required autofocus placeholder="Name this webhook..." />
    </div>

    <!-- URL field with description -->
    <div class="flex flex-column gap-half">
      <label for="webhook-url">
        <strong>Payload URL</strong>
        <p class="txt-x-small txt-subtle">
          The URL that will receive payloads.
        </p>
      </label>
      <input id="webhook-url" type="url" class="input"
        required pattern="https?://.*"
        title="Must be an http:// or https:// URL"
        placeholder="https://example.com" />
    </div>

    <!-- Select field -->
    <div class="flex flex-column gap-half">
      <label for="webhook-permission"><strong>Permission</strong></label>
      <select id="webhook-permission" class="input input--select">
        <option value="read">Read</option>
        <option value="write">Read + Write</option>
      </select>
    </div>

    <!-- Actions -->
    <div class="flex gap justify-center">
      <button type="submit" class="btn btn--link">
        <span>Create Webhook</span>
      </button>
    </div>
  </form>
</article>
```

**Key decisions**:
- Form wraps in `<article>` (standalone document)
- Form itself is `flex flex-column gap` — vertical stack with consistent spacing
- Each field group is `flex flex-column gap-half` — label above input
- Labels use `for` attribute linked to input `id`
- Descriptions are `<p>` inside `<label>` (associated automatically)
- Native validation: `required`, `pattern`, `type="url"`, `title` for validation message
- Submit button uses `btn--link` (primary action visual weight)
- Hidden cancel link for JS controller access


## The Navigable List

A keyboard-navigable list of selectable items (for menus, command palettes, filter lists).

```html
<div role="listbox" aria-label="Choose a board"
     data-controller="navigable-list"
     data-action="keydown->navigable-list#navigate">

  <input type="text" class="input"
    aria-activedescendant=""
    data-navigable-list-target="input"
    data-action="input->navigable-list#filter"
    placeholder="Search boards..." />

  <ul class="popup__list">
    <li role="option" id="board-1" tabindex="-1"
        data-navigable-list-target="item">
      Design
    </li>
    <li role="option" id="board-2" tabindex="-1"
        data-navigable-list-target="item">
      Engineering
    </li>
    <li role="option" id="board-3" tabindex="-1"
        data-navigable-list-target="item">
      Marketing
    </li>
  </ul>
</div>
```

**Expected keyboard behavior**:
| Key | Action |
|-----|--------|
| `ArrowDown` | Move to next item |
| `ArrowUp` | Move to previous item |
| `Enter` | Activate selected item |
| `Escape` | Close list / clear selection |
| `Home` | Jump to first item |
| `End` | Jump to last item |
| Typing | Filters the list |

**Key decisions**:
- `role="listbox"` with `role="option"` children for ARIA compliance
- `aria-activedescendant` on the input tracks which option has virtual focus
- `tabindex="-1"` on options — they receive programmatic focus, not tab focus
- Separate input for filtering — not combined with the list control
- Items scroll into view when navigated to


## The Icon Button

A button containing only an icon, with accessible text.

```html
<!-- Standard icon button -->
<button class="btn btn--circle" aria-label="Settings">
  <svg class="icon" aria-hidden="true">
    <use href="#icon-settings" />
  </svg>
  <span class="visually-hidden">Settings</span>
</button>

<!-- Icon button with keyboard hint -->
<button class="btn btn--circle">
  <svg class="icon" aria-hidden="true">
    <use href="#icon-search" />
  </svg>
  <span class="visually-hidden">Search</span>
  <kbd class="kbd txt-xx-small hide-on-touch">K</kbd>
</button>

<!-- Icon link (navigation) -->
<a href="/settings" class="btn btn--circle">
  <svg class="icon" aria-hidden="true">
    <use href="#icon-settings" />
  </svg>
  <span class="visually-hidden">Notification settings</span>
</a>
```

```css
@layer components {
  .btn--circle {
    --btn-padding: 0;
    aspect-ratio: 1;
    display: grid;
    place-items: center;
    border-radius: 50%;
    inline-size: var(--btn-size, 2.65em);
  }
}
```

**Key decisions**:
- Grid with `place-items: center` for perfect centering (better than flex for single item)
- `aspect-ratio: 1` ensures circular shape
- Icon is `aria-hidden="true"` — never used as the label
- Visually hidden `<span>` provides the accessible name
- `<kbd>` for keyboard shortcut hint, hidden on touch devices


## The Toolbar

A horizontal bar with left, center, and optional right zones.

```html
<header class="toolbar">
  <div class="toolbar__start">
    <a href="/" class="btn btn--circle">
      <svg class="icon" aria-hidden="true">...</svg>
      <span class="visually-hidden">Back</span>
    </a>
  </div>

  <h1 class="toolbar__title txt-medium">Board Settings</h1>

  <div class="toolbar__end">
    <button class="btn btn--circle">
      <svg class="icon" aria-hidden="true">...</svg>
      <span class="visually-hidden">More options</span>
    </button>
  </div>
</header>
```

```css
@layer components {
  .toolbar {
    display: grid;
    grid-template-columns: var(--actions-width, 3rem) 1fr var(--actions-width, 3rem);
    align-items: center;
    padding: var(--block-space-half) var(--inline-space);
  }

  .toolbar__title {
    text-align: center;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .toolbar__end {
    justify-self: end;
  }
}
```

**Key decisions**:
- Grid (not flex) because we need three zones with the center zone truly centered regardless of left/right content width
- `grid-template-columns` with equal outer columns ensures the title stays perfectly centered
- `<header>` because it's the heading area of a page/section
- Title truncates with `overflow: hidden; text-overflow: ellipsis`


## The Tray (Slide-Out Panel)

A persistent side panel (notifications, filters, pins) that slides in from the edge.

```html
<section class="tray" data-controller="dialog badge">
  <!-- Toggle button (always visible) -->
  <button class="tray__toggle btn btn--circle"
    data-action="dialog#toggle"
    aria-haspopup="true">
    <svg class="icon" aria-hidden="true">...</svg>
    <span class="visually-hidden">Notifications</span>
    <span class="badge" data-badge-target="count" hidden>0</span>
  </button>

  <!-- Slide-out dialog -->
  <dialog class="tray__dialog" data-dialog-target="dialog">
    <header class="tray__header flex align-center justify-space-between">
      <h2 class="txt-medium">Notifications</h2>
      <a href="/settings" class="btn btn--circle">
        <svg class="icon" aria-hidden="true">...</svg>
        <span class="visually-hidden">Settings</span>
      </a>
    </header>
    <div class="tray__content">
      <!-- scrollable content -->
    </div>
  </dialog>
</section>
```

```css
@layer modules {
  .tray__dialog {
    position: fixed;
    inset-block-start: 0;
    inset-inline-end: 0;
    block-size: 100dvh;
    inline-size: clamp(12rem, 25dvw, 24rem);
    z-index: var(--z-tray);
    transform: translateX(100%);
    transition: transform 200ms ease-out;
  }

  .tray__dialog[open] {
    transform: translateX(0);
  }
}
```

**Key decisions**:
- `<section>` wraps the whole tray (toggle + panel) as a thematic group
- `<dialog>` for the panel itself — gets focus trapping and backdrop
- Fixed positioning with `clamp()` for fluid width
- Badge count hidden when zero
- `aria-haspopup` on toggle signals that it opens a popup
