# home-manager 設定（パッケージ管理のみ）
#
# 方針: まずは Homebrew で入れていた CLI ツールを Nix に置き換えるだけ。
# 設定ファイル（~/.zshrc, ~/.config/*）は従来どおり install.sh の
# シンボリックリンクで管理し、home-manager には触らせない。
# Nix に慣れてきたら programs.* での設定管理に移行してもよい。
{ pkgs, username, ... }:
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  # 初回セットアップ時の home-manager バージョン。変更しないこと
  home.stateVersion = "25.11";

  # `home-manager` コマンド自体も Nix で管理する
  programs.home-manager.enable = true;

  # README「必要なツールのインストール」の brew install 相当
  home.packages = with pkgs; [
    # 基本ツール
    git
    ghq
    mise
    starship
    atuin
    sheldon
    zoxide
    fzf
    yazi
    carapace
    zellij
    neovim
    helix

    # AI コーディングエージェント
    herdr # AI エージェント用ターミナルマルチプレクサ（tmux のエージェント版）

    # Git 関連
    gh
    lazygit
    git-lfs
    jujutsu # jj コマンド

    # 開発ツール
    just
    go
    terraform # unfree (BSL 1.1)。flake.nix の allowUnfreePredicate で許可している
    supabase-cli

    # ターミナル・録画
    tmux
    mosh
    asciinema
    asciinema-agg # 録画を GIF に変換する。`agg` は同名の別物（C++ 描画ライブラリ）
    vhs

    # ドキュメント・OCR
    pandoc
    poppler-utils # pdftotext, pdfinfo など。`poppler` はライブラリのみで CLI が入らない
    tesseract
    ocrmypdf

    # その他
    pv
    yt-dlp

    # モダン CLI
    eza
    ripgrep
    fd
    bat
    dust

    # Nix 用ユーティリティ
    nix-search-cli # nix-search コマンドでパッケージ検索
  ];

  # Nix 管理外のまま残すもの:
  # - GUI アプリ (raycast, ghostty, zed)
  #   → nix/darwin.nix の homebrew.casks で宣言的に管理する
  #   （フォントは nix/darwin.nix の fonts.packages で Nix 管理）
  # - podman / docker-compose → podman machine の管理が絡むので Homebrew のまま
  # - cocoapods / fastlane / openjdk@17
  #   → Expo のネイティブビルド用。Xcode・Android SDK と噛み合うので Homebrew のまま
  # - terminal-notifier → nixpkgs 版は動作が不安定なことがあるので Homebrew のまま
  # - ollama → Metal サポートが絡むので Homebrew のまま
  # - rustup → 公式インストーラのまま（nixpkgs の rustup と混ぜない）
  #
  # node / pnpm など言語ランタイムは mise の担当（各プロジェクトの mise.toml で宣言）。
  # nixpkgs はメジャーバージョンごとに1つしか持てず、パッチ版を指定できないため。
}
