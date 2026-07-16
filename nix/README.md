# Nix 構成の詳細

パッケージ管理を Nix に寄せた構成。設定ファイルは従来どおり `install.sh` の symlink 方式。

セットアップ手順はリポジトリ直下の [README.md](../README.md) を参照。
ここには構成の意図と、判断に迷ったときの基準を書く。

## 構成

| ファイル | 役割 | 適用コマンド |
|----------|------|--------------|
| `home.nix` | CLI ツール（home-manager） | `home-manager switch --flake .#masamichi` |
| `darwin.nix` | GUI アプリ・フォント・brew 残留分（nix-darwin） | `sudo darwin-rebuild switch --flake .#masamichi` |

`flake.lock` が nixpkgs / home-manager / nix-darwin のバージョンを固定している。
コミットしておけば別マシンでもビット単位で同じツールが再現される。

## どこで管理するかの判断基準

| 問い | YES なら |
|------|----------|
| バージョンがプロジェクトのコードや設定に結合している？（node, pnpm, typescript…） | プロジェクトの `mise.toml` / `package.json`。**Nix に入れない** |
| GUI アプリ・フォント？ | `darwin.nix` の `homebrew.casks` |
| Apple / Google のツールチェーンと噛み合う？（cocoapods, fastlane, openjdk） | `darwin.nix` の `homebrew.brews` |
| 動き続けるサービス？（postgres, localstack…） | コンテナ（podman）。**Nix に入れない** |
| それ以外の CLI 道具（rg, gh, ffmpeg…） | `home.nix` の `home.packages` |

パッケージを追加する前に、同名別物の罠よけとして中身を確認する:

```bash
nix eval --raw "nixpkgs#<name>.meta.description"
```

実例: nixpkgs の `poppler` はライブラリのみで pdftotext が入らない（CLI は
`poppler-utils`）。`agg` は asciinema の GIF 変換ではなく C++ 描画ライブラリ
（正しくは `asciinema-agg`）。

## ロールバック

```bash
home-manager generations                        # 世代一覧
/nix/store/…-home-manager-generation/activate   # 戻したい世代の activate を実行
```

`nix flake update` で壊れたときも、`git checkout flake.lock` して
switch し直せば元に戻る。

## メンテナンス

```bash
nix flake update && home-manager switch --flake .#masamichi   # まとめて更新
nix-collect-garbage -d                                        # 古い世代を捨ててディスク回収
nix store optimise                                            # 重複ファイルをハードリンク化
```

## 注意点

- **Nix 本体は Determinate Nix が管理**している。`darwin.nix` の
  `nix.enable = false` を外すと daemon の管理を奪い合って壊れる
- **Homebrew 本体は nix-homebrew が管理**している。brew の版は
  flake.lock の `brew-src` に固定され、`nix flake update` で上がる。
  `brew update` はパッケージのカタログを更新するだけで brew 本体は
  更新しない（する必要もない）
- `darwin.nix` の cleanup は `"uninstall"`（`"zap"` にすると設定ファイル
  ごと消えて atuin の履歴 DB などを巻き込む）
- 言語ランタイムを Nix に入れない理由: nixpkgs はメジャーバージョン
  ごとに 1 つしか持てず、`packageManager` が要求する正確なバージョン
  （例: pnpm@10.28.2）を提供できない。粒度の細かい更新も mise が得意
