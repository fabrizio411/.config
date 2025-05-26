# Exclude directories
exclude_dirs=(.git node_modules .tmux dist .ssh .cache .npm .local dotfiles build)

# Construct explude string from array
exclude_expr=""

for dir in "${exclude_dirs[@]}"; do
  if [ -z "$exclude_expr" ]; then
    exclude_expr="-name $dir"
  else
    exclude_expr="$exclude_expr -o -name $dir"
  fi
done

export FZF_DEFAULT_COMMAND="find . -type d \( $exclude_expr \) -prune -false -o -type f -print | sed 's|^\./||'"
