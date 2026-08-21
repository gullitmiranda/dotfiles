# Personal Instructions

## Personal Policy Bootstrap

- Before creating, editing, or publishing a durable or publishable artifact, load and follow the `user-preferences` skill. Artifacts include source code, code comments, documentation, plans, commit messages, pull requests, issues, review comments, and release notes.
- If `user-preferences` cannot be loaded, do not create, edit, or publish an artifact. Explain the blocker instead.
- Do not create, edit, or publish an artifact in a language other than English unless the user, a repository instruction, or an applicable task-specific skill explicitly requires another language.

## Zed Skills

- Create Zed project skills in `.agents/skills/`. Zed discovers project skills only from that directory.

## File edits

Always use the harness's native file tools (`edit_file`, `write_file`, `save_file`, `move_path`, `copy_path`, `delete_path`, `create_directory`) to create, modify, or move files inside project roots. Do not edit files via shell (`sed -i`, `python3 << EOF`, heredocs, `cat >`, `mv`, `cp`).

Shell file edits are only acceptable when the target file is outside all project roots (e.g. worktrees not added to the workspace, `~/.agents/skills/`). In that case, state explicitly that the file is outside the project roots before editing.
