---
name: breadboard-reflection
description: Use after implementation when the breadboard in shape.md may have drifted from the actual code, or when reviewing the design quality of a built system.
---

# Breadboard Reflection

A breadboard should explain the mechanism by which the system produces its effects. The wiring is the explanation. When the breadboard doesn't match the code, or when the wiring doesn't tell a coherent story, this skill fixes both.

Work in two phases: **SEE, then REFLECT.** Always in this order.

## Phase 1: SEE - Sync the Breadboard to the Code

The code is ground truth. Before judging the design, make the breadboard accurate.

1. Read the implementation code - find the relevant source files. Do not rely on the breadboard's current description.
2. Walk the code seams using the checklist below.
3. Update `shape.md` to match what IS - add missing nodes, fix wrong wiring, remove stale affordances.

Do not fix design problems in Phase 1. The goal is an accurate picture, even if the design has issues.

### What to Look For

**Module boundaries are seams.** What crosses a module boundary is a public interface. If a module exists (`llm.py` separate from `app.py`), the breadboard should not reach through it to grab internals. The module's public function is the affordance; what it calls internally is behind the boundary.

**Module-level definitions are data stores.** Constants, configs, and templates at the top of a module are static state that shapes behavior. If code reads them to produce effects, they belong in the breadboard. They are easy to miss because they don't change at runtime.

**Function signatures show what crosses boundaries.** When a function's return type differs from what its downstream dependency returns, a transformation is happening. That transformation is work the breadboard should account for.

**Trace the full call chain, not just endpoints.** Walk every function in the chain. Each one exists for a reason - orchestration, state management, data transformation. Functions that do real work (not just forwarding) are affordances. Skipping intermediate functions hides the explanation.

**State that co-accesses across functions suggests a Place.** Which functions and state are used together but don't touch other parts of the system? Co-access patterns reveal candidate places, not just UI layout.

## Phase 2: REFLECT - Find and Fix Design Smells

Now that the breadboard is accurate, inspect it for design problems.

1. Trace a user story through the wiring. Does the path tell a coherent story?
2. Run the Naming Test on every affordance.
3. Check for hidden data stores - static config and constants that shape behavior belong in the breadboard.
4. Fix smells - split, merge, rename, or rewire affordances. Update tables first, then the diagram.

### The Naming Test

For each affordance:

1. Who is the caller?
2. What is this affordance's own direct effect - not its downstream chain?
3. Can you name it with one idiomatic verb?

```
One verb covers it                             → boundary is correct
Need "or" between two verbs                    → likely two affordances bundled together
Name doesn't feel idiomatic                    → boundary is wrong
Name describes the downstream chain, not this step → you're naming the chain
```

Name what THIS step does, not the downstream cascade. An orchestrator that calls validate, find, extract, and insert should not be named `add_locale` - adding is the chain's effect, not this step's. Its own effect is dispatching; name it accordingly.

### Splitting Affordances

When the naming test reveals a bundled affordance:

1. Split in the code first - extract distinct operations into separate functions.
2. Update the tables - add rows for new affordances with proper IDs, Wires Out, and Returns To.
3. Update the diagram to match the tables.

Never split only in the diagram. If it is not a named function in the code and a row in the table, it is not a real affordance.

## Smells

| If you see this | Do this |
|---|---|
| You know the system does something but the breadboard doesn't show how | Add the missing affordances - the explanation is hidden |
| A node in the diagram has no row in the affordance tables | It is decoration - add a table row or remove the node |
| An affordance resists the naming test (need "or" to name it) | Split it into two affordances |
| A display UI affordance has no data source wiring in | Add the N# or S# that feeds it |
| An N# has no Wires Out and no Returns To | Dead code or missing wiring - investigate |
| The breadboard shows A → B but the code shows C → B | Phase 1 missed this - go back and fix the wiring |

## Verification

After any changes:

1. Re-trace user stories through the updated wiring - does each path tell a coherent story?
2. Confirm every Wires Out target exists in the tables.
3. Confirm every Returns To source has a corresponding Wires Out from its caller.
4. Confirm solid lines are Wires Out, dashed lines are Returns To.

## Quick Reference

| Phase | Activity | Gate |
|---|---|---|
| 1. SEE | Read code, update breadboard to match reality | Breadboard reflects what IS |
| 2. REFLECT | Naming test, trace user stories, fix smells | Wiring tells a coherent story with no hidden steps |
