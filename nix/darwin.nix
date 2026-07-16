# nix-darwin 設定・共通部分（どのマシンにも入れるもの）
#
# 個人マシン固有のものは nix/darwin-personal.nix。
{ pkgs, username, ... }:
{
  # Nix 本体は Determinate Nix が管理しているので nix-darwin には触らせない。
  # 両方が管理すると daemon の設定を奪い合う。
  nix.enable = false;

  system.primaryUser = username;
  users.users.${username}.home = "/Users/${username}";

  # 初回セットアップ時の nix-darwin バージョン。変更しないこと
  system.stateVersion = 6;

  homebrew = {
    enable = true;

    onActivation = {
      # 宣言にないものはアンインストールする。
      # "zap" は設定ファイルごと消える（atuin の履歴 DB 等）ので使わない。
      cleanup = "uninstall";
      autoUpdate = false;
      upgrade = false;
    };

    brews = [
      # Claude Code の通知フック（.claude/hooks/notify-*.sh）が使う
      "terminal-notifier"
    ];

    # GUI アプリは nixpkgs にもあるが cask に置く。理由:
    # - 自己更新するアプリと Nix の不変ストアが衝突する
    # - 更新でアプリバンドルが置き換わると macOS の権限（TCC）を再要求されうる
    # - クローズドソースは nixpkgs 版も公式バイナリの包み直しで、Nix の旨味がない
    casks = [
      "ghostty"
      "raycast"
      "zed"
    ];
  };

  # フォントは自己更新も権限も絡まないので Nix で管理する
  fonts.packages = with pkgs; [
    hackgen-nf-font
    udev-gothic-nf
  ];
}
