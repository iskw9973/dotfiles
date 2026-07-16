{
  description = "iskw9973's dotfiles";

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
    # Homebrew 本体も flake.lock で版を固定する
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
      system = "aarch64-darwin";
      username = "masamichi";

      pkgs = import nixpkgs {
        inherit system;
        # unfree は既定で拒否。必要なものだけ名指しで許可する
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "terraform" ];
      };

      mkHome =
        user:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./nix/home.nix ];
          extraSpecialArgs = {
            username = user;
          };
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
                autoMigrate = true; # 手動インストール済みの /opt/homebrew を取り込む
              };
            }
          ];
          specialArgs = {
            username = user;
          };
        };
    in
    {
      # キーはホスト名ではなくユーザー名。Mac を買い替えても同じコマンドで復元できる
      homeConfigurations.${username} = mkHome username;

      darwinConfigurations.${username} = mkDarwin username [
        ./nix/darwin.nix
        ./nix/darwin-personal.nix
      ];

      # 仕事マシンなど共通部分だけ使う場合はこの形で足す:
      #   homeConfigurations.<user> = mkHome "<user>";
      #   darwinConfigurations.<user> = mkDarwin "<user>" [ ./nix/darwin.nix ];

      # nixfmt はディレクトリを辿れないので、.nix を探して渡すラッパーにする
      formatter.${system} = pkgs.writeShellApplication {
        name = "fmt";
        runtimeInputs = [
          pkgs.nixfmt
          pkgs.fd
        ];
        text = ''
          if [ "$#" -gt 0 ] && [ -f "$1" ]; then
            exec nixfmt "$@"
          fi
          exec fd --extension nix --type f . "''${@:-.}" --exec-batch nixfmt
        '';
      };
    };
}
