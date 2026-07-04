# HTML Structure

## 1. Semantic Elements First

Choose the HTML element that describes the *content*, not the *appearance*. Only fall back to `<div>` when no semantic element fits.

### Element Decision Guide

| Content type | Element | Not |
|-------------|---------|-----|
| Page content area | `<main>` | `<div id="content">` |
| Page or section heading area | `<header>` | `<div class="header">` |
| Page or section footer | `<footer>` | `<div class="footer">` |
| Navigation links | `<nav>` | `<div class="nav">` |
| Standalone content (card, article, form page) | `<article>` | `<div class="card">` |
| Thematic group (list of cards, notification group) | `<section>` | `<div class="section">` |
| Modal or popup | `<dialog>` | `<div class="modal">` |
| Expandable disclosure | `<details>` / `<summary>` | `<div class="accordion">` |
| Image with caption | `<figure>` / `<figcaption>` | `<div class="image-wrapper">` |
| Layout wrapper with no semantic meaning | `<div>` | This is the correct use |

```html
<!-- Good — semantic elements describe structure -->
<main id="main">
  <section class="cards cards--grid">
    <article class="card">
      <header class="card__header">...</header>
      <div class="card__body">...</div>
      <footer class="card__footer">...</footer>
    </article>
  </section>
</main>

<!-- Bad — divs with classes pretending to be semantic -->
<div id="main">
  <div class="cards-section">
    <div class="card">
      <div class="card-header">...</div>
      <div class="card-body">...</div>
      <div class="card-footer">...</div>
    </div>
  </div>
</div>
```

### When to Use `<section>` vs `<article>`

- **`<section>`**: A group of related items. Cards in a column, notifications in a list, settings in a panel. Think *collection*.
- **`<article>`**: Standalone, self-contained content. A single card detail page, a form in a panel, a comment. Think *document*.

```html
<!-- section wraps a collection -->
<section class="cards">
  <article class="card">...</article>
  <article class="card">...</article>
</section>

<!-- article wraps standalone content -->
<article class="panel">
  <header>...</header>
  <form>...</form>
</article>
```


## 2. Div Discipline

A `<div>` is a layout primitive with zero semantic meaning. Use it **only** for:

1. **Flex/grid wrappers** — when you need a container for layout
2. **Spacing/composition** — grouping elements for margin/padding
3. **JS behavior targets** — wrapping content for controller attachment
4. **Conditional containers** — elements toggled by state (hidden/shown)

```html
<!-- Good — div for flex layout, no semantic meaning -->
<div class="flex align-center gap">
  <strong>Name</strong>
  <input type="text" class="input" />
</div>

<!-- Good — div wraps a controller target -->
<div data-controller="dialog">
  <button data-action="dialog#open">Open</button>
  <dialog data-dialog-target="dialog">...</dialog>
</div>

<!-- Bad — div where section/article/nav belongs -->
<div class="notifications-panel">  <!-- should be <section> -->
<div class="user-profile">          <!-- should be <article> -->
<div class="sidebar-links">         <!-- should be <nav> -->
```

**Test**: If you can answer "what kind of content is this?" — use a semantic element. If the answer is "it's a box for layout" — use a `<div>`.


## 3. Keep the DOM Flat

Deep nesting makes CSS harder (specificity), JS harder (traversal), and accessibility harder (screen reader verbosity). Target **6 levels max** from `<body>`.

### Strategies for Flatness

**Extract components** instead of nesting deeper:
```html
<!-- Bad — 8+ levels deep -->
<div class="page">
  <div class="content">
    <div class="cards">
      <div class="card">
        <div class="card-body">
          <div class="card-meta">
            <div class="card-meta-inner">
              <span>Author</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Good — extract card as its own component, flatten page -->
<main id="main">
  <section class="cards">
    <article class="card">
      <div class="card__body">
        <span class="card__author">Author</span>
      </div>
    </article>
  </section>
</main>
```

**Use flex/grid gap** instead of wrapper divs for spacing:
```html
<!-- Bad — wrapper div just for spacing -->
<div class="button-wrapper">
  <button class="btn">Cancel</button>
  <button class="btn btn--link">Save</button>
</div>

<!-- Good — gap on parent, no wrapper needed -->
<footer class="flex gap">
  <button class="btn">Cancel</button>
  <button class="btn btn--link">Save</button>
</footer>
```

**Use CSS `:has()`** instead of state-wrapper divs:
```html
<!-- Bad — extra div just to carry state -->
<div class="column-wrapper is-expanded">
  <section class="column">...</section>
</div>

<!-- Good — column carries its own state, parent uses :has() -->
<section class="column is-expanded">...</section>
```


## 4. IDs vs Classes

| Use | For | Convention |
|-----|-----|-----------|
| **IDs** | Unique landmarks, skip-link targets, form labels, JS targeting | `id="main"`, `id="header"`, `id="footer"` |
| **Classes** | Styling, component identification, utility application | `.card`, `.btn--link`, `.flex` |

```html
<!-- Good — ID for landmark, classes for styling -->
<main id="main">
  <section class="cards cards--grid">
    <article id="card-123" class="card">...</article>
  </section>
</main>

<!-- Bad — IDs for styling -->
<div id="main-content">          <!-- Don't style by ID -->
<article id="card" class="...">  <!-- ID should be unique per instance -->
```

**Rules**:
- IDs for page landmarks: `main`, `header`, `footer`
- IDs for model instances: one per record (e.g., `card-123`)
- Never style by ID — always use classes
- Never reuse IDs — they must be unique per page


## 5. Button vs Link

The choice between `<button>` and `<a>` is about **behavior**, not appearance. Both can look identical with shared CSS.

```
Is it navigation (goes to a URL)?  →  <a href="...">
Is it an action (does something)?  →  <button>
```

```html
<!-- Good — link navigates to a page -->
<a href="/settings" class="btn">Settings</a>

<!-- Good — button performs an action -->
<button class="btn" data-action="dialog#open">Delete</button>

<!-- Good — destructive action as form submission -->
<form action="/cards/123" method="post">
  <input type="hidden" name="_method" value="delete">
  <button class="btn btn--negative">Delete card</button>
</form>

<!-- Bad — link used for action -->
<a href="#" onclick="deleteCard()">Delete</a>

<!-- Bad — div pretending to be a button -->
<div class="btn" onclick="save()">Save</div>
```

**Rules**:
- `<a>` must have an `href`. No `<a>` without navigation.
- `<button>` defaults to `type="submit"` inside forms. Use `type="button"` for non-submit actions.
- Style both with the same `.btn` class. Appearance is a CSS concern, not an HTML concern.
- `<form>` with `method="post"` for server-side actions (delete, update). Use hidden `_method` field for REST verbs.


## 6. Native Elements over ARIA Recreations

If a native HTML element does what you need, use it. Don't rebuild it with ARIA.

| Need | Use | Not |
|------|-----|-----|
| Modal | `<dialog>` | `<div role="dialog" aria-modal="true">` |
| Disclosure | `<details>` / `<summary>` | `<div role="button" aria-expanded>` + JS |
| Checkbox | `<input type="checkbox">` | `<div role="checkbox" aria-checked>` |
| Radio group | `<fieldset>` + `<input type="radio">` | `<div role="radiogroup">` + JS |
| Dropdown | `<select>` | `<div role="listbox">` + JS |

```html
<!-- Good — native dialog element -->
<dialog class="dialog panel">
  <h3>Delete this card?</h3>
  <p>This cannot be undone.</p>
  <div class="flex gap">
    <button data-action="dialog#close">Cancel</button>
    <button class="btn btn--negative">Delete</button>
  </div>
</dialog>

<!-- Bad — div pretending to be a dialog -->
<div class="modal" role="dialog" aria-modal="true" tabindex="-1">
  <div class="modal-backdrop"></div>
  <div class="modal-content">
    <!-- Now you need to manage focus trap, escape key, click-outside,
         aria-hidden on siblings... all for free with <dialog> -->
  </div>
</div>
```

**When ARIA is necessary**: Custom selection widgets (comboboxes, multi-select filters) where native elements can't match the design. In these cases, use `role="listbox"` / `role="option"` / `role="checkbox"` with full keyboard support.


## 7. Data Attributes for Behavior

Use `data-*` attributes for JavaScript behavior. Use classes for CSS styling. Don't mix them.

```html
<!-- Good — clean separation -->
<div data-controller="dialog" data-dialog-modal-value="true">
  <button class="btn" data-action="dialog#open">Open</button>
  <dialog class="dialog panel" data-dialog-target="dialog">
    ...
  </dialog>
</div>

<!-- Bad — classes for JS targeting -->
<div class="js-dialog">
  <button class="js-dialog-trigger btn">Open</button>
  <div class="js-dialog-content dialog panel">...</div>
</div>

<!-- Bad — inline event handlers -->
<button class="btn" onclick="openDialog()">Open</button>
```


## 8. View Transitions

Use CSS `view-transition-name` for smooth page transitions on elements that persist across navigations:

```html
<article style="view-transition-name: card-123">
  ...
</article>
```

**Rule**: Apply `view-transition-name` to the outermost stable element (usually `<article>` or `<section>` with a unique ID). The value must be unique per page.


## Antipatterns

| Antipattern | Fix |
|-------------|-----|
| `<div class="header">` | `<header>` |
| `<div class="nav">` | `<nav>` |
| `<a href="#" onclick="...">` | `<button data-action="...">` |
| `<div role="dialog">` + focus trap JS | `<dialog>` |
| `<div class="accordion">` + toggle JS | `<details><summary>` |
| 10+ levels of nested divs | Extract components, use gap |
| `id="card"` (reused) | Unique IDs: `id="card-123"` |
| `class="js-toggle"` for JS targeting | `data-action="toggle#click"` |
| `<div onclick="...">` | `<button>` — divs are not interactive |
