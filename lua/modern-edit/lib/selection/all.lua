local M = {}


function M.process()
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'v' then
        M.on_visual()
    elseif mode == 'i' then
        M.on_insert()
    end
end

function M.on_visual()
    local key = vim.api.nvim_replace_termcodes("<Esc><C-o>gg<C-o>0<C-o>vG$", true, true, true)
    vim.api.nvim_feedkeys(key, 'v', false)
end

function M.on_insert()
    local key = vim.api.nvim_replace_termcodes("<C-o>gg<C-o>0<C-o>vG$", true, true, true)
    vim.api.nvim_feedkeys(key, 'v', false)
end

return M
