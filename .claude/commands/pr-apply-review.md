# Apply PR Review

PRのレビューコメントに対応してください。

## 手順

1. PRのレビューコメントを確認
   ```bash
   gh pr view --comments
   gh pr checks
   ```

2. 指摘事項を修正

3. 変更をプッシュ

```bash
# 修正をコミット
git add <files>
git commit --fixup <commit-hash>
git rebase -i --autosquash origin/main
git push --force-with-lease
```

## レビュー対応のコツ

- 1つの指摘に対して1つのコミット
- コミットメッセージで何を修正したか明記
- 全ての指摘に対応したことを確認
