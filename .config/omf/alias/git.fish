function git_prompt_short_sha -d "get git commit SHA"
  set -l SHA (command git rev-parse --short HEAD 2> /dev/null); and echo "$SHA"
end

function git_current_branch
  set -l ref (command git symbolic-ref --quiet HEAD 2> /dev/null)
  if [ $status != 0 ]
    [ $status == 128 ] and return # no git repo.
    set -l ref (command git rev-parse --short HEAD 2> /dev/null) or return
  end
  echo $ref | sed "s/refs\/heads\///"
end

abbr -a branch   git_current_branch
abbr -a commit   git_prompt_short_sha

abbr -a gc       git commit -v
abbr -a gcm      git commit -v -m
abbr -a gcan     git commit -v -s --no-edit --amend

abbr -a gfa      git fetch --all
abbr -a gfap     git fetch --all --prune
abbr -a gfp      git fetch --prune
abbr -a gfpo     git fetch --prune origin
abbr -a gmn      git merge --no-ff

abbr -a grb       git rebase

# git push
abbr -a gpc      'git push origin (git_current_branch)'
abbr -a gpct     'git push -v --tags origin refs/heads/(git_current_branch):refs/heads/(git_current_branch)'
abbr -a gpcta    'git remote | xargs -I % bash -c "git push -v --tags % refs/heads/(git_current_branch):refs/heads/(git_current_branch)"'

abbr -a glu      'git pull upstream (git_current_branch)'
abbr -a gtm      git tag -a -m  -f
abbr -a gsti     git stash save -p

alias gclean='git reset --hard and git clean -df'
alias gcleanx='git reset --hard and git clean -dfx'
