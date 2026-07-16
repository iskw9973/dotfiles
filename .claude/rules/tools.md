# Preferred Tools

モダンなCLIツールを優先して使用する。

## 置き換えルール

| 従来 | 推奨 | 理由 |
|------|------|------|
| `grep` | `rg` (ripgrep) | 高速、.gitignore対応 |
| `find` | `fd` | シンプルな構文、高速 |
| `cat` | `bat` | シンタックスハイライト |
| `ls` | `eza` | Git対応、アイコン表示 |
| `du` | `dust` | 視覚的なディスク使用量 |
| `cd` | `z` (zoxide) | 履歴ベースのジャンプ |
| `git` (GitHub操作) | `gh` | GitHub CLI |
| `npx` | `pnpm dlx` | pnpm環境の場合 |

## 検索例

```bash
# ファイル内検索
rg "pattern" --type ts

# ファイル名検索
fd "*.tsx" src/

# ディレクトリ移動
z project-name
```

## フォールバック

推奨ツールが使えない場合は従来のコマンドを使用。
