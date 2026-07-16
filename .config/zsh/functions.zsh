# Useful functions

# Quick directory creation and navigation
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Git shortcuts
gst() {
  git status
}

gco() {
  git checkout "$@"
}

# fzf file preview
fzf-preview() {
  fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'
}

# ghq: Clone all GitHub repos
ghq-get-all() {
  gh repo list --limit 1000 --json nameWithOwner -q '.[].nameWithOwner' | xargs -P 8 -I {} ghq get {}
}
