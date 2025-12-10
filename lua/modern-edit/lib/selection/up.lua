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
    local current_row, _ = require("modern-edit.lib.selection").cursor_pos()
    if current_row == 1 then
        local key = vim.api.nvim_replace_termcodes('0', true, true, true)
        vim.api.nvim_feedkeys(key, 'n', false)
    else
        local key = vim.api.nvim_replace_termcodes('k', true, true, true)
        vim.api.nvim_feedkeys(key, 'v', false)
    end
end

function M.on_insert()
    require("modern-edit.lib.selection").selection_way = 'up'
    require("modern-edit.lib.selection").selection_start_row,
    require("modern-edit.lib.selection").selection_start_col = require("modern-edit.lib.selection").cursor_pos()
    -- インサートモードから一時的にノーマルモードに移行してビジュアルモードを開始し、すぐにインサートモードに戻る
    local current_row, _ = require("modern-edit.lib.selection").cursor_pos()
    local move_key
    if current_row == 1 then
        move_key = vim.api.nvim_replace_termcodes('0', true, true, true)
    else
        move_key = vim.api.nvim_replace_termcodes('kl', true, true, true)
    end

    local key = vim.api.nvim_replace_termcodes('<C-o>h<C-o>v', true, true, true)
    vim.api.nvim_feedkeys(key..move_key, 'i', false)
end


return M
