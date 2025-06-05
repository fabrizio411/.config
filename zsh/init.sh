eval "$(starship init zsh)"
source <(fzf --zsh)
eval "$(zoxide init zsh)"

# pnpm
export PNPM_HOME="/home/fabz/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
