# Copy Template

プロジェクトに Claude 設定テンプレートをコピーします。

## 手順

1. 現在のディレクトリを確認
2. 以下のファイルをコピー:
   - `~/.templates/claude-project/CLAUDE.md` → `./CLAUDE.md`
   - `~/.templates/claude-project/.claude/` → `./.claude/`

3. CLAUDE.md の `{{PROJECT_NAME}}` をディレクトリ名に置換

## 実行コマンド

```bash
# ディレクトリ作成
mkdir -p .claude

# ファイルコピー
cp ~/.templates/claude-project/CLAUDE.md ./CLAUDE.md
cp -r ~/.templates/claude-project/.claude/* ./.claude/

# プロジェクト名を置換
PROJECT_NAME=$(basename "$PWD")
sed -i '' "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" ./CLAUDE.md
```

## コピー後

CLAUDE.md を編集して、プロジェクト固有の情報を追加してください:
- 技術スタック
- ディレクトリ構成
- コマンド

MCP サーバーが必要なら `.claude/settings.json` を編集してください。
