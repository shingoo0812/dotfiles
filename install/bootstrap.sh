#!/usr/bin/env bash
#
# bootstrap installs things.
#


cd "$(dirname "$0")/.."

DOTFILES=$(pwd -P)

set -e

echo ''
echo "$DOTFILES"

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

link_file() {
  local src=$1 dst=$2

  local overwrite=
  local backup=
  local skip=
  local action=
  echo "link start"
  echo "src: $src, dst: $dst"
  if [ -f "$dst" ] || [ -d "$dst" ] || [ -L "$dst" ]
  then
    
    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      # ignoring exit 1 from readlink in case where file already exists
      # shellcheck disable=SC2155
      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then
        skip=true;
      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        \r[O]verwrite, [B]ackup, [S]kip, [A]ll?"
        read -n 1 action < /dev/tty

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac
      fi
    fi

    overwrit=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi
  # check
  echo "$1 $2"
  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

install_dotfiles () {
  info 'installing dotfiles'
  
  local overwrite_all=false backup_all=false skip_all=false

  find -H "$DOTFILES" -maxdepth 5 -name 'links.prop' -not -path '*.git*' | while read linkfile
  do
    cat "$linkfile" | while read line
    do
        local src dst dir
        src=$(eval echo "$line" | cut -d '=' -f 1)
        dst=$(eval echo "$line" | cut -d '=' -f 2)
        dir=$(dirname $dst)

        mkdir -p "$dir"
        link_file "$src" "$dst"
    done
  done
}

create_env_file() {
  if test -f "$HOME/.env.sh"; then
    success "$HOME/.env.sh already exists, skipping"
  else
    echo "export DOTFILES=$DOTFILES" > "$HOME/.env.sh"
    success "created $HOME/.env.sh"
  fi
}

install_dotfiles
create_env_file

echo ''
success '  All installed!'
