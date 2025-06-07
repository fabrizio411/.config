# === TMUX SESSION FUCNTIONS === #

# === CREAR/ABRIR SESSION === #
NTMUX_PROJECTS=("pinerolo" "milkcream" "easyfing" "portfolio" "ecommerce")

nt() {
  # Si no se pasa ningún parámetro, ejecutar con "basic"
  if [ $# -eq 0 ]; then
    nt home
    return
  fi

  # Modo desarrollo con flag -d
  if [ "$1" = "-d" ]; then
    # Verificar que se haya pasado un segundo parámetro
    if [ -z "$2" ]; then
      echo "* Error: A project name must be specified after -d."
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

    return
  fi

  # Resto de sesiones
  local session_name="$1"
  tmux has-session -t "$session_name" 2>/dev/null || tmux new-session -d -s "$session_name" -c ~

  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$session_name"
  else
    tmux attach-session -t "$session_name"
  fi
}

_nt_autocomplete() {
  local state

  _arguments \
    '-d[Open in dev mode]:project name:->projects' \
    '*:: :->default'

  case $state in
    projects)
      compadd -- "${NTMUX_PROJECTS[@]}"
      ;;
  esac
}
compdef _nt_autocomplete nt

# === ELIMINAR SESSION === #
kt() {
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

  # Si la sesión objetivo es la sesión actual
  if [ "$target" = "$current_session" ]; then
    local next_session_to_switch
    # Obtenemos la primera sesión disponible que no sea la actual
    next_session_to_switch=$(tmux ls -F '#{session_name}' | grep -v "^${current_session}$" | head -n 1)

    if [ -n "$next_session_to_switch" ]; then
      # Cambiamos a la siguiente sesión disponible
      tmux switch-client -t "$next_session_to_switch"
    else
      # Si no hay otras sesiones, informamos y continuamos para matar la actual
      echo "* No other sessions available to switch to. Killing current session."
    fi
  fi

  # Matamos la sesión objetivo (ya sea la que estábamos o la que especificamos)
  tmux kill-session -t "$target"
}

_kt_autocomplete() {
  local -a sessions
  sessions=("${(@f)$(tmux ls 2>/dev/null | cut -d: -f1)}")
  _describe -t sessions 'TMUX sessions' sessions
}
compdef _kt_autocomplete kt

