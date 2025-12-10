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
    local current_row, current_col = require("modern-edit.lib.selection").cursor_pos()
    if current_col == 0 and current_row > 1 then
        -- 条件を満たす場合: 前の行の行末へカーソルを移動させる (k$)
        -- 'k$'キーはビジュアルモードで押されると、選択範囲を前の行の行末まで拡張します。
        local key = vim.api.nvim_replace_termcodes('k$', true, true, true)
        vim.api.nvim_feedkeys(key, 'v', false)
    else
        -- 条件を満たさない場合: 通常の 'h' キー操作を実行（左へ移動）
        local key = vim.api.nvim_replace_termcodes('h', true, true, true)
        vim.api.nvim_feedkeys(key, 'v', false)
    end
end

function M.on_insert()
    require("modern-edit.lib.selection").selection_way = 'left'
    require("modern-edit.lib.selection").selection_start_row,
    require("modern-edit.lib.selection").selection_start_col = require("modern-edit.lib.selection").cursor_pos()
    -- インサートモードから一時的にノーマルモードに移行してビジュアルモードを開始し、すぐにインサートモードに戻る
    local key = vim.api.nvim_replace_termcodes('<C-o>h<C-o>v', true, true, true)
    vim.api.nvim_feedkeys(key, 'i', false)
end


return M
