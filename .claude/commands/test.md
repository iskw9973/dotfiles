# Test

指定されたコードのテストを生成してください。

## 対象

ユーザーが指定したファイルまたは関数。

## テスト方針

1. **正常系**: 期待される入力での動作
2. **異常系**: エラーケース、例外処理
3. **境界値**: 0、空、null、最大値
4. **エッジケース**: 特殊な状況

## フレームワーク検出

プロジェクトの設定を確認:
- `vitest.config.*` → Vitest
- `jest.config.*` → Jest
- `playwright.config.*` → Playwright
- `*.test.ts` / `*.spec.ts` の既存パターン

## 出力形式

```typescript
import { describe, it, expect } from 'vitest'
import { targetFunction } from './target'

describe('targetFunction', () => {
  it('should return expected value for normal input', () => {
    expect(targetFunction(input)).toBe(expected)
  })

  it('should throw error for invalid input', () => {
    expect(() => targetFunction(invalid)).toThrow()
  })

  it('should handle edge case', () => {
    expect(targetFunction(edge)).toBe(expected)
  })
})
```

## 注意

- 既存のテストスタイルに合わせる
- モックは最小限に
- テスト名は日本語でも可（プロジェクトに合わせる）
