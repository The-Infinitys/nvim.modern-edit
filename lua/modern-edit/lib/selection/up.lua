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
    local current_row, current_col = selection_lib.cursor_pos()
    local visual_key = vim.api.nvim_replace_termcodes('<C-o>v', true, true, true)
    local key
    if current_col == 0 and current_row > 1 then
        key = vim.api.nvim_replace_termcodes('<C-o>k<C-o>$<C-o>v0', true, true, true)
        vim.api.nvim_feedkeys(key, 'i', false)
        return
    else
        key = vim.api.nvim_replace_termcodes('<C-o>h', true, true, true)
    end
    local move_key
    if current_row == 1 then
        move_key = vim.api.nvim_replace_termcodes('0', true, true, true)
    else
        move_key = vim.api.nvim_replace_termcodes('kl', true, true, true)
    end
    vim.api.nvim_feedkeys(key .. visual_key .. move_key, 'i', false)
end

function M.normal_insert()
    local current_row, _ = selection_lib.cursor_pos()
    local key
    if current_row > 1 then
        key = vim.api.nvim_replace_termcodes('<C-o>k', true, true, true)
    else
        key = vim.api.nvim_replace_termcodes('<C-o>0', true, true, true)
    end
    vim.api.nvim_feedkeys(key, 'i', false)
end

return M
