export ZSH="$HOME/.oh-my-zsh"
ZSH_DISABLE_COMPFIX="true"
ZSH_THEME="imajes"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
export PATH=~/.npm-global/bin:$PATH
LS_COLORS="ow=94;40:ex=0;40" # Colors for terminal in wsl

alias la="ls -lah"
alias q="cd .."
alias ll="clear; pwd; la; pwd"
alias ne="emacs -nw"
alias dd="cd ~/work"
alias ddd=" cd /mnt/c/Users/saidp/Desktop/work"
alias gs='git status'
alias ni='npm install'
alias nd='npm run dev'
alias nt='explorer.exe .'
