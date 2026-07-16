# Create Pull Request

現在の変更からPRを作成してください。

## 手順

1. 変更内容を確認（`git log`）
2. リモートにプッシュ
3. PRを作成

```bash
git push -u origin HEAD
```

## PR作成

```bash
gh pr create --title "タイトル" --body "説明"
```

## PR本文テンプレート

```markdown
## Summary
- 変更の要約（箇条書き）

## Test plan
- [ ] テスト項目
```
