#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "Installing dotfiles from $DOTFILES"

# ~/.zshrc
if [ -e ~/.zshrc ] && [ ! -L ~/.zshrc ]; then
  mv ~/.zshrc ~/.zshrc.backup
  echo "Backed up ~/.zshrc to ~/.zshrc.backup"
fi
ln -sfn "$DOTFILES/.zshrc" ~/.zshrc
echo "Linked ~/.zshrc"

# ~/.config
mkdir -p ~/.config
for item in git helix mise sheldon starship.toml zellij zsh ghostty nvim; do
  if [ -e ~/.config/$item ] && [ ! -L ~/.config/$item ]; then
    mv ~/.config/$item ~/.config/${item}.backup
    echo "Backed up ~/.config/$item"
  fi
  ln -sfn "$DOTFILES/.config/$item" ~/.config/$item
  echo "Linked ~/.config/$item"
done

# ~/.claude (config files only, runtime data stays outside dotfiles)
if [ -L ~/.claude ]; then
  rm ~/.claude
  echo "Removed old ~/.claude symlink"
fi
mkdir -p ~/.claude
for item in CLAUDE.md commands hooks rules settings.json statusline.sh assets; do
  if [ -e "$DOTFILES/.claude/$item" ]; then
    if [ -e ~/.claude/$item ] && [ ! -L ~/.claude/$item ]; then
      mv ~/.claude/$item ~/.claude/${item}.backup
      echo "Backed up ~/.claude/$item"
    fi
    ln -sfn "$DOTFILES/.claude/$item" ~/.claude/$item
    echo "Linked ~/.claude/$item"
  fi
done

# ~/.claude/skills: スキルを個別にリンクする。
# install.local.sh（任意・gitignore 済み）で EXTRA_SKILL_DIRS を定義すると
# 別の場所のスキルも合わせてリンクされる。
EXTRA_SKILL_DIRS=""
[ -f "$DOTFILES/install.local.sh" ] && . "$DOTFILES/install.local.sh"

if [ -L ~/.claude/skills ]; then
  rm ~/.claude/skills
  echo "Removed old ~/.claude/skills symlink"
fi
mkdir -p ~/.claude/skills
for link in ~/.claude/skills/*; do
  if [ -L "$link" ] && [ ! -e "$link" ]; then
    rm "$link"
    echo "Removed dangling skill link: $(basename "$link")"
  fi
done
for base in "$DOTFILES/.claude/skills" $EXTRA_SKILL_DIRS; do
  for dir in "$base"/*/; do
    [ -d "$dir" ] || continue
    name="$(basename "$dir")"
    ln -sfn "${dir%/}" ~/.claude/skills/"$name"
    echo "Linked skill: $name"
  done
done

echo ""
echo "Done! Run 'exec zsh' to reload shell."
