# Shape Up for Claude Code

!> This is work in progress and being tested and iteratively improved. It has not not proven to be useless, let's phrase it like that ;)

Regardless if you work with developers or developing agents, only clarity of concepts lead to desired, on-point solutions. The [Shape Up](https://basecamp.com/shapeup) product development methodology by 37Signals is a systematic way of creating such clarity for product teams.

This project aims to adopt Shape Up for clarifying the concept for developing agents. By focusing on shaping concepts well in written form, you ship what you can maintain, not a half-assed product.


**Installation**

Add the marketplace, then install the plugin:

```
/plugin marketplace add xu-chris/Shape-Up-for-Claude-Code
/plugin install shape-up@xu-chris
```


## Problem

During longer development phases, AI starts to get sloppy, derails, and ignores `YAGNI` written in system prompts or `CLAUDE.md` files. This happens in Scrum too, where scope gets cut or features get delayed once developers realize the problem is bigger than the estimated story points or product owners do want to add a certain feature forgotten in the initial concept of an epic.

AI needs clearly written concepts to produce desired outcomes and stay on track.

## Solution

By following Shape Up, you frame the problem and shape the concept before building. You define dos and won't-dos, identify rabbit holes, and set your appetite as a signal of how much you are willing to invest. You sketch the solution in clear written form. You bet on a concept to make an informed, weighted decision. Only after all of that do you analyze the concept for the build phase.

This project assists you following this process but keeps it loose so you could also jump over some.

## Phases

Work moves through four phases before any agent touches code.

**Candidate.** An idea, a spark, a hunch. Something like "improve the dashboard" or "users are churning." Vague and unexamined. Worth investigating, not yet worth building.

**Framing.** The candidate gets examined against reality. What is the actual problem? Who has it? What is the job to be done? The output is a clear problem statement and outcome. The frame is a checkpoint: is this worth shaping?

**Shaping.** Given a clear frame, the solution gets defined. What are we actually going to build? How does it work? What are the risks and rabbit holes? Shaping produces a concept paper: a solution sketch, explicit dos and won't-dos, and all open questions resolved. The concept paper is written after shaping is done and serves as the kickoff reference.

Framing and shaping both require true domain knowledge throughout. Framing without it produces the wrong problem. Shaping without it produces a solution that cannot survive contact with reality. The two phases are iterative: shaping regularly surfaces questions that send the work back into framing. The concept paper only gets written when both the problem and the solution are clear enough to build against.

**Building.** Begins only after shaping is complete. The concept paper is the kickoff document. Work is broken into vertical scopes, end-to-end slices that can be built and demoed independently. Planning happens here, not before.

## The Three Constraints

Every shaped concept is anchored to three constraints.

**Problem.** Why does this work matter? Framing surfaces this. Without a clear problem, shaping produces the wrong solution.

**Appetite.** How much time is the team willing to spend? Appetite is a business decision set during framing. It does not move. Scope adjusts to fit.

**Scope.** What is explicitly in and explicitly out? Expressed as dos and won't-dos. Won't-dos are as important as dos.

---

*Based on the [Shape Up book](https://basecamp.com/shapeup) by Ryan Singer at Basecamp. This plugin is not affiliated with Basecamp / 37signals.*
