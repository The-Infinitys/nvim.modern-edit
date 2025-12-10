local M = {}
local selection_lib = require("modern-edit.lib.selection")
function M.process()
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'v' then
        M.on_visual()
    elseif mode == 'i' then
        M.on_insert()
    end
end

function M.on_visual()
     if selection_lib.selection_way == 'left' then
        selection_lib.selection_way = 'up'
    end
    local current_row, _ = selection_lib.cursor_pos()
    if current_row == 1 then
        local key = vim.api.nvim_replace_termcodes('0', true, true, true)
        vim.api.nvim_feedkeys(key, 'n', false)
    else
        local key = vim.api.nvim_replace_termcodes('k', true, true, true)
        vim.api.nvim_feedkeys(key, 'v', false)
    end
end

function M.on_insert()
    selection_lib.selection_way = 'up'
    selection_lib.selection_start_row,
    selection_lib.selection_start_col = selection_lib.cursor_pos()
    local current_row, _ = selection_lib.cursor_pos()
    local move_key
    if current_row == 1 then
        move_key = vim.api.nvim_replace_termcodes('0', true, true, true)
    else
        move_key = vim.api.nvim_replace_termcodes('kl', true, true, true)
    end

    local key = vim.api.nvim_replace_termcodes('<C-o>h<C-o>v', true, true, true)
    vim.api.nvim_feedkeys(key .. move_key, 'i', false)
end

return M
