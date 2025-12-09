local M = {}

-- 現在のカーソル位置をマーク 'z' に保存
local function mark_current_pos()
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_set_mark(0, 'z', cursor[1], cursor[2], {})
end

function M.setup()
  -- --- 基本設定 ---
  vim.opt.clipboard = "unnamedplus"
  vim.opt.keymodel = "startsel,stopsel"
  vim.opt.whichwrap:append("<,>,[,],b,s")
  vim.opt.virtualedit = "onemore"

  local opts = { noremap = true, silent = true }

  -- --- 1. Visualモードの拡張 ---
  vim.keymap.set('v', '<C-c>', '"+ygv', opts)
  vim.keymap.set('v', '<C-x>', '"+x<Esc>i', opts)
  vim.keymap.set('v', '<C-v>', '"+P<Esc>i', opts)
  vim.keymap.set('v', '<BS>', '"_d<Esc>i', opts)
  vim.keymap.set('v', '<Del>', '"_d<Esc>i', opts)

  -- 矢印キーによる解除
  vim.keymap.set('v', '<Left>', '<Esc>`<i', opts)
  vim.keymap.set('v', '<Right>', '<Esc>`>a', opts)
  vim.keymap.set('v', '<Up>', '<Esc>`<i<Up>', opts)
  vim.keymap.set('v', '<Down>', '<Esc>`>a<Down>', opts)

  -- --- 2. Insertモードの拡張 ---
  vim.keymap.set('i', '<C-c>', '<Esc>"+yygi', opts)
  vim.keymap.set('i', '<C-x>', '<Esc>"+ddi', opts)
  vim.keymap.set('i', '<C-v>', '<C-g>u<C-r>+', opts)

  -- Ctrl+A
  vim.keymap.set({ 'i', 'n' }, '<C-a>', function()
    mark_current_pos()
    local keys = vim.api.nvim_replace_termcodes('<Esc>gg0vG$', true, false, true)
    vim.api.nvim_feedkeys(keys, 'n', true)
  end, opts)

  -- --- 3. Shift+矢印キー（モード判定付き） ---

  local function shift_move(move_cmd)
    local mode = vim.api.nvim_get_mode().mode

    if mode == 'i' then
      -- 挿入モードの場合:
      mark_current_pos()
      -- <Esc> (Normal) -> `z (マークへジャンプ) -> v (Visual開始) -> move_cmd (移動)
      local keys = vim.api.nvim_replace_termcodes('<Esc>`z' .. 'v' .. move_cmd, true, false, true)
      vim.api.nvim_feedkeys(keys, 'n', true)
    elseif mode == 'v' or mode == 'V' or mode == ' ' then
      -- Visual/Visual Line/Visual Blockモードの場合:
      -- Visualモードで矢印キーを押した際に選択解除されないよう、
      -- 'n' モード（Normalモードのキーを送る）として feedkeys を実行します。
      -- modeが' 'なのはVisual Blockモードです。
      -- 選択のアンカーを固定し、カーソルを移動させます。
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(move_cmd, true, false, true), 'n', true)
    end
  end

  vim.keymap.set({ 'i', 'v' }, '<S-Left>', function() shift_move('h') end, opts)
  vim.keymap.set({ 'i', 'v' }, '<S-Right>', function() shift_move('l') end, opts)
  vim.keymap.set({ 'i', 'v' }, '<S-Up>', function() shift_move('<Up>') end, opts)
  vim.keymap.set({ 'i', 'v' }, '<S-Down>', function() shift_move('<Down>') end, opts)
end

return M
