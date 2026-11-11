
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
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk
setopt AUTO_CD # Allows to ommit cd


# Plugins
zinit wait lucid light-mode for \
        OMZP::git \
        OMZP::alias-finder \
        OMZP::brew \
        OMZP::aws \
        zsh-users/zsh-autosuggestions \
        zsh-users/zsh-completions \
        zsh-users/zsh-syntax-highlighting \
        zsh-users/zsh-history-substring-search \
        zdharma-continuum/fast-syntax-highlighting \
        zdharma-continuum/history-search-multi-word

zinit ice wait atload'_history_substring_search_config'

export FZF_DEFAULT_OPTS_FILE="$HOME/.config/fzf/config"
SHOW_AWS_PROMPT=false

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
alias f="nvim \$(fzf -m)"
alias commit="~./scripts/harver_git_commit.sh"

# Init theme
eval "$(starship init zsh)"

[ "$(command -v atuin)" ] && eval "$(atuin init zsh ${ATUIN_INIT_FLAGS})"
eval "$(mise activate zsh)"

export NODE_PATH=/opt/homebrew/lib/node_modules
export PATH="$HOME/.local/bin:$PATH"
export DOCKER_HOST="unix://$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}')"

# bun completions
[ -s "/Users/oliverfietze/.bun/_bun" ] && source "/Users/oliverfietze/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by codebase-memory-mcp install
export PATH="/Users/oliverfietze/.local/bin:$PATH"

# Check for updates
~/Developer/brew-check.sh
# Added by Kiro CLI
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) export PATH="${PATH:+$PATH:}$HOME/.local/bin" ;; esac
