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
  DOTFILES_DIR=~/dotfiles

  # Copias
  cp ~/.bashrc $DOTFILES_DIR/.bashrc
  cp ~/.tmux.conf $DOTFILES_DIR/.tmux.conf
  rsync -a --delete ~/.config/ $DOTFILES_DIR/.config/
  rsync -a --delete ~/.tmux/ $DOTFILES_DIR/.tmux/
  rsync -a --delete ~/.tmuxifier/ $DOTFILES_DIR/.tmuxifier/

  # Git
  cd "$DOTFILES_DIR" || {
    echo "No se pudo acceder a $DOTFILES_DIR"
    return 1
  }

  if ! git diff --quiet || ! git diff --cached --quiet; then
    git add .
    git commit -m "Update dotfiles"
    git push
    cd ~
    echo "Update completed and pushed to remote."
  else
    echo "No hay cambios para hacer commit."
  fi
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
