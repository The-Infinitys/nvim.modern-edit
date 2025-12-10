local M = {}

function M.setup(opts)
    vim.api.nvim_set_keymap('i', '<C-a>', '<C-o>vgg0<Esc><C-o>vG$', { noremap = true })
end

return M
