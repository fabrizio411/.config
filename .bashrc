#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias cl='clear'
alias rc='nvim ~/.bashrc'
alias ls='lsd --oneline'
alias grep='grep --color=auto'
alias fvim='nvim $(fzf --preview="cat {}")'
PS1='[\u@\h \W]\$ '

export EDITOR=nvim

#
# tmux* Nueva session
#
NTMUX_PROJECTS=("pinerolo" "milkcream" "easyfing" "portfolio")

ntmux() {
  # Si no se pasa ningún parámetro, ejecutar con "basic"
  if [ -z "$1" ]; then
    ntmux basic
    return
  fi

  if [ "$1" = "dev" ]; then
    # Verificar que se haya pasado un segundo parámetro
    if [ -z "$2" ]; then
      echo "* Error: A project name must be specified."
      return 1
    fi

    # Lista de proyectos válidos
    local found=0
    for project in "${NTMUX_PROJECTS[@]}"; do
      if [ "$2" = "$project" ]; then
        found=1
        break
      fi
    done

    if [ $found -eq 0 ]; then
      echo "* Error: Invalid project."
      echo "Available options:"
      for proj in "${NTMUX_PROJECTS[@]}"; do
        echo "  - $proj"
      done
      return 1
    fi

    local session_name="$2"
    local workdir="$HOME/projects/$2"

    # Crear la sesión en el directorio deseado si no existe
    tmux has-session -t "$session_name" 2>/dev/null
    if [ $? != 0 ]; then
      TMUX_PWD="$workdir" tmux new-session -d -s "$session_name" -c "$workdir" "nvim"
      tmux rename-window -t "$session_name:1" "editor"
      tmux new-window -t "$session_name" -c "$workdir"
      tmux rename-window -t "$session_name:2" "server"
    fi

    if [ -n "$TMUX" ]; then
      tmux switch-client -t "$session_name"
    else
      tmux attach-session -t "$session_name"
    fi
  else
    local session_name="$1"
    tmux has-session -t "$session_name" 2>/dev/null || tmux new-session -d -s "$session_name"

    if [ -n "$TMUX" ]; then
      tmux switch-client -t "$session_name"
    else
      tmux attach-session -t "$session_name"
    fi
  fi
}

_ntmux_autocomplete() {
  local cur="${COMP_WORDS[COMP_CWORD]}"

  if [[ ${COMP_WORDS[1]} == "dev" && $COMP_CWORD -eq 2 ]]; then
    COMPREPLY=($(compgen -W "${NTMUX_PROJECTS[*]}" -- "$cur"))
  fi
}

complete -F _ntmux_autocomplete ntmux

#
# tmux* Kill session
#
ktmux() {
  local target="$1"

  # Verifica que la sesión exista
  if ! tmux has-session -t "$target" 2>/dev/null; then
    echo "* Error: Session '$target' does not exist."
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
      echo "* No other sessions available to switch before killing current session."
      echo "Killing current session anyway..."
      tmux kill-session -t "$target"
      return
    fi

    # Cambiamos a la primera sesión disponible diferente de la actual
    tmux switch-client -t "${sessions[0]}"
    echo "+ Switched to session '${sessions[0]}'"

    # Ahora sí matamos la sesión objetivo (la actual original)
    tmux kill-session -t "$target"
    echo "+ Session '$target' has been killed."
  else
    # Si no es la sesión actual, la mata directo
    tmux kill-session -t "$target"
    echo "+ Session '$target' has been killed."
  fi
}

_ktmux_autocomplete() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local sessions=$(tmux ls 2>/dev/null | cut -d: -f1)
  COMPREPLY=($(compgen -W "$sessions" -- "$cur"))
}

complete -F _ktmux_autocomplete ktmux

#
# Update Dotfiles and push to git
#
update-dotfiles() {
  DOTFILES_DIR=~/dotfiles

  # Copias
  cp ~/.bashrc $DOTFILES_DIR/.bashrc
  cp ~/.tmux.conf $DOTFILES_DIR/.tmux.conf
  rsync -a --delete ~/.config/ $DOTFILES_DIR/.config/
  rsync -a --delete ~/.tmux/ $DOTFILES_DIR/.tmux/

  echo "+ Updated | Git push must be done manually"
}

#
# Check alias disponibility
#
check() {
  local name="$1"
  if type "$name" &>/dev/null; then
    echo "* El nombre '$name' ya está en uso:"
    type "$name"
  else
    echo "+ El nombre '$name' está disponible"
  fi
}

#
# Starship startup
#
eval "$(starship init bash)"
