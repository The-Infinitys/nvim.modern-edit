local M = {}
function M.setup(opts)
    vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', opts)
    vim.api.nvim_set_keymap('i', '<C-s>', '<Esc>:w<CR>i', opts)
    vim.api.nvim_set_keymap('v', '<C-s>', '<Esc>:w<CR>', opts)
end

return M
