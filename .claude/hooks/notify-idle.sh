#!/bin/bash
# Claude Code Notification hook - 入力待ちを通知する

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

# 通知を送る
terminal-notifier -title "Claude Code" -subtitle "$PROJECT_NAME" -message "入力待ちです" -sound Blow -contentImage ~/.claude/assets/claude-icon.png
