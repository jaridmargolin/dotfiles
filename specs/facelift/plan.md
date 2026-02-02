# Dotfiles Facelift Plan

Orchestrator for the facelift. Each phase is a separate document with concrete steps.

## Summary

The dotfiles carry technical debt from multiple generations of tooling. Core architecture (modular zsh, platform separation) is sound. Issues: unmaintained dependencies (Antigen), overlapping version managers (mise + pyenv + asdf), legacy code, broken chezmoi change detection, and inconsistent conventions.

## Phases

| Phase                                                         | Description                                                                         | Risk       |
| ------------------------------------------------------------- | ----------------------------------------------------------------------------------- | ---------- |
| [Phase 1: Safe cleanups](phase-1-safe-cleanups.md)            | Remove dead configs, version-manager overlap, Brewfile noise, shebang/comment fixes | Low        |
| [Phase 2: Chezmoi fixes](phase-2-chezmoi-fixes.md)            | Fix `run_onchange` scripts so they trigger only when source files change            | Medium     |
| [Phase 3: Antigen → Antidote](phase-3-antigen-to-antidote.md) | Replace Antigen with Antidote; static plugin list, faster startup                   | Higher     |
| [Phase 4: Refinements](phase-4-refinements.md)                | Simplify `source_scripts`, modernize java/docker modules, optional cleanups         | Low–Medium |

## Order

Execute in order (1 → 2 → 3 → 4). Phase 1 unblocks later phases (e.g. removing pyenv before Antidote migration).

## Outcomes

- Faster shell startup (static plugins, no pyenv).
- One version manager (mise), one plugin manager (Antidote).
- Chezmoi scripts run only when their inputs change.
- Less dead code, consistent shebangs and comments.
- Easier maintenance via a clear plugin list and modern tooling.
