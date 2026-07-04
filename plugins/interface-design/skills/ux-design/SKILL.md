---
name: ux-design
description: Use when designing UI behavior, writing user-facing copy, handling errors/empty states, or auditing an existing interface for usability problems. Triggers on form design, error messages, empty states, confirmation dialogs, loading states, navigation, search, authentication flows, and any user-facing text.
---

# UX Design and Audit

A synthesized set of interaction design principles for building interfaces that are helpful, self-explanatory, and human-friendly. Draws from Jakob Nielsen's 10 usability heuristics, Ben Shneiderman's 8 golden rules, Alan Cooper's 16 principles for considerate products (About Face), Jason Fried's Defensive Design for the Web, Don Norman's design principles, Bruce Tognazzini's first principles of interaction design, and Jon Yablonski's Laws of UX.

Use this skill to **design** new UI behavior with the right defaults, **write** user-facing copy that speaks human, or **audit** existing interfaces against proven heuristics.

This skill covers WHAT to build (behavior, feedback, copy, error handling, information design).

## The Iron Law

```
DESIGN FOR BEHAVIOR AND RECOVERY, NOT APPEARANCE
```

Every UI decision passes through this: does this help the user do something, understand something, or recover from something? If it is only about how things look, it is not a design decision - it is a style decision. Style comes after behavior is confirmed.

Violating the letter of this rule is violating the spirit of it.

## Core Principles

These principles do contain always-applicable design mindset. Every UI decision should pass through these.

### 1. Speak human

Use the user's language, never the system's. No error codes, no jargon, no developer-speak. Follow real-world conventions for ordering, formatting, and metaphors - dates, currencies, and icons should match what users expect from their context. If a non-technical person wouldn't say it out loud, rewrite it.

> Nielsen #2 (match real world), Cooper #12 (don't ask questions), Fried: Language Matters

### 2. Show where they are

Users always know three things: where they are, what just happened, and what they can do next. Feedback within 1 second for any action. Progress indication for anything longer. Proactively surface relevant information the user hasn't asked for but would benefit from - upcoming deadlines, related items, status changes.

> Nielsen #1 (visibility of system status), Shneiderman #3 (feedback) and #4 (closure), Cooper #3 (forthcoming), #9 (keep informed)

### 3. Prevent before cure

Design so errors can't happen. Disable invalid options, constrain inputs, use smart defaults. Prevent slips (unconscious errors like typos) with input masks and constraints. Prevent mistakes (wrong mental model) with clear labels and confirmation for irreversible actions. Allow flexible intermediate states - let users save incomplete work and validate for completeness only at the final step.

> Nielsen #5 (error prevention), Shneiderman #5 (error handling), Cooper #14 (bend the rules), #16 (help avoid mistakes), Fried: Plan for Failure

### 4. Respect autonomy

Users initiate, the system responds. Never trap users in flows, lecture them with modals, or take away control. Offer clearly marked exits at every step, support undo, allow skipping. The user is in charge.

> Nielsen #3 (user control and freedom), Shneiderman #6 (reversal) and #7 (locus of control), Cooper #2 (deferential) and #11 (self-confident)

### 5. Reduce work

Don't make users remember, repeat, or re-enter. Recognize over recall - make all available actions visible in context. Anticipate needs, offer smart defaults, remember preferences. Observe usage patterns and adapt: surface recently used items, adjust defaults to match behavior. Design for different skill levels - provide keyboard shortcuts and accelerators for power users while keeping the interface learnable for beginners. Every question the UI doesn't ask is a gift.

> Nielsen #6 (recognition over recall) and #7 (flexibility and efficiency), Shneiderman #2 (shortcuts) and #8 (reduce memory load), Cooper #1 (take interest), #6 (anticipate needs), #10 (perceptive), #12 (don't ask questions)

### 6. Close the loop

Every action has a visible result. Every sequence has a clear ending. Users should never wonder "did that work?" after clicking a button or completing a flow. Follow through comprehensively - when a user changes something, handle all related consequences, not just the one field they touched.

> Shneiderman #4 (closure), Cooper #7 (conscientious), #15 (take responsibility)

### 7. Fail gracefully

When things go wrong, protect user data first, explain simply second, offer next steps third. Never show raw system state, stack traces, or generic "something went wrong" messages. Never expose sensitive information in error messages - no usernames, email addresses, internal paths, or details that reveal system architecture. Handle the Three D's: Distraction (user missed something), Disorientation (user doesn't know where they are), and Doubt (user isn't sure what happened or what to do).

> Cooper #5 (use discretion), #8 (don't burden with problems), #13 (fail gracefully), Fried: Three D's, Nielsen #9 (help users recognize and recover)

### 8. Be consistent

Same thing looks and works the same way everywhere. Patterns, not surprises. Internal consistency (within the app) and external consistency (with platform conventions) both matter.

> Nielsen #4 (consistency and standards), Shneiderman #1 (strive for consistency)

### 9. Show only what matters

Every element on screen competes with every other element for attention. Prioritize frequent actions over rare ones - common tasks should be prominent, advanced features accessible but not competing. Remove information that doesn't help the user's current task. When in doubt, hide it behind progressive disclosure rather than showing everything at once.

> Nielsen #8 (aesthetic and minimalist design), Cooper #4 (use common sense)

### 10. Be forgiving

Accept messy input gracefully. Phone numbers with or without dashes, dates in multiple formats, extra whitespace, inconsistent capitalization - normalize it silently instead of rejecting it. The interface should work as hard as a helpful human colleague who understands what you meant, not a bureaucrat who rejects your form for a missing hyphen.

> Postel's Law (be liberal in what you accept), Tog #15 (protect users' work)

### 11. Look like what you do

Interactive elements must look interactive. Non-interactive elements must not. Buttons look clickable, links look like links, disabled controls look disabled. Users should never have to click something to find out if it's clickable. The interface should be self-explanatory without any help text - users don't read instructions, they just start clicking.

> Norman: affordance, Tog #7 (discoverability), Tog: Paradox of the Active User

## Decision Lookup

When designing a specific UI element, find your situation and apply the listed rules.

### Error messages

**Principles**: Speak human, Fail gracefully

Say what happened, why, and what to do. Never codes, blame, or jargon. Place the message next to the problem, not in a distant banner. Never reveal sensitive system details (database names, stack traces, internal IDs, other users' data).

```
Bad:  "Error: Invalid input in field 'email'"
Bad:  "Something went wrong. Please try again."
Good: "That email address needs an @ symbol - check for typos."
Good: "We couldn't save your changes because the connection dropped. Your draft is safe."
```

**Formula**: [What happened] + [Why] + [What to do next]

### Empty states

**Principles**: Close the loop, Reduce work

Explain why it's empty, show how to fill it, offer a primary action. An empty state is a teaching moment, not a dead end.

```
Bad:  "No results found."
Bad:  "There are no items to display."
Good: "No projects yet. Create your first project to get started."
Good: "No submissions match these filters. Try broadening your search or clearing filters."
```

**Formula**: [Why it's empty] + [What to do about it]

### Loading and waiting

**Principles**: Show where they are

Show progress if longer than 1 second. Use skeleton screens over spinners where possible. Never show a blank page. Describe what's actually happening when you can.

```
Bad:  "Loading..."
Bad:  "Please wait."
Good: "Checking submission requirements..."
Good: "Importing 24 of 89 films..."
```

**Formula**: [Present participle of what's happening] + [Progress if known]

### Forms

**Principles**: Prevent before cure, Reduce work

Validate inline on blur, not on submit. Use smart defaults and pre-fill what you already know. Always preserve user input on error - never clear the form. Group related fields. Mark optional fields, not required ones (most fields should be required by design). Allow saving incomplete work as drafts - validate for completeness only at the final submission step, not at every save. Accept messy input: normalize phone numbers, trim whitespace, accept multiple date formats - parse generously instead of demanding exact formats.

### Destructive actions

**Principles**: Respect autonomy, Prevent before cure

Describe concrete consequences, not "Are you sure?" Name what will be affected and what can't be undone. Prefer undo over confirmation dialogs when the action is reversible. Make the safe option visually primary.

```
Bad:  "Are you sure?"
Bad:  "Warning: This action cannot be undone."
Good: "Delete 'Summer Film Festival'? This removes all 12 submissions and cannot be undone."
Good: "Remove yourself from this project? You'll lose access to all shared files."
```

**Formula**: [Verb + specific object] + [Concrete consequence]

### Success feedback

**Principles**: Close the loop

Confirm what happened and what changed. Keep it brief and dismissable. Toast/flash messages work well. For significant actions, show what was created/changed.

### Search

**Principles**: Fail gracefully, Reduce work, Show only what matters

**No results**: Suggest spelling corrections, offer alternative queries, explain what was searched and in what scope. Never just "No results."

**Too many results**: Offer filters, facets, or sorting to narrow down. Show result count and scope.

**Typos and fuzzy matches**: Map common misspellings to correct results. Show "Did you mean...?" when returning inexact matches, and explain why these results are shown.

**Search tips**: For complex search, offer tips or syntax help - but keep the default search simple. Advanced search should be opt-in, never the default.

### Navigation and wayfinding

**Principles**: Show where they are, Be consistent

Clear page titles, active states in navigation, breadcrumbs for deep hierarchies. The user should never ask "where am I?" or "how do I get back?"

### Button and link labels

**Principles**: Speak human

Always verb + object: "Save draft", "Delete project", "Add submission". Never generic "Submit", "OK", "Click here". Both buttons in a confirmation pair should be specific ("Delete project" / "Keep project", not "Yes" / "No").

### Help and documentation

**Principles**: Reduce work, Speak human

**Inline help**: At the point of need, not in a separate docs page. One sentence max. Explain why, not just what. Use placeholder text for format hints, helper text below the field for context.

**Task-level help**: For complex features, provide searchable documentation focused on completing specific tasks. List concrete steps, not abstract concepts. Users should be able to find help without leaving their current task.

**Onboarding**: For first-time users, guide them through key features with contextual tips or a brief walkthrough. Let users skip or dismiss onboarding at any time.

### Unavailable items

**Principles**: Fail gracefully, Close the loop

Show that the item exists but explain why it's unavailable (expired, sold out, restricted). Offer alternatives, or let the user be notified when it becomes available. Never silently hide things.

### Multi-step flows

**Principles**: Show where they are, Close the loop

Show which step the user is on and how many remain. Allow going back without losing progress. Preserve state across steps. Users get more motivated as they approach completion (Goal-Gradient Effect) - show concrete progress, especially in the final steps. People judge experiences by their peak moment and ending (Peak-End Rule) - invest in a satisfying final step and success confirmation rather than making every step equally polished.

### Authentication flows

**Principles**: Fail gracefully, Prevent before cure, Reduce work

**Bad login**: Don't reveal whether the username or password was wrong - say "Email or password is incorrect" to avoid leaking valid accounts. Offer password reset inline, not as a separate hunt.

**Forgotten password**: Make the reset flow immediately accessible from the login form. Confirm that the reset was sent without revealing whether the account exists ("If an account exists for that email, we've sent a reset link").

**Session expiry**: Warn before expiring if possible. When a session expires mid-task, preserve the user's work and explain what happened. After re-authentication, return to where they were.

**Account lockout**: Explain why access is restricted and how long the lockout lasts. Offer alternative recovery paths (email, support).

### Sensitive data

**Principles**: Fail gracefully, Respect autonomy

Mask password inputs by default but allow toggling visibility. Never log, display in URLs, or echo back sensitive data (passwords, tokens, payment details). In error messages, never include other users' information. Confirm before exposing sensitive fields, and auto-hide them after a timeout.

### Validation messages

**Principles**: Speak human, Prevent before cure

Explain what's needed and why, or what's specifically wrong. Never generic "invalid" or "required" messages.

```
Bad:  "This field is required."
Bad:  "Invalid format."
Good: "Add a title so reviewers can find your film."
Good: "Phone numbers need 10 digits - you've entered 8."
```

**Formula**: [What's needed] + [Why it matters OR what's specifically wrong]

### Missing pages (404)

**Principles**: Fail gracefully, Show where they are

Explain that the page wasn't found in plain language. Offer navigation back to a known location, suggest search, and link to common destinations. Never show a raw server error page.

## UX Audit Checklist

Task-based audit inspired by Fried's Defensive Design. Role-play as a distracted, confused, or hurried user - apply the Three D's lens (Distraction, Disorientation, Doubt) to every scenario. Each item is **pass/fail** - any fail gets a note naming what's wrong and which core principle it violates.

### Try to fail

- [ ] Submit a form with missing required fields. Does it show *which* fields and *why*, without clearing what was already entered?
- [ ] Enter invalid data (wrong format, too long, out of range). Does validation explain the constraint and how to fix it?
- [ ] Trigger a server/network error. Does the UI protect data and offer a recovery path?
- [ ] Hit a broken link or missing page. Does the 404 explain where you are, offer navigation back, and suggest search?
- [ ] Log in with wrong credentials. Does it avoid revealing which field was wrong? Does it offer password reset?
- [ ] Search with a typo or vague term. Does it suggest corrections or map to the right results?

### Try to get lost

- [ ] Land on any page from an external link. Can you tell where you are and what this page is for?
- [ ] Navigate three levels deep. Can you always tell your location and get back?
- [ ] Resize to mobile width. Does the information hierarchy survive?

### Try to do nothing

- [ ] Open a page with no data yet. Does the empty state explain why and what to do?
- [ ] Search for something that doesn't exist. Does it suggest alternatives or corrections?
- [ ] View an unavailable or expired item. Does it explain why and offer next steps?

### Try to recover

- [ ] Accidentally delete something. Can you undo it, or was the consequence clearly explained beforehand?
- [ ] Close a form mid-entry and come back. Is your work preserved, or was the risk of losing it clear?
- [ ] Lose your session or connection. Does it recover gracefully, preserve your work, and explain what happened?
- [ ] Request a forgotten password. Is the flow clear and accessible from the login form?

### Try to understand

- [ ] Read every error message. Is each one in plain language with a concrete next step?
- [ ] Read every button label. Does each one say what it does (verb + object)?
- [ ] Read every heading and label. Would a non-technical person understand them?
- [ ] Complete a multi-step flow. Do you always know which step you're on and how many remain?
- [ ] Look for help on a complex feature. Can you find contextual help without leaving your task?
- [ ] Scan the page without clicking anything. Can you tell what's clickable and what isn't? Do interactive elements look interactive?
- [ ] Try to use the interface without reading any help text or tooltips. Is it self-explanatory?

### Try to trust

- [ ] Perform a destructive action. Does the confirmation name what will be affected?
- [ ] Complete a major action. Does the system confirm what happened?
- [ ] Wait for something to load. Does the UI show progress or activity within 1 second?
- [ ] Check for sensitive data exposure. Are passwords masked, tokens hidden, and error messages free of internal details?

### Try to be sloppy

- [ ] Enter a phone number with dashes, spaces, or parentheses. Does the system accept it or reject it?
- [ ] Paste text with leading/trailing whitespace. Does the system trim it silently?
- [ ] Enter a date in a non-standard format. Does the system parse it or demand exact formatting?
- [ ] Type with inconsistent capitalization. Does it normalize gracefully?

### Try to go fast

- [ ] Use keyboard shortcuts for common actions. Are accelerators available for frequent tasks?
- [ ] Complete a frequent task. Is it faster the tenth time than the first? Are there shortcuts or remembered preferences?
- [ ] Scan a dense page. Can you find what matters without reading everything? Is there clear visual hierarchy?

## Red Flags

| If you're thinking... | Do this |
|---|---|
| "Users will figure it out" | Apply "Look like what you do" - if it needs figuring out, redesign it |
| "We'll handle that error state later" | Apply "Fail gracefully" - error states are not edge cases, design them now |
| "'Submit' is fine here" | Apply "Speak human" - every button needs verb + object |
| "The empty state is obvious" | Apply "Close the loop" - explain why it's empty and what to do |
| "Generic 'Something went wrong' is enough" | Apply "Fail gracefully" - say what happened, why, and what to do next |
| "We'll polish the error messages before launch" | Apply "Fail gracefully" - error messages are core behavior, not polish. Write them now. |

## Rationalization Table

| Excuse | Reality |
|---|---|
| "That error state is unlikely" | Plan for every failure. Unlikely states are the ones that destroy trust when they happen. |
| "Users can read the label" | Users don't read - they click and discover. Design for that. |
| "The confirmation dialog is self-explanatory" | "Are you sure?" tells the user nothing. Name what will be affected. |
| "We'll add the empty state later" | Empty states are first impressions for new users. Design them first. |
| "High fidelity first so stakeholders can see it" | Wire behavior first. Behavior must be confirmed before appearance is worth investing in. |

## Quick Reference

Maps the audit scenarios to the core principles they test - when an audit item fails, apply the listed principles to fix it.

| Audit scenario | Core principles to apply |
|---|---|
| Try to fail | Fail gracefully, Prevent before cure |
| Try to get lost | Show where they are, Be consistent |
| Try to do nothing | Close the loop, Fail gracefully |
| Try to recover | Respect autonomy, Be forgiving |
| Try to understand | Speak human, Look like what you do |
| Try to trust | Close the loop, Fail gracefully |
| Try to be sloppy | Be forgiving, Prevent before cure |
| Try to go fast | Reduce work, Be consistent |
