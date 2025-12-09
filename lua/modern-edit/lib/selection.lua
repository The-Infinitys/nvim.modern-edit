local M = {}

function M.setup(opts)
    vim.api.nvim_set_keymap('n', '<C-a>', 'ggVG', opts)
    vim.api.nvim_set_keymap('v', '<C-a>', 'ggVG', opts)
end

return M
