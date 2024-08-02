# clean fish greeting
set -U fish_greeting ""

set -x LC_ALL en_US.UTF-8

set -gx EDITOR vim

# base cdpath's
set -gx CDPATH $HOME
# add Code and subdirs to cdpath
set -gx CDPATH $HOME/Code/* $HOME/Code $CDPATH
# priority local dir cdpath's
set -gx CDPATH . $CDPATH

contains /opt/homebrew/sbin $PATH; or fish_add_path /opt/homebrew/sbin
contains /opt/homebrew/bin $PATH; or fish_add_path /opt/homebrew/bin
contains "$HOME/dotfiles/bin" $PATH; or fish_add_path $HOME/dotfiles/bin
contains "$HOME/.local/bin" $PATH; or fish_add_path $HOME/.local/bin

# Fix to prevent asdf shims override system binaries
# --- Use a link to ~/.local/bin/ instead
# --- ex: ln -s /usr/bin/which ~/.local/bin/
# set -xg PATH /usr/local/bin /usr/bin /bin /usr/sbin /sbin $PATH

# # override native coreutils with gnu coreutils
# set GNUBIN (brew --prefix)/opt/coreutils/libexec/gnubin
# contains $GNUBIN $PATH; or set -gx PATH $GNUBIN PATH


# # https://direnv.net/
# NOTE: when installed using brew, already loaded
# if type -q direnv
#     direnv hook fish | source

#     # Hook direnv into your shell (using asdf).
#     # https://github.com/asdf-community/asdf-direnv
#     # asdf exec direnv hook fish | source

#     # # A shortcut for asdf managed direnv.
#     # function direnv
#     #   asdf exec direnv "$argv"
#     # end
# end

#
if status is-interactive
    # echo "Activating mise in interactive shell"
    mise activate fish | source
    mise hook-env -s fish | source
else
    # echo "Activating mise in non-interactive shell"
    mise activate fish --shims | source
end

# check if Warp is the current terminal

if test "$TERM_PROGRAM" != WarpTerminal
    # https://starship.rs/
    starship init fish | source
end

# #----
# # Theme configs

# # https://github.com/oh-my-fish/oh-my-fish/blob/master/docs/Themes.md#configuration
# set -g theme_title_display_path yes
# set -g theme_title_use_abbreviated_path no
# set -g theme_date_format "+%a %H:%M:%S"
# set -g theme_display_docker_machine no
# set -g theme_newline_cursor yes

# with custom functions
# set -g theme_newline_chart "↪"
# set -g theme_newline_chart "$right_arrow_glyph"

#----
# Aliases

source (dirname (status filename))/alias/git.fish

alias datestamp='date +%Y%m%d-%H%M%S'
alias dateiso='date +%Y-%m-%dT%H:%M:%S%z'
# like iso, but work well with file path/name
alias datefiso='date +%Y%m%dT%H%M%S%z'

#----
# Setup tools (also override some aliases)

if type -q eza
    alias ls='eza -G --color auto --icons -a -s type'
    alias ll='eza -l --color always --icons -a -s type'
    alias la='eza --color auto -abghHliS'
end

if type -q bat
    alias _cat=(which cat)
    alias cat='bat -pp --theme="Dracula"'
end

# if type -q fzf
#     # https://remysharp.com/2018/08/23/cli-improved#fzf--ctrlr
#     alias preview="fzf --preview 'bat --color \"always\" {}'"
#     # add support for ctrl+o to open selected file in VS Code
#     # set -gx FZF_DEFAULT_OPTS "--bind='ctrl-o:execute(code {})+abort'"
#     # set -gx FZF_COMPLETE 1
# end

# Fly through your shell history. Great Scott!
# https://github.com/cantino/mcfly
if type -q mcfly
    mcfly init fish | source
end

if type -q ncdu
    alias _du=(which du)
    alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"
end

if type -q prettyping
    alias _ping=(which ping)
    alias ping='prettyping --nolegend'
end

alias brew-list-tree="brew leaves | xargs brew deps --include-build --tree"

if type -q tldr
    # alias _man=(which man)
    # alias man='tldr'
    alias human='tldr'
end

switch (uname)
    case Darwin
        function sourcetree -a repo
            # when repo is not defined use "."
            set -l default_repo (git rev-parse --show-cdup)
            set -q $repo; and set -l repo "$default_repo"
            open -a SourceTree "$repo"
        end
        alias st='sourcetree'

        alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
        alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
end

function agrep -a str -d "grep in aliases"
    alias | grep "$str"
end

function hgrep -a str -d "grep in history"
    builtin history | grep -v grep | grep "$str"
end

function egrep -a str -d "grep in env variables"
    env | grep "$str"
end

function pgrep -a str -d "grep in all running process"
    command ps aux | grep -v grep | grep "$str"
end

# https://github.com/fish-shell/fish-shell/issues/1156#issuecomment-371493891
function fishcognito
    env fish_history='' fishcognito_active='true' fish
end

#----
# Dev

# Elixir/Erlang config
######################
set -gx ERL_AFLAGS "-kernel shell_history enabled"

# Finder-launched applications missing PATH env
# - https://apple.stackexchange.com/questions/51677/how-to-set-path-for-finder-launched-applications/198282#198282
# - https://community.atlassian.com/t5/Bitbucket-questions/SourceTree-Hook-failing-because-paths-don-t-seem-to-be-set/qaq-p/274792
switch (uname)
    case Darwin
        launchctl setenv PATH (bash -c 'echo $PATH')
end
