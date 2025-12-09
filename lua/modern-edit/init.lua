local M = {}

-- 現在のカーソル位置をマーク 'z' に保存
local function mark_current_pos()
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_set_mark(0, 'z', cursor[1], cursor[2], {})
end

-- mark 'z' の位置を取得するヘルパー関数
local function get_mark_z_pos()
  -- nvim_buf_get_markは非推奨のため、nvim_buf_get_extmark_by_id を使用するか、
  -- nvim_buf_get_markの戻り値 (行, 列) を使用する
  local mark_pos = vim.api.nvim_buf_get_mark(0, 'z')
  if mark_pos[1] == 0 then return nil end -- マークが存在しない、または無効
  return { line = mark_pos[1], col = mark_pos[2] }
end

local function shift_move(move_cmd)
  local mode = vim.api.nvim_get_mode().mode
  local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
  local current_cursor = vim.api.nvim_win_get_cursor(0)
  local is_at_line_head = current_cursor[2] == 0

  -- Visualモードからの操作の場合の特別な処理
  if mode:match('^[vVsS]$') then
    local mark_z = get_mark_z_pos()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(move_cmd, true, false, true), 'v', true)
    if mark_z then
      vim.defer_fn(function()
        local new_cursor = vim.api.nvim_win_get_cursor(0)
        if new_cursor[1] == mark_z.line and new_cursor[2] == mark_z.col then
          local keys = esc .. 'i'
          vim.api.nvim_feedkeys(keys, 'n', true)
        end
      end, 5)
    end
  elseif mode == 'i' then
    mark_current_pos()
    vim.api.nvim_feedkeys(esc, 'n', false)
    if not is_at_line_head and move_cmd == 'l' then
      vim.api.nvim_feedkeys('l', 'n', false)
    end
    vim.api.nvim_feedkeys('v', 'n', false)

    if move_cmd == 'l' or move_cmd == 'j' then
      vim.api.nvim_feedkeys('l', 'v', false)
    end
    if is_at_line_head and move_cmd == 'l' then
      vim.api.nvim_feedkeys('h', 'v', false)
    end
    if move_cmd == 'j' or move_cmd == 'k' then
      vim.api.nvim_feedkeys(move_cmd, 'v', false)
      if move_cmd == 'k' then
        vim.api.nvim_feedkeys('l', 'v', false)
      end
    end
    if not is_at_line_head and move_cmd == 'l' then
      vim.api.nvim_feedkeys('h', 'n', false)
    end
  end
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
  vim.keymap.set('i', '<C-v>', '<C-g>u<C-r><C-o>+', opts)

  -- Ctrl+A
  vim.keymap.set({ 'i', 'n' }, '<C-a>', function()
    mark_current_pos()
    local keys = vim.api.nvim_replace_termcodes('<Esc>gg0vG$', true, false, true)
    vim.api.nvim_feedkeys(keys, 'n', true)
  end, opts)

  vim.keymap.set({ 'i', 'v' }, '<S-Left>', function() shift_move('h') end, opts)
  vim.keymap.set({ 'i', 'v' }, '<S-Right>', function() shift_move('l') end, opts)
  vim.keymap.set({ 'i', 'v' }, '<S-Up>', function() shift_move('k') end, opts)
  vim.keymap.set({ 'i', 'v' }, '<S-Down>', function() shift_move('j') end, opts)
end

return M
