# Remaining TODO

プロジェクト内の残りTODOを確認してください。

## 検索コマンド

```bash
# TODO/FIXME/HACK を検索
rg "TODO|FIXME|HACK" --type-not md

# 特定ディレクトリを除外
rg "TODO|FIXME|HACK" --glob "!node_modules" --glob "!.git"
```

## 確認項目

1. **TODO** - 未実装の機能や改善点
2. **FIXME** - 修正が必要なバグや問題
3. **HACK** - 一時的な回避策（後でリファクタ必要）

## 出力形式

各TODOについて以下を報告:
- ファイル名と行番号
- TODOの内容
- 優先度（推定）
