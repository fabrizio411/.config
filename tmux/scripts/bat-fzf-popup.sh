#!/bin/zsh

local file

file=$(eval "fd --type f" | fzf --tmux bottom,50,18 --style full) || exit 0

if [ -n "$file" ]; then
  tmux split-window -h "bat \"$HOME/$file\" --paging=always"
fi
