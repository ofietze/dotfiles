
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
autoload -Uz compinit # Fix auto cd by loading compinit on start
compinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk
setopt AUTO_CD # Allows to ommit cd


# Plugins
zinit wait lucid light-mode for \
        OMZP::git \
        OMZP::alias-finder \
        OMZP::brew \
        zsh-users/zsh-autosuggestions \
        zsh-users/zsh-completions \
        zsh-users/zsh-syntax-highlighting \
        zsh-users/zsh-history-substring-search \
        zdharma-continuum/fast-syntax-highlighting \
        zdharma-continuum/history-search-multi-word

zinit ice wait atload'_history_substring_search_config'

export FZF_DEFAULT_OPTS_FILE="$HOME/.config/fzf/config"

# Custom aliases
alias src="source ~/.zshrc"
alias n="nvim"
alias lg="lazygit"
alias zshrc="n ~/.zshrc"
alias aero="n .aerospace.toml"
alias sketch="n ./.config/sketchybar/"
alias neo="n ./.config/nvim/"
alias dev="cd ~/Developer"
alias z="zellij"
alias gs="git status"
alias l="ls -a"
alias f="fzf"
alias commit="~./scripts/harver_git_commit.sh"

# Init theme
eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
