# === GENERAL === #
alias cl='clear'
alias src='source ~/.zshrc'
alias grep='grep --color=auto'

# === FILE SYSTEM === #
alias ff='fzf --preview "bat --style=numbers --color=always {}"'
alias ls='lsd --oneline'
alias lsa='ls -a'

# === DIRECTORIES === #
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# === TOOLS === #
alias vim='nvim'
alias lzg='lazygit'
#alias tmux='tmux -f $HOME/.config/tmux/tmux.conf'

# === GIT === #
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
