---
description: Use when a scopes document exists and building is ready to begin on a specific scope. Breaks a single scope into concrete tasks an agent can execute. Adds tasks to the scopes document under the relevant scope. Run once per scope, at the start of work on that scope — not for all scopes upfront.
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

### Step 3: Investigate the Relevant Code

Before sequencing tasks, read the code relevant to this scope. Search for existing implementations related to the breadboard places and affordances: data models, queries, API handlers, UI components, utilities. Understand what already exists, what patterns are established, and where this scope will extend or modify existing behavior.

Tasks derived from code reality are more precise than tasks derived from the breadboard alone. Discovering a missing dependency during execution costs more than discovering it during breakdown.

If the investigation reveals that the scope touches areas significantly more complex than the concept document suggested, surface this before proceeding. See "When the Scope Is Larger Than Expected" below.

### Step 4: Sequence by Dependency and Uncertainty

Order tasks so that each one can build on the previous. The first task in a scope should establish the foundation, the thing that other tasks depend on. If the scope has a rabbit hole identified in the concept document, the task that addresses it comes early. Do not leave unknowns until the end of a scope.

Wiring before finish. Tasks that get the mechanics working come before tasks that make things look right. A scope is not done when it looks polished. It is done when it works. Polish is the last task, not the first priority.

Where tasks are independent of each other, note this explicitly. Independent tasks can be executed in parallel by an agent. Flagging them reduces unnecessary sequencing and speeds up the scope.

### Step 5: Use Domain Language

Name tasks in the language of the concept document. If the scope is "Missed Payments Panel," tasks are "build the missed payments data query," "wire the panel to live data," "display payment retry status" — not "implement backend endpoint," "connect API," "update UI state."

Consistent language across concept, scopes, and tasks keeps the work traceable to the problem it is solving. When an agent reads a task named in domain terms, it knows what success looks like in terms the problem-owner would recognize.

### Step 6: Write Acceptance Criteria

For each task, write one to three acceptance criteria — specific, observable conditions that confirm the task is done. Criteria should describe behavior, not implementation. "The panel shows the three most recent missed payments for the current member" is a criterion. "The query returns results" is not.

If acceptance criteria are hard to write, the task is probably too vague. Restate it until the done condition is clear.

### Step 7: Propose and Confirm

Present the task list to the user before writing it to the scopes document. Walk through each task, explain the sequence, and confirm the acceptance criteria make sense to someone who understands the problem. Adjust based on feedback.

Writing unreviewed tasks into the scopes document produces a plan that the person who bet on the cycle may not recognize. The breakdown is complete when it has been confirmed, not when it has been generated.

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

While breaking down tasks, watch for scope creep. If a task seems necessary but falls outside the scope's stated boundary, or contradicts a won't-do in the concept document, flag it explicitly rather than silently including it. Either it belongs to a different scope, or it is a sign that the scope boundary needs renegotiating before work starts.

The won't-dos from shaping are still in effect. They do not become negotiable during breakdown.

## When the Scope Is Larger Than Expected

If the task list grows beyond ten tasks, or if code investigation reveals complexity that the scope description did not anticipate, stop. Do not continue generating tasks. Surface the situation: what was found, why it is more complex than expected, and what the options are.

Options include: narrowing the scope by cutting tasks not essential to the demoable outcome, splitting the scope into two, or accepting the larger scope and adjusting the cycle's remaining appetite.

This decision belongs to the person who bet on this cycle. Do not resolve it by silently expanding the task list.
