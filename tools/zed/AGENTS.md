# Personal Instructions

## File edits

Always use the harness's native file tools (`edit_file`, `write_file`, `save_file`, `move_path`, `copy_path`, `delete_path`, `create_directory`) to create, modify, or move files inside project roots. Do not edit files via shell (`sed -i`, `python3 << EOF`, heredocs, `cat >`, `mv`, `cp`).

Shell file edits are only acceptable when the target file is outside all project roots (e.g. worktrees not added to the workspace, `~/.agents/skills/`). In that case, state explicitly that the file is outside the project roots before editing.
