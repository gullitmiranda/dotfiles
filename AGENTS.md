# Agent Instructions — dotfiles

## Project context

This is a **personal dotfiles repository**. There is no team, no PR review process,
and no deployment pipeline. The goal is to keep the dev environment reproducible
and evolving quickly.

## Git workflow

- **Direct commits to `main` are allowed and preferred** for small, punctual changes
  (config tweaks, alias updates, tool additions, etc.)
- **Create a branch only when working on something larger** — e.g. a multi-step
  refactor, a new tool integration, or an experimental change that might be reverted.
- Use [Conventional Commits](https://www.conventionalcommits.org/) style for all
  commit messages.
- Never push with `--force`; use `--force-with-lease` if needed.
