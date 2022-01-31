set -q FZF_TMUX_HEIGHT; or set -U FZF_TMUX_HEIGHT "40%"
set -q FZF_DEFAULT_OPTS; or set -U FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT"
set -q FZF_LEGACY_KEYBINDINGS; or set -U FZF_LEGACY_KEYBINDINGS 1
set -q FZF_DISABLE_KEYBINDINGS; or set -U FZF_DISABLE_KEYBINDINGS 0
set -q FZF_PREVIEW_FILE_CMD; or set -U FZF_PREVIEW_FILE_CMD "head -n 10"
set -q FZF_PREVIEW_DIR_CMD; or set -U FZF_PREVIEW_DIR_CMD "ls"

if test "$FZF_DISABLE_KEYBINDINGS" -ne 1
    # https://github.com/jethrokuan/fzf#quickstart
    # Legacy       | New Keybindings    | Remarks
    # ------------------------------------------------
    # Ctrl-t       | Ctrl-o             | Find a file.
    # Ctrl-r       | Ctrl-r             | Search through command history.
    # Alt-c        | Alt-c              | cd into sub-directories (recursively searched).
    # Alt-Shift    | Alt-Shift-c        | cd into sub-directories, including hidden ones.
    # Ctrl-o       | Alt-o              | Open a file/dir using default editor ($EDITOR)
    # Ctrl-g       | Alt-Shift-o        | Open a file/dir using xdg-open or open command

    if test "$FZF_LEGACY_KEYBINDINGS" -eq 1
        bind \ct '__fzf_find_file'
        bind \cr '__fzf_reverse_isearch'
        bind \ec '__fzf_cd'
        bind \eC '__fzf_cd --hidden'
        bind \cg '__fzf_open'
        bind \co '__fzf_open --editor'

        if bind -M insert >/dev/null 2>/dev/null
            bind -M insert \ct '__fzf_find_file'
            bind -M insert \cr '__fzf_reverse_isearch'
            bind -M insert \ec '__fzf_cd'
            bind -M insert \eC '__fzf_cd --hidden'
            bind -M insert \cg '__fzf_open'
            bind -M insert \co '__fzf_open --editor'
        end
    else
        bind \co '__fzf_find_file'
        bind \cr '__fzf_reverse_isearch'
        bind \ec '__fzf_cd'
        bind \eC '__fzf_cd --hidden'
        bind \eO '__fzf_open'
        bind \eo '__fzf_open --editor'

        if bind -M insert >/dev/null 2>/dev/null
            bind -M insert \co '__fzf_find_file'
            bind -M insert \cr '__fzf_reverse_isearch'
            bind -M insert \ec '__fzf_cd'
            bind -M insert \eC '__fzf_cd --hidden'
            bind -M insert \eO '__fzf_open'
            bind -M insert \eo '__fzf_open --editor'
        end
    end

    if not bind --user \t >/dev/null 2>/dev/null
        if set -q FZF_COMPLETE
            bind \t '__fzf_complete'
            if bind -M insert >/dev/null 2>/dev/null
                bind -M insert \t '__fzf_complete'
            end
        end
    end
end

function _fzf_uninstall -e fzf_uninstall
    bind --user \
        | string replace --filter --regex -- "bind (.+)( '?__fzf.*)" 'bind -e $1' \
        | source

    set --names \
        | string replace --filter --regex '(^FZF)' 'set --erase $1' \
        | source

    functions --erase _fzf_uninstall
end