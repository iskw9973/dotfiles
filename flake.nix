{
  description = "iskw9973's dotfiles - CLI tools managed by Nix + home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Homebrew 本体のインストールと版の固定（brew-src が flake.lock に pin される）
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      nix-homebrew,
      ...
    }:
    let
      # メインマシン: Apple Silicon Mac
      system = "aarch64-darwin";

      # macOS のログインユーザー名に合わせて変更する（`whoami` の値）
      username = "masamichi";

      pkgs = import nixpkgs {
        inherit system;
        # unfree なパッケージは既定で拒否される。必要なものだけを名指しで許可する。
        # terraform は BSL 1.1（unfree 扱い）。
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "terraform" ];
      };

      mkHome =
        user:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./nix/home.nix ];
          extraSpecialArgs = { username = user; };
        };

      mkDarwin =
        user: darwinModules:
        nix-darwin.lib.darwinSystem {
          modules = darwinModules ++ [
            { nixpkgs.hostPlatform = system; }
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                user = user;
                # 手動インストール済みの /opt/homebrew があれば取り込む
                # （新しい Mac では何もない状態から brew を設置する）
                autoMigrate = true;
              };
            }
          ];
          specialArgs = { username = user; };
        };
    in
    {
      # キーをホスト名ではなくユーザー名にしている。
      # Mac を買い替えるとホスト名は変わるが、それでも同じコマンドで復元できる。
      homeConfigurations.${username} = mkHome username;

      darwinConfigurations.${username} = mkDarwin username [
        ./nix/darwin.nix
        ./nix/darwin-personal.nix
      ];

      # 仕事マシン用（共通部分のみ・Expo ツールチェーンや個人ツールなし）。
      # 使うときはログインユーザー名に合わせてコメントを外す:
      #   homeConfigurations.<work-user> = mkHome "<work-user>";
      #   darwinConfigurations.<work-user> = mkDarwin "<work-user>" [ ./nix/darwin.nix ];
      # 適用: sudo darwin-rebuild switch --flake .#<work-user>

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
