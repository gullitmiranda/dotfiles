# clean fish greeting
set fish_greeting

set -x LC_ALL en_US.UTF-8

set -U EDITOR vim

# base cdpath's
set -gx CDPATH $HOME $HOME/Works
# yube cdpath's
set -gx CDPATH $HOME/Works/yube $CDPATH
# priority local dir cdpath's
set -gx CDPATH . $CDPATH

contains /opt $PATH; or set -gx PATH /opt $PATH
contains $HOME/dotfiles/bin $PATH; or set -gx PATH $HOME/dotfiles/bin $PATH
contains $HOME/.local/bin/ $PATH; or set -gx PATH $HOME/.local/bin/ $PATH

# Fix to prevent asdf shims override system binaries
# --- Use a link to ~/.local/bin/ instead
# --- ex: ln -s /usr/bin/which ~/.local/bin/
# set -xg PATH /usr/local/bin /usr/bin /bin /usr/sbin /sbin $PATH

# # override native coreutils with gnu coreutils
# set GNUBIN (brew --prefix)/opt/coreutils/libexec/gnubin
# contains $GNUBIN $PATH; or set -gx PATH $GNUBIN PATH

if test $TERM_PROGRAM = "iTerm.app"
    # Install shell integrations
    source ~/dotfiles/.iterm2_shell_integration.fish
end

# https://direnv.net/
if type -q direnv
    # direnv hook fish | source

    # Hook direnv into your shell (using asdf).
    # https://github.com/asdf-community/asdf-direnv
    asdf exec direnv hook fish | source

    # # A shortcut for asdf managed direnv.
    # function direnv
    #   asdf exec direnv "$argv"
    # end
end

# https://starship.rs/
starship init fish | source

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

if type -q exa
    alias ls='exa -G --color auto --icons -a -s type'
    alias ll='exa -l --color always --icons -a -s type'
    alias la='exa --color auto -abghHliS'
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
# DevOps

# gcloud
if type -q gcloud
    set gcloud_bin_dir (dirname (which gcloud))
    contains $gcloud_bin_dir $PATH; or set -gx PATH $gcloud_bin_dir $PATH
end

test -z "$KREW_ROOT"; and set KREW_ROOT "$HOME/.krew"
if test -d "$KREW_ROOT"
    set -gx KREW_ROOT $KREW_ROOT
    contains "$KREW_ROOT/bin" $PATH; or set -gx PATH "$KREW_ROOT/bin" $PATH
end

#----
# Dev

# Android
set -gx ANDROID_HOME $HOME/Library/Android/sdk

# Elixir/Erlang config
set -gx ERL_AFLAGS "-kernel shell_history enabled"

# ## NodeJS
set -xg NODE_ENV development
set -xg BABEL_ENV $NODE_ENV

if type -q yarn
    set yarn_bin (yarn global bin)
    contains $yarn_bin $PATH; or set -gx PATH $PATH $yarn_bin
end

if test -d ./node_modules/.bin
    contains ./node_modules/.bin $PATH; or set -gx PATH ./node_modules/.bin $PATH
end

# Rust
# if test -d "$HOME/.cargo/bin"
#   set -gx PATH $PATH $HOME/.cargo/bin
# end

# Python
if test -d "$HOME/Library/Python/3.7/bin"
    contains $HOME/Library/Python/3.7/bin $PATH; or set -gx PATH $PATH $HOME/Library/Python/3.7/bin
end

# Finder-launched applications missing PATH env
# - https://apple.stackexchange.com/questions/51677/how-to-set-path-for-finder-launched-applications/198282#198282
# - https://community.atlassian.com/t5/Bitbucket-questions/SourceTree-Hook-failing-because-paths-don-t-seem-to-be-set/qaq-p/274792
switch (uname)
    case Darwin
        launchctl setenv PATH (bash -c 'echo $PATH')
end
