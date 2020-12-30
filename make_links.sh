#!/usr/bin/env bash

# Make sure globstar (glob using **) is enabled
shopt -s globstar

# Make Defaults Links

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd | head)"

LN_OPTS=${LN_OPTS:-"-s"}

if [ ! -d "${DOTFILES_DIR}" ]; then
  echo "not found DOTFILES_DIR="$DOTFILES_DIR""
  exit 1
fi

cat <<EOF
==> Link dotfiles directory
  DOTFILES_DIR=$DOTFILES_DIR
  HOME=$HOME
EOF

_cd() {
  local _cmd=(cd $@)

  echo "+ ${_cmd[@]}"
  ${_cmd[@]}
}

abspath() {
  local p=$1

  if [[ ! "$p" =~ ^(\.|\/) ]]; then
    p="./$p"
  fi

  cd "$(dirname "$p")"
  printf "%s/%s\n" "$(pwd)" "$(basename "$p")"
  cd "$OLDPWD"
}

build_link() {
  local origin=$1
  local target=${2:-.}

  echo "+ ln $LN_OPTS "$origin" "$target""
  ln $LN_OPTS "$origin" "$target"
}

# Usage:
#   $ link_files_from origin target
#
# Or with find filters:
#   $ FIND_OPTS="-type f" link_files_from origin target
link_files_from() {
  local origin_dir=$1
  local target=${2:-.}

  echo -e "\n[link_files_from] Link all files from \"$origin_dir\" to \"${target}\""

  origin_dir="$(abspath "$origin_dir")"
  target="$(abspath "$target")"

  if [ ! -d "$origin_dir" ]; then
    echo "not found directory $origin_dir"
  else
    local prev_cwd=$(pwd)

    _cd "$target"

    while IFS= read -r -d '' file; do
      build_link "$file"
    done < <(find "$origin_dir" -depth 1 -print0)

    _cd $prev_cwd
  fi
}

cd "$HOME"

dotdir=$(basename "$DOTFILES_DIR")

if [ "$DOTFILES_DIR" != "$HOME/$dotdir" ]; then
  build_link "$DOTFILES_DIR"
fi

# $HOME files
link_files_from "$dotdir/home"
build_link ".gitignore_global" ".gitignore"

# $HOME/.config
mkdir -p ".config"
link_files_from "$dotdir/.config" ".config"

customs_dir="./$dotdir/customs"
if [ -d "$customs_dir" ]; then
  if [ -d "$customs_dir/home" ]; then
    link_files_from "$customs_dir/home"
  fi
  if [ -d "$customs_dir/.config" ]; then
    link_files_from "$customs_dir/.config" ".config"
  fi
fi
