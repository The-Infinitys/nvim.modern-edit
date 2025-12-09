local M = {}

function M.setup(opts)
  -- Visualモードのクリップボード操作
  vim.keymap.set('v', '<C-c>', '"+ygv', opts)
  vim.keymap.set('v', '<C-x>', '"+x<Esc>i', opts)
  vim.keymap.set('v', '<C-v>', '"+P<Esc>i', opts)
  vim.keymap.set('v', '<BS>', '"_d<Esc>i', opts)
  vim.keymap.set('v', '<Del>', '"_d<Esc>i', opts)

  -- Insertモードのクリップボード操作
  vim.keymap.set('i', '<C-c>', '<Esc>"+yygi', opts)
  vim.keymap.set('i', '<C-x>', '<Esc>"+ddi', opts)
  vim.keymap.set('i', '<C-v>', '<C-g>u<C-r><C-o>+', opts)
end

return M