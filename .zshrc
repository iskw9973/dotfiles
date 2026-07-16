# PATH
source ~/.config/zsh/path.zsh

# Environment
export EDITOR="vim"
export LANG=en_US.UTF-8

# Aliases
alias ls="eza"
alias la="eza -la"
alias h="history"
alias gl="git pull"

# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

# Options
setopt auto_pushd
setopt auto_cd
setopt pushd_ignore_dups

# Line editing
# / - . _ を単語の区切りにする（Option+← がパスの区切りごとに止まる）
WORDCHARS='*?[]~=&;!#$%^(){}<>'
# Ctrl+X Ctrl+E でコマンドラインを $EDITOR で編集
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Completion
# nix-homebrew 環境では brew の補完シムが Nix ストアの外を指したまま壊れて残る。
# 壊れたシムを掃除し、Nix ストア内の生きた補完を fpath に足す（brew は呼ばない）。
if [ -d /opt/homebrew/Library/Homebrew ]; then
  _brew_shim=/opt/homebrew/share/zsh/site-functions/_brew
  [ -L "$_brew_shim" ] && [ ! -e "$_brew_shim" ] && rm -f "$_brew_shim"
  _brew_comp="$(dirname "$(dirname "$(readlink -f /opt/homebrew/Library/Homebrew)")")/completions/zsh"
  [ -e "$_brew_comp/_brew" ] && fpath=("$_brew_comp" $fpath)
  unset _brew_shim _brew_comp
fi

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'

# Deno completions
if [[ ":$FPATH:" != *":$HOME/completions:"* ]]; then
  export FPATH="$HOME/completions:$FPATH"
fi

# Dart CLI completion
[[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && source "$HOME/.dart-cli-completion/zsh-config.zsh" || true

# Deno
[[ -f "$HOME/.deno/env" ]] && source "$HOME/.deno/env"

# Tool initializations
eval "$(starship init zsh)"
eval "$(mise activate zsh)"
eval "$(atuin init zsh --disable-up-arrow)"
eval "$(sheldon source)"
eval "$(zoxide init zsh --cmd cd)"
source <(carapace _carapace)

# Rust (rustup)
. "$HOME/.cargo/env"

# fzf
source <(fzf --zsh)

# Functions
source ~/.config/zsh/functions.zsh

# Local bin
. "$HOME/.local/bin/env"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
