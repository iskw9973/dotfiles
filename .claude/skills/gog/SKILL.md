# gog - Google Workspace CLI

ターミナルからGoogle Workspace（Gmail, Calendar, Drive等）を操作するCLIツール。

## セットアップ

```bash
# インストール
brew install steipete/tap/gogcli

# 認証（ブラウザで認可）
gog auth add

# デフォルトアカウント設定
export GOG_ACCOUNT=you@gmail.com
```

## Gmail

| Purpose | Command |
|---------|---------|
| 未読メール検索 | `gog gmail search 'is:unread newer_than:7d' --max 20` |
| 送信者で検索 | `gog gmail search 'from:someone@example.com'` |
| メール取得 | `gog gmail get <messageId>` |
| メール送信 | `gog gmail send --to user@example.com --subject "件名" --body "本文"` |
| ラベル一覧 | `gog gmail labels list` |
| 添付ファイル取得 | `gog gmail attachment <messageId> <attachmentId> --out file.pdf` |

## Calendar

| Purpose | Command |
|---------|---------|
| 今日の予定 | `gog calendar events --from today --to today` |
| 今週の予定 | `gog calendar events --from today --to +7d` |
| 予定作成 | `gog calendar create primary --title "会議" --start "2024-01-15 10:00" --end "2024-01-15 11:00"` |
| 予定検索 | `gog calendar search "ミーティング"` |
| カレンダー一覧 | `gog calendar calendars` |
| 空き時間確認 | `gog calendar freebusy user1@example.com,user2@example.com --from today --to +7d` |
| 予定削除 | `gog calendar delete <calendarId> <eventId>` |

## Drive

| Purpose | Command |
|---------|---------|
| ファイル一覧 | `gog drive ls` |
| フォルダ内一覧 | `gog drive ls --parent <folderId>` |
| ファイル検索 | `gog drive search "keyword"` |
| ダウンロード | `gog drive download <fileId> --out ./file.pdf` |
| アップロード | `gog drive upload ./file.pdf --parent <folderId>` |
| フォルダ作成 | `gog drive mkdir "新規フォルダ"` |
| 共有設定 | `gog drive share <fileId> --email user@example.com --role reader` |
| 削除 | `gog drive delete <fileId>` |

## Sheets / Docs / Slides

```bash
# Sheetをエクスポート
gog sheets export <spreadsheetId> --format csv --out ./data.csv
gog sheets export <spreadsheetId> --format pdf --out ./sheet.pdf

# Docsをエクスポート
gog docs export <documentId> --format pdf --out ./doc.pdf

# Slidesをエクスポート
gog slides export <presentationId> --format pdf --out ./slides.pdf
```

## Tasks / Contacts

```bash
# タスク一覧
gog tasks list

# タスク作成
gog tasks create --title "やること"

# 連絡先検索
gog contacts search "山田"
```

## 共通オプション

| Option | Description |
|--------|-------------|
| `--json` | JSON出力（スクリプト向け） |
| `--plain` | TSV出力（パース向け） |
| `--account` | 使用するアカウント指定 |
| `--max N` | 最大取得件数 |
| `--force` | 確認スキップ |

## Tips

- `jq` と組み合わせてJSON加工: `gog gmail search 'is:unread' --json | jq '.[]'`
- 複数アカウント対応: `--account=work@company.com` で切り替え
- CI/CD向け: `--no-input` で対話プロンプト無効化
