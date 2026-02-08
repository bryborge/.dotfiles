#!/bin/bash

set -euo pipefail

# Entry point for the symlink generation script.
#
# - Verifies the presence of expected dotfiles in the repository.
# - For each file, prompts the user to backup, destroy, or ignore an existing
#   target in the home directory (if present), then creates a symlink to the
#   repository copy.
# - At the end, offers to clean up any backups created.
main() {
  check_exists .zsh_aliases
  check_exists .zshrc
  check_exists .gitattributes
  check_exists .gitconfig
  check_exists .gitignore
  check_exists .gitprompt
  check_exists .vim
  check_exists .vimrc

  printf "\n"

  cleanup
}

# Check whether a target already exists in the user's home directory.
check_exists() {
  printf "\n"

  if [[ -f ~/$1 || -d ~/$1 || -L ~/$1 ]]; then
    echo "    \"~/$1\" already exists! Backup (b), Destroy (d), or Ignore (i)?"
    read -p "        Enter [b/d/i] : " opt
    printf "\n"
    handle_choice $opt $1
    create_symlink $1
  else
    create_symlink $1
  fi
}

# Handle the user's choice for an existing target in the home directory.
#
# Parameters:
#   $1 - single-letter choice: "i" (ignore), "b" (backup), "d" (destroy)
#   $2 - relative path of the target file (e.g. .zshrc)
#
# Actions:
#  - "i": leave the existing target alone and continue.
#  - "b": ensure `~/config.bak` exists, then move the existing target into it.
#  - "d": remove the existing target from the home directory.
handle_choice() {
  if [[ "i" == $1 ]]; then
    echo "    Ignoring. Proceed ..."
  elif [[ "b" == $1 ]]; then
    create_config_bak
    mv ~/$2 ~/config.bak
    echo "    backup created in \"~/config.bak/$2\""
  elif [[ "d" == $1 ]]; then
    rm ~/$2
    echo "    \"~/$2\" was destroyed."
  else
    echo "    Doing nothing. Proceed ... \"~/$2\""
  fi
}

# Create a symlink in the user's home directory pointing to the repository copy
# of the given file.
#
# Parameters:
#   $1 - relative path of the file in the repository to link from.
create_symlink() {
  ln -s $(pwd)/$1 ~/$1
  echo "    \"~/$1\" symlink created!"
}

# Ensure the backup directory `~/config.bak` exists.
create_config_bak() {
  if [ ! -d ~/config.bak ]; then
    mkdir ~/config.bak
  fi
}

# Offer the option to remove the `~/config.bak` directory created by earlier
# backup actions.
#
# If the user answers "y", the backup directory is removed; otherwise the
# backups are left in place.
cleanup() {
  echo "    Want to remove your backups now?"
  read -p "        Enter [y/n]: " opt

  if [[ "y" == $opt ]]; then
    rm -rf ~/config.bak
  else
    printf "\n"
    echo "    All set! Enjoy your new config files! Your backups are in \"~/config.bak\" if you need them."
  fi
}

# Invoke the script.
main
