-- init.lua
--
-- 最小構成の neovim 設定。今のところ主目的は life リポジトリの
-- キーロガー（scripts/vim-keylog.lua）を読み込むこと。
-- 記録ロジックの実体は life 側に一本化し、ここには「読み込む数行」だけ置く。

-- ── life リポジトリの場所を解決する ──────────────────────────────
-- dotfiles と life は ghq の兄弟ディレクトリ（.../github.com/iskw9973/{dotfiles,life}）
-- なので、symlink 元をたどって life を自動検出する。見つからなければ
-- $LIFE_DIR や代表的な ghq パスにフォールバックする。パス直書きは不要。
local function find_life()
  local candidates = {}

  -- 1) 明示指定があれば最優先
  if vim.env.LIFE_DIR and #vim.env.LIFE_DIR > 0 then
    candidates[#candidates + 1] = vim.env.LIFE_DIR
  end

  -- 2) symlink 実体をたどって ghq 兄弟の life を推定
  --    ~/.config/nvim -> <dotfiles>/.config/nvim を resolve し、.. を2つ上って
  --    <dotfiles> -> その親（.../iskw9973）配下の life を見る
  local cfg = vim.fn.resolve(vim.fn.stdpath("config"))
  local dotfiles = vim.fn.fnamemodify(cfg, ":h:h") -- .../dotfiles
  local owner_dir = vim.fn.fnamemodify(dotfiles, ":h") -- .../github.com/iskw9973
  candidates[#candidates + 1] = owner_dir .. "/life"

  -- 3) 代表的な ghq ルートのフォールバック
  candidates[#candidates + 1] = vim.fn.expand("~/Projects/ghq/github.com/iskw9973/life")
  candidates[#candidates + 1] = vim.fn.expand("~/ghq/github.com/iskw9973/life")

  for _, dir in ipairs(candidates) do
    local p = dir .. "/scripts/vim-keylog.lua"
    if vim.fn.filereadable(p) == 1 then
      return p
    end
  end
  return nil
end

-- ── キーロガーを読み込む ─────────────────────────────────────────
local keylog = find_life()
if keylog then
  pcall(dofile, keylog)
end
-- 一時無効化は `KEYLOG_OFF=1 nvim ...`。状態確認は :KeylogStatus。
