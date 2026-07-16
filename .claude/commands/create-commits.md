# Create Commits

変更内容を確認し、適切なコミットを作成してください。

## 手順

1. `git status` で変更を確認
2. `git diff` で差分を確認
3. 変更内容を論理的な単位に分割（必要に応じて）
4. 各変更に対して明確で簡潔なコミットメッセージを作成

## コミットメッセージ規約

- 英語で記述
- 先頭は動詞（Add, Fix, Update, Remove, Refactor など）
- 50文字以内を目安
- 「なぜ」その変更が必要かを意識

```bash
git add <files>
git commit -m "メッセージ"
```
