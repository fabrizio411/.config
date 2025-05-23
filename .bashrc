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
alias grep='grep --color=auto'
alias fvim='nvim $(fzf --preview="cat {}")'
PS1='[\u@\h \W]\$ '

export EDITOR=nvim

#
# tmux - Nueva session
#
function ntmux() {
  tmux new-session -d -s "$1" && tmux switch-client -t "$1"
}

#
# tmux - Kill session
#
function ktmux() {
  local target="$1"

  # Verifica que la sesión exista
  if ! tmux has-session -t "$target" 2>/dev/null; then
    echo "Session '$target' does not exist."
    echo "Available sessions:"
    tmux ls
    return 1
  fi

  # Obtiene el nombre de la sesión actual
  local current_session
  current_session=$(tmux display-message -p '#S')

  if [ "$target" = "$current_session" ]; then
    # Obtenemos lista de sesiones excepto la actual
    local sessions
    sessions=($(tmux ls | cut -d: -f1 | grep -v "^${current_session}$"))

    if [ ${#sessions[@]} -eq 0 ]; then
      echo "⚠️ No other sessions available to switch before killing current session."
      echo "Killing current session anyway..."
      tmux kill-session -t "$target"
      return
    fi

    # Cambiamos a la primera sesión disponible diferente de la actual
    tmux switch-client -t "${sessions[0]}"
    echo "Switched to session '${sessions[0]}'"

    # Ahora sí matamos la sesión objetivo (la actual original)
    tmux kill-session -t "$target"
    echo "Session '$target' has been killed."
  else
    # Si no es la sesión actual, la mata directo
    tmux kill-session -t "$target"
    echo "Session '$target' has been killed."
  fi
}

#
# Update Dotfiles and push to git
#
function update-dotfiles() {
  DOTFILES_DIR=~/dotfiles

  # Copias
  cp ~/.bashrc $DOTFILES_DIR/.bashrc
  cp ~/.tmux.conf $DOTFILES_DIR/.tmux.conf
  rsync -a --delete ~/.config/ $DOTFILES_DIR/.config/
  rsync -a --delete ~/.tmux/ $DOTFILES_DIR/.tmux/

  echo "Updated - Git push must be done manually"
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
eval "$(starship init bash)"
