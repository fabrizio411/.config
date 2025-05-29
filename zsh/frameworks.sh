# === FRAMEWORKS PROJECT SETUPS === #

FRAMEWORKS=("razor" "astro")

new() {
  # Verificar que haya parametro
  if [ $# -eq 0 ]; then
    echo "Must specify a framework for the project."
    echo "Aveilable frameworks:"
    _list_frameworks
    return 1
  fi

  # Verificar que haya segundo parametro
  if [ -z "$2" ]; then
    echo "* Error: A project name must be specified."
    return 1
  fi

  # Verificar que parametro sea correcto
  local found=0
  for framework in "${FRAMEWORKS[@]}"; do
    if [ "$1" = "$framework" ]; then
      found=1
      break
    fi
  done

  if [ $found -eq 0 ]; then
    echo "* Error: Invalid framework"
    echo "Aveilable frameworks:"
    _list_frameworks
    return 1
  fi

  case "$1" in
  razor)
    _create_razor_project "$@"
    ;;
  astro)
    _create_astro_project "$@"
    ;;
  *)
    echo "* Error: unsuported framework"
    return 1
    ;;
  esac
}

_create_razor_project() {
  echo
  echo "Creating Razor project..."

  local project_name="$2"
  local web_name="WebApp"
  local lib_name="Dominio"

  # Crear directorio de proyecto
  mkdir "$project_name"
  cd "$project_name/" || return

  # Crear sln
  dotnet new sln -n "$project_name"
  # Crear proyecto Razor
  dotnet new razor -n "$web_name"
  # Crear biblioteca de clases
  dotnet new classlib -n "$lib_name"
  # Agregar proyectos  a sln
  dotnet sln "$project_name.sln" add "$web_name/$web_name.csproj"
  dotnet sln "$project_name.sln" add "$lib_name/$lib_name.csproj"
  # Agregar referencia de la biblioteca al proyecto Razor
  dotnet add "$web_name/$web_name.csproj" reference "$lib_name/$lib_name.csproj"

  echo "Created sln -> $project_name"
  echo "  - Razor project: $web_name"
  echo "  - Class Lib: $lib_name"
  echo "  - Reference added"
}

_create_astro_project() {
  echo
  echo "Creating Astro project..."
}

_list_frameworks() {
  for framework in "${FRAMEWORKS[@]}"; do
    echo "  - $framework"
  done
}

# Autocompletado
_new_autocomplete() {
  local -a frameworks
  frameworks=("${FRAMEWORKS[@]}")
  _arguments "1:framework:(${frameworks[*]})"
}
compdef _new_autocomplete new
