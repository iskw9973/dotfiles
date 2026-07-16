#!/bin/bash
# Claude Code Stop hook - 最後のメッセージを通知する

# stdin から JSON を読み取る
INPUT=$(cat)

# cwd を取得してプロジェクト名を抽出
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

if [[ -n "$CWD" ]]; then
  # パスからプロジェクト名を抽出（最後の2つのディレクトリ）
  PROJECT_NAME=$(echo "$CWD" | awk -F'/' '{print $(NF-1)"/"$NF}')
else
  PROJECT_NAME="不明"
fi

# transcript_path を取得
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

if [[ -n "$TRANSCRIPT_PATH" && -f "$TRANSCRIPT_PATH" ]]; then
  # 最後の assistant メッセージを取得（100文字まで）
  LAST_MSG=$(jq -rs '[.[] | select(.type == "assistant")] | last | .message.content[0].text // empty' "$TRANSCRIPT_PATH" 2>/dev/null | head -c 100)
fi

# メッセージがなければデフォルト
if [[ -z "$LAST_MSG" ]]; then
  LAST_MSG="完了しました"
fi

# 通知を送る
terminal-notifier -title 'Claude Code' -subtitle "$PROJECT_NAME" -message "$LAST_MSG" -sound Blow -contentImage ~/.claude/assets/claude-icon.png
