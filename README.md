# Shape Up for Claude Code

> Work in progress — tested and iteratively improved.

Regardless if you work with developers or developing agents, only clarity of concepts leads to desired, on-point solutions. The [Shape Up](https://basecamp.com/shapeup) product development methodology by 37Signals is a systematic way of creating such clarity for product teams.

This project adopts Shape Up for clarifying concepts before building with agents. By focusing on shaping concepts well in written form, you ship what you can maintain, not a half-assed product.


## How this differs from similar tools

**vs. Ryan Singer's [shaping-skills](https://github.com/rjs/shaping-skills):** Singer's skills cover the shaping phase in depth - breadboarding, fit checks, affordance tables. This plugin takes those mechanics and embeds them in the full Shape Up lifecycle: framing comes first, betting gates the build, kickoff maps the work into slices, and scope breakdown drives execution one slice at a time. Singer's skills are the sharpest part of the shaping phase here; this plugin wraps the rest of the methodology around them.

**vs. [superpowers](https://github.com/obra/superpowers):** Superpowers is a development workflow plugin - it helps you implement once you know what to build (TDD, subagent-driven development, planning, code review). This plugin answers the earlier question: what should we build, and why? The two are complementary. Shape Up handles the pre-build phases; superpowers handles execution. The scope skill explicitly hands off to superpowers when both are installed.

**Installation**

Add the marketplace, then install the plugin:

```
/plugin marketplace add xu-chris/Shape-Up-for-Claude-Code
/plugin install shape-up@xu-chris
```

**Skills and commands**

| Command | What it does |
|---|---|
| `/shape-up:frame` | Examine a candidate idea and produce a clear problem statement |
| `/shape-up:shape` | Define the solution: elements, breadboard, rabbit holes, dos and won't-dos |
| `/shape-up:bet` | Make the deliberate decision to commit build time to a shaped concept |
| `/shape-up:kickoff` | Tour the concept with the team and map it into vertical scopes |
| `/shape-up:scope` | Break one scope into concrete tasks with acceptance criteria |
| `/shape-up:ux-design` | Design UI behavior, write user-facing copy, audit interfaces for usability |
| `/shape-up:breadboarding` | Surface UI and code affordances, run fit check, generate wiring diagram |
| `/shape-up:breadboard-reflection` | Sync a breadboard to implementation and detect design smells |
| `/shape-up:dag` | Generate a dependency graph for scopes or tasks |


## Hooks

**Ripple check** fires automatically whenever Claude edits a shaping document. It injects a reminder into Claude's context before it continues, prompting it to keep downstream documents consistent:

- Changed a breadboard diagram? Update the 4 affordance tables in `shape.md` first, then re-render the Mermaid diagram.
- Changed requirements (R) in `shape.md`? Update the Fit Check; update `slices.md` if the winning shape changes.
- Changed shape parts (S) in `shape.md`? Update the Fit Check.
- Changed `slices.md`? Update the affected `S#-plan.md` files.
- Changed an `S#-plan.md`? Update the slice summary in `slices.md` if scope changed.

The hook only fires on documents that carry `shaping: true` in the first five lines of frontmatter. The skills write this automatically - `frame.md`, `shape.md`, `slices.md`, and `S#-plan.md` all get the flag. To opt a custom document in, add `shaping: true` to its YAML frontmatter.

## Problem

During longer development phases, AI starts to get sloppy, derails, and ignores `YAGNI` written in system prompts or `CLAUDE.md` files. This happens in Scrum too, where scope gets cut or features get delayed once developers realize the problem is bigger than the estimated story points or product owners want to add a feature forgotten in the initial concept of an epic.

AI needs clearly written concepts to produce desired outcomes and stay on track.

## Solution

By following Shape Up, you frame the problem and shape the concept before building. You define dos and won't-dos, identify rabbit holes, and set your appetite as a signal of how much you are willing to invest. You sketch the solution in clear written form. You bet on a concept to make an informed, weighted decision. Only after all of that do you kick off and break the work into scopes.

This project assists you in following this process but keeps it loose enough to jump over phases where they don't apply.

## Phases

Work moves through five phases before any agent touches code.

**Candidate.** An idea, a spark, a hunch. Something like "improve the dashboard" or "users are churning." Vague and unexamined. Worth investigating, not yet worth building.

**Framing.** The candidate gets examined against reality. What is the actual problem? Who has it? What is the job to be done? The output is a clear problem statement and outcome. The frame is a checkpoint: is this worth shaping?

**Shaping.** Given a clear frame, the solution gets defined. What are we actually going to build? How does it work? What are the risks and rabbit holes? Shaping produces a concept paper: a solution sketch, explicit dos and won't-dos, and all open questions resolved. The concept paper is written after shaping is done and serves as the kickoff reference.

Framing and shaping both require true domain knowledge throughout. Framing without it produces the wrong problem. Shaping without it produces a solution that cannot survive contact with reality. The two phases are iterative: shaping regularly surfaces questions that send the work back into framing. The concept paper only gets written when both the problem and the solution are clear enough to build against.

**Betting.** A deliberate, weighted decision to commit one cycle of build time to a shaped concept. The bias is toward no. A fuzzy shape produces a bad bet. A no-bet returns the concept to framing or shaping, not a backlog.

**Building.** Begins only after betting is complete. The concept paper is the kickoff document. Work is broken into vertical scopes — end-to-end slices that can be built and demoed independently. Scope breakdown happens one scope at a time, at the start of that scope, not all upfront.

## The Three Constraints

Every shaped concept is anchored to three constraints.

**Problem.** Why does this work matter? Framing surfaces this. Without a clear problem, shaping produces the wrong solution.

**Appetite.** How much time is the team willing to spend? Appetite is a business decision set during framing. It does not move. Scope adjusts to fit.

**Scope.** What is explicitly in and explicitly out? Expressed as dos and won't-dos. Won't-dos are as important as dos.

---

## Sources and prior art

- [Shape Up](https://basecamp.com/shapeup) - Ryan Singer's original book. The methodology this plugin encodes.
- [rjs/shaping-skills](https://github.com/rjs/shaping-skills) - Ryan Singer's own Claude Code skills for shaping. The breadboarding vocabulary (P#/U#/N#/S#), Wires Out vs Returns To, the Blocking Test, binary fit checks, and the ripple-check hook all originate here.
- [obra/superpowers](https://github.com/obra/superpowers) - Jesse Vincent's Claude Code plugin. The plugin architecture, skill structure, hook patterns, and test infrastructure are modelled on superpowers.
