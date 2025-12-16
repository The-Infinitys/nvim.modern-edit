local M = {}

-- 必要なライブラリのロード (元のコードに依存)
local selection_lib = require("modern-edit.lib.selection")

function M.process()
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'v' then
        M.on_visual() -- 関数名を変更
    elseif mode == 'i' then
        M.on_insert() -- 関数名を変更
    end
end

-- 視覚モードでの下向き動作
function M.on_visual()
    if selection_lib.selection_way == 'right' then
        selection_lib.selection_way = 'down'
    end
    local current_row = selection_lib.cursor_pos()
    -- バッファの最終行を取得
    local last_row = vim.api.nvim_buf_line_count(0)
    if current_row == last_row then
        -- 行末に移動 ('$' キー)
        local key = vim.api.nvim_replace_termcodes('$', true, true, true)
        vim.api.nvim_feedkeys(key, 'n', false)
    else
        -- 視覚モードのまま、カーソルを下に移動 ('j' キー)
        local key = vim.api.nvim_replace_termcodes('j', true, true, true)
        vim.api.nvim_feedkeys(key, 'v', false)
    end
end

-- 挿入モードでの下向き動作
function M.on_insert()
    selection_lib.selection_way = 'down'
    local current_row, current_col = selection_lib.cursor_pos()
    selection_lib.selection_start_row = current_row
    selection_lib.selection_start_col = current_col

    local last_row = vim.api.nvim_buf_line_count(0)

    if current_col == 0 then
        local key = vim.api.nvim_replace_termcodes('<C-o>v$', true, true, true)
        vim.api.nvim_feedkeys(key, 'i', false)
        return
    end

    local move_key

    if current_row == last_row then
        -- 行末に移動 ('$')
        move_key = vim.api.nvim_replace_termcodes('$', true, true, true)
    else
        move_key = vim.api.nvim_replace_termcodes('j', true, true, true)
    end
    -- <C-o>h<C-o>v の部分を、<C-o>l<C-o>v に変更する
    -- 上向き版の 'h' (左) を 'l' (右) に対応させる
    local key = vim.api.nvim_replace_termcodes('<C-o>vh', true, true, true)
    vim.api.nvim_feedkeys(key .. move_key, 'i', false)
end

function M.normal_insert()
    local current_row, _ = selection_lib.cursor_pos()
    local key
    local last_row = vim.api.nvim_buf_line_count(0)
    if current_row == last_row then
        -- 行末に移動 ('$')
        key = vim.api.nvim_replace_termcodes('<C-o>$', true, true, true)
    else
        key = vim.api.nvim_replace_termcodes('<C-o>j', true, true, true)
    end
    vim.api.nvim_feedkeys(key, 'i', false)
end

return M
