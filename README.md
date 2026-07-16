# My Dotfiles

Personal dotfiles. パッケージは Nix で宣言的に、設定ファイルは symlink で管理。

## Tech Stack (2026)

- **Package Management**: Nix (home-manager + nix-darwin)。GUI アプリ・フォントは nix-darwin 経由で Homebrew を宣言的に管理
- **Shell**: zsh with sheldon plugin manager
- **Prompt**: Starship
- **Runtime Manager**: mise (Node.js, pnpm) — プロジェクトごとの `mise.toml` で宣言。グローバルには置かない
- **VCS**: Git
- **Editor**: helix, VSCode, Zed, neovim（キーロガー付き / life 連携）
- **Terminal**: Ghostty
- **Terminal Multiplexer**: zellij
- **Container**: podman
- **History**: atuin (cloud sync)
- **Directory Navigation**: zoxide
- **Fuzzy Finder**: fzf
- **Completion**: carapace

## 役割分担

| 層 | 管理 | 定義場所 |
|----|------|----------|
| CLI ツール (rg, fd, gh, …) | Nix (home-manager) | `nix/home.nix` |
| フォント | Nix (nix-darwin fonts.packages) | `nix/darwin.nix` |
| GUI アプリ・brew 残留分 | Nix (nix-darwin) → Homebrew | `nix/darwin.nix` |
| Homebrew 本体 | Nix (nix-homebrew) — 版は flake.lock に固定 | `flake.nix` |
| 言語ランタイム (node, pnpm, …) | mise | 各プロジェクトの `mise.toml` |
| 設定ファイル | symlink | `install.sh` |

## Quick Setup (新しいマシン)

```bash
# 1. Xcode Command Line Tools
xcode-select --install

# 2. bootstrap（clone・Nix・Homebrew 本体・全ツール・symlink まで全部やる）
curl -fsSL https://raw.githubusercontent.com/iskw9973/dotfiles/main/bootstrap.sh | sh

# 3. シェルを再起動
exec zsh
```

`bootstrap.sh` は冪等（途中で失敗したら再実行すればいい）。
仕事マシンなど構成を分けたい場合は flake の設定名を渡す
（プロファイルは `flake.nix` の `darwinConfigurations` を参照）:

```bash
./bootstrap.sh <設定名>
```

中でやっていることを個別に実行したい場合:

```bash
sudo nix run nix-darwin -- switch --flake .#masamichi   # Homebrew 本体・GUI・フォント
nix run home-manager -- switch --flake .#masamichi      # CLI ツール一式
./install.sh                                            # 設定ファイルの symlink
```

2 回目以降の適用はコマンドが入っているので短くなる:

```bash
sudo darwin-rebuild switch --flake .#masamichi   # nix/darwin.nix を変えたとき
home-manager switch --flake .#masamichi          # nix/home.nix を変えたとき
```

> `flake.nix` の `username` が `whoami` と一致している必要がある。
> 違うマシン名でも動く（設定はホスト名でなくユーザー名に紐づけてある）。

## セットアップ後のツール初期化

### atuin（コマンド履歴）

```bash
atuin login    # または atuin register
atuin key      # → 暗号化キーをパスワードマネージャーに保存（必須！）
atuin sync
```

### mise（ランタイム管理）

グローバルにはツールを置かない方針（プロジェクトの宣言漏れを隠すため）。
各プロジェクトで:

```bash
cd <project> && mise install
```

### その他

```bash
sheldon lock --update          # zsh プラグイン
rustup-init -y                 # Rust（公式インストーラ、Nix 管理外）
podman machine init && podman machine start   # コンテナを使う場合
ghq get git@github.com:iskw9973/life.git      # nvim キーロガーを使う場合
```

## 日常的な使い方

### CLI ツールを追加する

```bash
# パッケージ名を探す（同名別物に注意: 追加前に説明文を確認する）
nix-search <keyword>
nix eval --raw "nixpkgs#<name>.meta.description"

# nix/home.nix の home.packages に追記して
home-manager switch --flake .#masamichi
```

### GUI アプリを追加する

`nix/darwin.nix` の `homebrew.casks` に追記して:

```bash
sudo darwin-rebuild switch --flake .#masamichi
```

宣言に無い brew パッケージは適用時にアンインストールされる（cleanup = "uninstall"）。

### 全ツールをまとめて更新する

```bash
nix flake update               # nixpkgs のピンを進める
home-manager switch --flake .#masamichi
# 調子が悪ければ: home-manager generations で世代一覧 → 古い世代の activate を実行
```

### 設定ファイルを編集する

symlink 方式なので直接編集すれば即反映:

```bash
vim ~/.zshrc   # = dotfiles/.zshrc
```

## ファイル構成

```
~/Projects/ghq/github.com/iskw9973/dotfiles/
├── README.md
├── bootstrap.sh            # 新しいマシンのセットアップ一発スクリプト（冪等）
├── install.sh              # 設定ファイルの symlink セットアップ
├── flake.nix               # Nix のエントリポイント（inputs のピンは flake.lock）
├── flake.lock
├── nix/
│   ├── home.nix            # CLI ツールの宣言（home-manager）
│   ├── darwin.nix          # GUI アプリ・brew の宣言・共通（nix-darwin）
│   ├── darwin-personal.nix # 個人マシンのみの宣言（Expo ツールチェーン等）
│   └── README.md           # Nix 構成の詳細
├── install.local.sh        # ローカル専用設定（gitignore 済み・任意）
├── .zshrc                  # → ~/.zshrc
├── .config/
│   ├── ghostty/            # → ~/.config/ghostty/
│   ├── git/                # → ~/.config/git/
│   ├── helix/              # → ~/.config/helix/
│   ├── mise/               # → ~/.config/mise/（グローバルツールなし・settings のみ）
│   ├── nvim/               # → ~/.config/nvim/（life のキーロガーを読込む最小設定）
│   ├── sheldon/            # → ~/.config/sheldon/
│   ├── starship.toml       # → ~/.config/starship.toml
│   ├── zellij/             # → ~/.config/zellij/
│   └── zsh/                # → ~/.config/zsh/
└── .claude/                # 設定ファイルのみ（ランタイムデータは ~/.claude に直接保存）
    ├── CLAUDE.md
    ├── settings.json
    ├── commands/ hooks/ rules/ skills/
```

## トラブルシューティング

### sheldon のプラグインが読み込まれない

```bash
sheldon lock --update && exec zsh
```

### atuin の履歴が同期されない

```bash
atuin status && atuin login && atuin sync
```

### mise のツールがインストールされない

```bash
mise doctor && mise install --force
```

### pnpm install が ETIMEDOUT を繰り返す（curl は通るのに）

回線が遅いと node が接続候補を 250ms で見切って全滅する（Happy Eyeballs のタイムアウト）。

```bash
NODE_OPTIONS="--network-family-autoselection-attempt-timeout=3000" pnpm install
```

### git push が `could not read Username` で失敗する

credential helper の gh が絶対パス（`/opt/homebrew/bin/gh` 等）で登録されていて
実体が消えたのが原因。`~/.gitconfig` の helper を `!gh auth git-credential`
（パス指定なし）にする。

## セキュリティ

- API キーや秘密情報は含まれていません
- `.claude/` は gitignore の許可リスト方式（`.claude/*` で全遮断し、
  設定ファイルだけを `!` で通す）。ランタイムデータが誤コミットされる
  事故を構造的に防いでいます
- 個人的なスキル・ローカル設定は `install.local.sh`（gitignore 済み）
  経由で別リポジトリから読み込む方式で、このリポジトリには含まれません
- atuin の暗号化キーは別途安全に保管してください

## ライセンス

未設定（設定の参考にするのは自由にどうぞ）

---

**Author**: iskw9973
**Last Updated**: 2026-07-16
