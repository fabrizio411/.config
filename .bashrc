#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ch='cd ~'
alias cl='clear'
alias ls='ls --color=auto'
alias rc='nvim ~/.bashrc'
alias ls='lsd --oneline'
alias tm='tmuxifier'
alias grep='grep --color=auto'
alias fvim='nvim $(fzf --preview="cat {}")'
PS1='[\u@\h \W]\$ '

export PATH="$HOME/.tmuxifier/bin:$PATH"
export EDITOR=nvim

function update-dotfiles() {
  cp ~/.bashrc ~/dotfiles/.bashrc
  cp ~/.tmux.conf ~/dotfiles/.tmux.conf
  rsync -a --delete ~/.config/ ~/dotfiles/.config/
  rsync -a --delete ~/.tmux/ ~/dotfiles/.tmux/

  echo "Backup completed. (Update git manually)"
}

#
# Check alias disponibility
#
function check() {
  local name="$1"
  if type "$name" &>/dev/null; then
    echo "- El nombre '$name' ya está en uso:"
    type "$name"
  else
    echo "+ El nombre '$name' está disponible"
  fi
}

#
# Starship startup
#
eval "$(tmuxifier init -)"
eval "$(starship init bash)"
