#!/bin/bash
#
# 新しい Mac のセットアップを一発でやる bootstrap スクリプト。
# 冪等（何度実行しても安全）なので、途中で失敗したら再実行すればいい。
#
# 使い方:
#   curl -fsSL https://raw.githubusercontent.com/iskw9973/dotfiles/main/bootstrap.sh | sh
#   （リポジトリを clone 済みなら ./bootstrap.sh でも同じ）
#
# 引数でプロファイルを選べる（デフォルト: masamichi = 個人マシンのフル構成）:
#   ./bootstrap.sh <flake の設定名>
#
# 前提（これだけは手動）: Xcode Command Line Tools
# 無ければこのスクリプトが案内する。
set -euo pipefail

DOTFILES_DEFAULT="$HOME/Projects/ghq/github.com/iskw9973/dotfiles"
CONFIG="${1:-masamichi}"

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

# ---- 1. Xcode Command Line Tools ------------------------------------------
step "Xcode Command Line Tools"
if xcode-select -p >/dev/null 2>&1; then
  echo "OK: $(xcode-select -p)"
else
  xcode-select --install
  echo "インストールダイアログを起動しました。完了したらこのスクリプトを再実行してください。"
  exit 1
fi

# ---- 2. リポジトリの場所を解決（curl | sh なら clone する）-----------------
SCRIPT_DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd || true)"
if [ -f "$SCRIPT_DIR/flake.nix" ]; then
  DOTFILES="$SCRIPT_DIR"
else
  step "dotfiles を clone"
  if [ ! -d "$DOTFILES_DEFAULT/.git" ]; then
    git clone https://github.com/iskw9973/dotfiles.git "$DOTFILES_DEFAULT"
  fi
  exec "$DOTFILES_DEFAULT/bootstrap.sh" "$CONFIG"
fi

# ---- 3. Determinate Nix -----------------------------------------------------
step "Determinate Nix"
if command -v nix >/dev/null 2>&1; then
  echo "OK: $(nix --version)"
else
  curl --proto '=https' --tlsv1.2 -fsSL https://install.determinate.systems/nix \
    | sh -s -- install --no-confirm
  # このシェルにも nix を反映する
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  echo "OK: $(nix --version)"
fi

# ---- 4. nix-darwin（Homebrew 本体・GUI アプリ・フォント・brew 残留分）------
step "nix-darwin switch: $CONFIG（sudo のパスワードを求められます）"
if command -v darwin-rebuild >/dev/null 2>&1; then
  sudo darwin-rebuild switch --flake "$DOTFILES#$CONFIG"
else
  # 初回は darwin-rebuild がまだ無いので nix run で起動する
  sudo nix run nix-darwin -- switch --flake "$DOTFILES#$CONFIG"
fi

# ---- 5. home-manager（CLI ツール一式）--------------------------------------
step "home-manager switch: $CONFIG"
if command -v home-manager >/dev/null 2>&1; then
  home-manager switch --flake "$DOTFILES#$CONFIG"
else
  nix run home-manager -- switch --flake "$DOTFILES#$CONFIG"
fi

# ---- 6. 設定ファイルの symlink ----------------------------------------------
step "install.sh（設定ファイルの symlink）"
"$DOTFILES/install.sh"

# ---- 完了 --------------------------------------------------------------------
step "完了"
cat <<'EOF'
残りの手動セットアップ（必要なもののみ）:
  exec zsh                                      # シェルを再読み込み
  atuin login && atuin sync                     # 履歴同期（暗号化キーが必要）
  rustup-init -y                                # Rust を使う場合
  podman machine init && podman machine start   # コンテナを使う場合
EOF
