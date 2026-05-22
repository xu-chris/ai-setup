---
description: Use when a scopes document exists and building is ready to begin on a specific scope. Breaks a single scope into concrete tasks an agent can execute. Adds tasks to the scopes document under the relevant scope. Run once per scope, at the start of work on that scope. Do not run for all scopes upfront.
---

# Scope Breakdown

Scope breakdown is the work of translating one scope from the scopes document into a sequence of concrete tasks. It happens at the start of work on that scope, not all at once before building begins. Breaking down all scopes upfront produces plans that are wrong by the time you reach them.

One scope at a time. Work through it. Learn. Then break down the next.

Before starting: read `docs/concepts/[name].scopes.md` and identify the scope to break down. Also read `docs/concepts/[name].md` to have the full concept (elements, breadboard, rabbit holes, and won't-dos) in view. Tasks must stay within the scope boundary and respect the won't-dos.

## What a Task Is

A task is a concrete action that contributes to the scope's demoable outcome. It is specific enough that an agent can pick it up and execute without asking what it means. It is not a layer ("implement the backend"), not a vague goal ("make it work"), and not a user story.

A well-formed task answers three things: what to do, how to know it is done, and what must exist before it can start.

Aim for 3 to 10 tasks per scope. Fewer than three usually means the scope is underdeveloped. More than ten usually means the tasks are too granular or the scope is too large.

## How to Break Down a Scope

### Step 1: Understand What the Scope Delivers

Read the scope entry in the scopes document. The scope has a name, a description of what it delivers, and an uncertainty level. That description is the target. Every task must contribute to reaching it.

If the scope description is vague, clarify it with the user before breaking it down. A vague scope produces tasks that point in different directions.

### Step 2: Work from the Breadboard

The breadboard in the concept document shows the places, affordances, and connections relevant to this scope. Walk through the breadboard sections that belong to this scope and ask: what has to be built for this flow to work end to end?

This produces a rough list of what needs to exist. Do not organize it by layer yet. Keep it as a flat list of things that need to happen.

Once the list exists, check it for vertical coverage. A vertical slice reaches through all layers needed to produce a demoable behavior: from the data or logic that drives it, through whatever connects them, to the interface the user touches. If every item in your list is backend work, or every item is UI work, you have organized by layer. Regroup around behavior: what has to come together, across all layers, to make this flow work and be demoable?

### Step 3: Investigate the Relevant Code

Before sequencing tasks, read the code relevant to this scope. Search for existing implementations related to the breadboard places and affordances: data models, queries, API handlers, UI components, utilities. Understand what already exists, what patterns are established, and where this scope will extend or modify existing behavior.

Tasks derived from code reality are more precise than tasks derived from the breadboard alone. Discovering a missing dependency during execution costs more than discovering it during breakdown.

If the investigation reveals complexity significantly beyond what the concept document suggested, do not continue. See "When the Scope Is Larger Than Expected" below.

If investigation surfaces an unpatched rabbit hole — a technical complexity that could significantly expand the scope and was not addressed during shaping — do not continue with task breakdown. State clearly what was found: where it is in the code, why it is more complex than expected, and what the risk is if it is ignored. Get a decision before proceeding. The options are: patch it with a constraint that keeps the scope viable, narrow the scope to avoid it, or return the concept to shaping with the new understanding. Continuing without a decision turns a shaping gap into a build failure.

### Step 4: Sequence by Dependency and Uncertainty

Order tasks so that each one can build on the previous. The first task in a scope should establish the foundation the other tasks depend on. If the scope has a rabbit hole identified in the concept document, the task that addresses it comes early. Do not leave unknowns until the end of a scope.

Wiring before finish. Tasks that get the mechanics working come before tasks that make things look right. A scope is not done when it looks polished. It is done when it works. Polish is the last task, not the first priority.

Where tasks are independent, flag them explicitly: they can run in parallel and do not need to wait on each other.

### Step 5: Use Domain Language

Name tasks in the language of the concept document. If the scope is "Missed Payments Panel," tasks are "build the missed payments data query," "wire the panel to live data," "display payment retry status" — not "implement backend endpoint," "connect API," "update UI state."

Consistent language across concept, scopes, and tasks keeps the work traceable to the problem it is solving. When an agent reads a task named in domain terms, it knows what success looks like in terms the problem-owner would recognize.

### Step 6: Write Acceptance Criteria

For each task, write one to three acceptance criteria: specific, observable conditions that confirm the task is done. Criteria must describe behavior, not implementation. "The panel shows the three most recent missed payments for the current member" is a criterion. "The query returns results" is not.

If acceptance criteria are hard to write, the task is too vague. Restate it until the done condition is clear.

### Step 7: Propose and Confirm

Present the task list to the user before writing it to the scopes document. Walk through each task, explain the sequence, and confirm the acceptance criteria make sense to someone who understands the problem. Adjust based on feedback.

The breakdown is complete when it has been confirmed, not when it has been generated.

## Output

Add tasks inline to the relevant scope in `docs/concepts/[name].scopes.md`. Use this structure for each task:

```markdown
#### [Task Name]
[One sentence describing what to do.]

**Done when:**
- [Specific, observable condition]
- [Specific, observable condition]

**Depends on:** [task name] or none
**Can run in parallel with:** [task name] or none
```

After adding all tasks, update the scope's status in the scopes document from `building` to `in progress` to signal that work on this scope has been planned and can begin.

## Staying Inside the Scope

While breaking down tasks, watch for scope creep. If a task seems necessary but falls outside the scope's stated boundary, or contradicts a won't-do in the concept document, flag it explicitly rather than silently including it. Either it belongs to a different scope, or the scope boundary needs renegotiating before work starts.

The won't-dos from shaping prevent scope expansion. They do not prevent scope tightening. If investigation reveals the demoable outcome can be reached more cleanly by cutting something the scope included, that narrowing is valid. Surface it explicitly: state what you are cutting and why, and confirm it before writing the tasks. Silently shrinking the scope is as much of a problem as silently expanding it.

## When the Scope Is Larger Than Expected

If the task list grows beyond ten tasks, or if code investigation reveals complexity the scope description did not anticipate, stop. Do not continue generating tasks. Surface the situation: what was found, why it is more complex than expected, and what the options are.

Options: narrow the scope by cutting tasks not essential to the demoable outcome, split the scope into two, or accept the larger scope and adjust the cycle's remaining appetite. This decision belongs to the person who bet on this cycle. Do not resolve it by silently expanding the task list.
