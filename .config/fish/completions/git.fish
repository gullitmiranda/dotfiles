# source shared git completions for __fish_git_needs_command and __fish_git_using_command
source $__fish_datadir/completions/git.fish

complete -f -c git -n '__fish_git_needs_command' -a nuke -d 'Remove branch remote and locale'
complete -f -c git -n '__fish_git_using_command nuke; and not __fish_git_branch_for_remote' -a '(__fish_git_remotes)' -d 'Remote alias'
complete -f -c git -n '__fish_git_using_command nuke; and __fish_git_branch_for_remote' -a '(__fish_git_branch_for_remote)' -d 'Branch'

complete -f -c git -n '__fish_git_needs_command' -a nukef -d 'Remove branch remote and force delete locale'
complete -f -c git -n '__fish_git_using_command nukef; and not __fish_git_branch_for_remote' -a '(__fish_git_remotes)' -d 'Remote alias'
complete -f -c git -n '__fish_git_using_command nukef; and __fish_git_branch_for_remote' -a '(__fish_git_branch_for_remote)' -d 'Branch'
# TODO options
