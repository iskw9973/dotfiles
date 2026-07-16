# home-manager 設定（CLI ツールのみ）
#
# 設定ファイル（~/.zshrc, ~/.config/*）は install.sh の symlink 管理。
# 言語ランタイム（node, pnpm …）は各プロジェクトの mise.toml。
{ pkgs, username, ... }:
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  # 初回セットアップ時の home-manager バージョン。変更しないこと
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

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
    herdr # AI エージェント用ターミナルマルチプレクサ

    # Git 関連
    gh
    lazygit
    git-lfs
    jujutsu # jj コマンド

    # 開発ツール
    just
    go
    terraform # unfree (BSL 1.1)。flake.nix の allowUnfreePredicate で許可
    supabase-cli

    # ターミナル・録画
    tmux
    mosh
    asciinema
    asciinema-agg # 録画を GIF に変換。`agg` は同名の別物（C++ 描画ライブラリ）
    vhs

    # ドキュメント・OCR
    pandoc
    poppler-utils # pdftotext 等。`poppler` はライブラリのみで CLI が入らない
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
    nix-search-cli

    # rustup は公式インストーラのまま（nixpkgs の rustup と混ぜない）
  ];
}
