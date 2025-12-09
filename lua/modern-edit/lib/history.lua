local M = {}
function M.setup(opts)
    vim.api.nvim_set_keymap('i', '<C-z>', '<C-o>u', opts)
    vim.api.nvim_set_keymap('i', '<C-y>', '<C-o><C-r>', opts)
end

return M
