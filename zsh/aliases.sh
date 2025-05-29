# === GENERAL === #
alias cl='clear'
alias src='source ~/.zshrc'
alias rc='nvim ~/.config/zsh'
alias grep='grep --color=auto'

# === FILE SYSTEM === #
alias ff='fzf --preview "bat --paging=always --style=numbers --color=always {}"'
alias ls='lsd --oneline'
alias lsa='ls -a'

# === DIRECTORIES === #
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# === TOOLS === #
alias vim='nvim'
alias lzg='lazygit'
alias cd='z'

# === GIT === #
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gcu='git commit -m "Update"'
alias gp='git push'

# === TODOs === #
alias todo='tmux popup -E -w 65 -h 25 -x C -y C -T " TODOs " -- \
  zsh -c "bat --style=numbers,grid --paging=always ~/notes/todo.md"'
