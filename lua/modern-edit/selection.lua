local M = {}

-- 現在のカーソル位置をマーク 'z' に保存 (Ctrl+A用)
local function mark_current_pos_for_select_all()
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_set_mark(0, 'z', cursor[1], cursor[2], {})
end

function M.setup(opts)
  -- 矢印キーによるVisualモードの解除
  vim.keymap.set('v', '<Left>', '<Esc>`<i', opts)
  vim.keymap.set('v', '<Right>', '<Esc>`>a', opts)
  vim.keymap.set('v', '<Up>', '<Esc>`<i<Up>', opts)
  vim.keymap.set('v', '<Down>', '<Esc>`>a<Down>', opts)

  -- Ctrl+A (全選択)
  vim.keymap.set({ 'i', 'n' }, '<C-a>', function()
    mark_current_pos_for_select_all()
    local keys = vim.api.nvim_replace_termcodes('<Esc>gg0vG$', true, false, true)
    vim.api.nvim_feedkeys(keys, 'n', true)
  end, opts)
end

return M