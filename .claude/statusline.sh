#!/bin/bash
input=$(cat)

CWD=$(echo "$input" | jq -r '.cwd // empty')
FIVE_H=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
SEVEN_D=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# rate_limitsをキャッシュ（claude-metricsが読む）
if [ -n "$FIVE_H" ] || [ -n "$SEVEN_D" ]; then
  echo "$input" | jq '{five_hour: .rate_limits.five_hour, seven_day: .rate_limits.seven_day, updated_at: now | todate}' \
    > ~/.claude/rate_limits_cache.json 2>/dev/null
fi

# cwd（常に表示）
[ -n "$CWD" ] && printf "\033[36m%s\033[0m" "$CWD"

# rate_limits（存在する場合のみ表示）
if [ -n "$FIVE_H" ] || [ -n "$SEVEN_D" ]; then
  [ -n "$FIVE_H" ]   && printf " \033[33m5h: %.0f%%\033[0m" "$FIVE_H"
  [ -n "$SEVEN_D" ]  && printf " \033[33m7d: %.0f%%\033[0m" "$SEVEN_D"
fi
