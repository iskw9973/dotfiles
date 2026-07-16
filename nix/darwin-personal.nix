# nix-darwin 設定・個人マシンのみ（仕事マシンには入れないもの）
{ ... }:
{
  homebrew = {
    # サードパーティの tap。ここに書かないと cleanup が untap しようとする
    taps = [
      "openclaw/tap" # gogcli の配布元
    ];

    brews = [
      # Google Workspace CLI（gog スキルが使う）。nixpkgs に無い
      "gogcli"

      # コンテナ。podman machine（VM）の管理が絡むので Nix にしない
      "podman"
      "docker-compose"

      # Expo / React Native のネイティブビルド用。
      # Xcode・Android SDK と噛み合う必要があるので Nix にしない
      "cocoapods"
      "fastlane"
      "openjdk@17"

      # Metal サポートが絡むので Nix にしない
      "ollama"

      "tailscale"
    ];
  };
}
