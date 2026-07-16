# nix-darwin 設定・共通部分（どのマシンにも入れるもの）
#
# 役割分担:
#   nix/darwin.nix          → 共通: GUI アプリ、フォント、通知
#   nix/darwin-personal.nix → 個人マシンのみ: Expo ツールチェーン、コンテナ等
#   nix/home.nix            → CLI ツール（rg, fd, git, mise …）
#   各プロジェクトの mise.toml → 言語ランタイム（node, pnpm, …）
#
# 適用:
#   初回（darwin-rebuild がまだ無い）: sudo nix run nix-darwin -- switch --flake .#masamichi
#   2回目以降:                        sudo darwin-rebuild switch --flake .#masamichi
{ pkgs, username, ... }:
{
  # Nix 本体は Determinate Nix（determinate-nixd）が管理しているので、
  # nix-darwin には触らせない。両方が管理すると daemon の設定を奪い合う。
  nix.enable = false;

  # homebrew などユーザー単位のオプションが対象にするユーザー
  system.primaryUser = username;
  users.users.${username}.home = "/Users/${username}";

  # 初回セットアップ時の nix-darwin バージョン。変更しないこと
  system.stateVersion = 6;

  homebrew = {
    enable = true;

    onActivation = {
      # 宣言にないものはアンインストールする。
      # "zap" にすると設定ファイルごと消えるので使わない
      # （atuin の履歴 DB などを巻き込む恐れがある）。
      cleanup = "uninstall";

      # 更新は明示的にやりたいので自動更新はしない。
      # brew を上げたいときは `brew update && brew upgrade` を手で打つ。
      autoUpdate = false;
      upgrade = false;
    };

    # Nix に持っていけない / 持っていくべきでないものだけを置く。
    # ここに足す前に「本当に nixpkgs に無いか」を nix-search で確認すること。
    brews = [
      # Claude Code の通知フック（.claude/hooks/notify-*.sh）が使う。
      # 以前は fastlane の依存として偶然入っていただけで、fastlane を
      # 消すと通知が黙って死ぬ状態だった。明示的に宣言する。
      "terminal-notifier"
    ];

    # GUI アプリは nixpkgs にもあるが cask に置く。理由:
    # - 自己更新するアプリ（Raycast, Zed）と Nix の不変ストアが衝突する
    # - 更新でアプリバンドルが置き換わると macOS の権限（TCC）を再要求されうる
    # - クローズドソースは nixpkgs 版も公式バイナリの包み直しで、Nix の旨味がない
    casks = [
      "ghostty"
      "raycast"
      "zed"
    ];
  };

  # フォントは自己更新も権限も絡まないので Nix で管理する
  # （/Library/Fonts/Nix Fonts に配置される）
  fonts.packages = with pkgs; [
    hackgen-nf-font
    udev-gothic-nf
  ];
}
