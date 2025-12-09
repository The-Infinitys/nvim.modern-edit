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
      -- 挿入モード：マークしてVisualモードを開始
      mark_current_pos()
      local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
      vim.api.nvim_feedkeys(esc, 'n', true)
      if move_cmd == 'l' or move_cmd == 'j' then
        vim.api.nvim_feedkeys('l', 'v', true)
      end
      vim.api.nvim_feedkeys('v', 'n', true)
      if move_cmd == 'j' or move_cmd == 'k' then
        vim.api.nvim_feedkeys(move_cmd, 'v', true)
        if move_cmd == 'k' then
          vim.api.nvim_feedkeys('l', 'v', true)
        else
          vim.api.nvim_feedkeys('h', 'v', true)
        end
      end
    else
      -- すでにVisualモード：そのまま移動（stopselを上書きするために直接 feedkeys）
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(move_cmd, true, false, true), 'v', true)
    end
  end

  vim.keymap.set({ 'i', 'v' }, '<S-Left>', function() shift_move('h') end, opts)
  vim.keymap.set({ 'i', 'v' }, '<S-Right>', function() shift_move('l') end, opts)
  vim.keymap.set({ 'i', 'v' }, '<S-Up>', function() shift_move('k') end, opts)
  vim.keymap.set({ 'i', 'v' }, '<S-Down>', function() shift_move('j') end, opts)
end

return M
