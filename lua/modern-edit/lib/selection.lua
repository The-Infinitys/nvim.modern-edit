local M = {}

function M.init()
    M.selection_way = 'none'
    M.selection_start_row = 1
    M.selection_start_col = 0
end

function M.esc()
    local key = vim.api.nvim_replace_termcodes('<Esc>', true, true, true)
    vim.api.nvim_feedkeys(key, 'n', false)
    M.init()
end

--- 指定された位置の次の文字の位置を返します。
-- @param row number 1から始まる行番号
-- @param col number 0から始まる列番号 (バイトインデックス)
-- @return next_row number 次の行番号
-- @return next_col number 次の列番号
function M.next_pos(row, col)
    -- 現在の行の内容を取得 (行番号は1-based)
    -- nvim_buf_get_linesは0-basedの行インデックスを受け取るため、row - 1 を使用
    -- 最後の引数 false は 'end' 行を含まないことを意味する
    local lines = vim.api.nvim_buf_get_lines(0, row - 1, row, false)
    local line_content = lines[1] or ""
    local line_len = #line_content

    -- 次の文字の位置を計算
    local next_col = col + 1

    -- 行末を超えているかチェック
    if next_col > line_len then
        -- 次の行へ移動
        local last_line_num = vim.api.nvim_buf_line_count(0)
        if row < last_line_num then
            local next_row = row + 1
            next_col = 0 -- 次の行の最初の文字は列0
            return next_row, next_col
        else
            -- 最終行の行末の場合、移動せず現在の位置を返す（またはnilを返すなどの判断も可能）
            return row, col
        end
    else
        -- 同じ行内で次の位置へ移動
        return row, next_col
    end
end

--- 指定された位置の前の文字の位置を返します。
-- @param row number 1から始まる行番号
-- @param col number 0から始まる列番号 (バイトインデックス)
-- @return prev_row number 前の行番号
-- @return prev_col number 前の列番号
function M.previous_pos(row, col)
    -- 前の文字の位置を計算
    local prev_col = col - 1

    -- 行頭を超えているかチェック
    if prev_col < 0 then
        -- 前の行へ移動
        if row > 1 then
            local prev_row = row - 1
            -- 前の行の行末の列番号を取得
            local prev_lines = vim.api.nvim_buf_get_lines(0, prev_row - 1, prev_row, false)
            local prev_line_content = prev_lines[1] or ""
            prev_col = #prev_line_content -- 前の行の最後の文字の列番号（0-basedバイトインデックス）
            return prev_row, prev_col
        else
            -- 最初の行の行頭の場合、移動せず現在の位置を返す
            return row, col
        end
    else
        -- 同じ行内で前の位置へ移動
        return row, prev_col
    end
end

function M.cursor_pos()
    -- 0 は現在のウィンドウ (current window) を意味します
    -- 戻り値は {行番号, 列番号} の配列 (Luaのテーブル)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    -- Luaのテーブルのインデックスは1から始まるため、
    -- 行番号は cursor_pos[1]、列番号は cursor_pos[2] です
    local row = cursor_pos[1]
    local col = cursor_pos[2]
    return row, col
end

function M.recheck_way()
    local current_row, current_col = M.cursor_pos()
    if current_row > M.selection_start_row then
        M.selection_way = 'down'
    elseif current_row < M.selection_start_row then
        M.selection_way = 'up'
    else
        if current_col > M.selection_start_col then
            M.selection_way = 'right'
        elseif current_col < M.selection_start_col then
            M.selection_way = 'left'
        else
            M.selection_way = 'none'
        end
    end
    return M.selection_way
end

function M.reselect()
    local mode = M.recheck_way()
    vim.api.nvim_feedkeys('o', 'v', false)
    if mode == 'left' or mode == 'up' then
        require("lua.modern-edit.lib.selection.left").on_visual()
        vim.api.nvim_feedkeys('o', 'v', false)
        require("lua.modern-edit.lib.selection.right").on_visual()
    elseif mode == 'right' or mode == 'down' then
        require("lua.modern-edit.lib.selection.right").on_visual()
        vim.api.nvim_feedkeys('o', 'v', false)
        require("lua.modern-edit.lib.selection.left").on_visual()
    else
        return
    end
    M.selection_way = mode
end

function M.safe_check()
    local current_row, current_col = M.cursor_pos()
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'i' then
        return
    end
    if mode == 'v' then
        if M.selection_way == 'left' or M.selection_way == 'up' then
            if not (current_row < M.selection_start_row) then
                if current_row == M.selection_start_row then
                    if not (current_col < M.selection_start_col) then
                        if current_col == M.selection_start_col then
                            M.esc()
                        else
                            M.reselect()
                        end
                    end
                else
                    M.reselect()
                end
            end
        elseif M.selection_way == 'right' then
            current_col = current_col + 1
            if not (current_row > M.selection_start_row) then
                if current_row == M.selection_start_row then
                    if not (current_col > M.selection_start_col) then
                        if current_col == M.selection_start_col then
                            vim.api.nvim_feedkeys('l', 'n', false)
                            M.esc()
                        else
                            M.reselect()
                        end
                    end
                else
                    M.reselect()
                end
            end
        elseif M.selection_way == 'down' then
            current_col = current_col + 1
            if not (current_row > M.selection_start_row) then
                if current_row == M.selection_start_row then
                    if not (current_col > M.selection_start_col) then
                        if current_col == M.selection_start_col then
                            M.esc()
                        else
                            M.reselect()
                        end
                    end
                else
                    M.reselect()
                end
            end
        end
    end
end

function M.setup(opts)
    M.init()
    vim.api.nvim_set_keymap('i', '<C-a>', '<C-o>vgg0<Esc><C-o>vG$', { noremap = true, silent = true })
    vim.keymap.set('i', '<S-Left>', function()
        require("modern-edit.lib.selection.left").process()
        vim.schedule(function()
            M.safe_check()
        end)
    end, opts)
    vim.keymap.set('v', '<S-Left>', function()
        require("modern-edit.lib.selection.left").process()
        vim.schedule(function()
            M.safe_check()
        end)
    end, opts)
    vim.keymap.set('i', '<S-Right>', function()
        require("modern-edit.lib.selection.right").process()
        vim.schedule(function()
            M.safe_check()
        end)
    end, opts)
    vim.keymap.set('v', '<S-Right>', function()
        require("modern-edit.lib.selection.right").process()
        vim.schedule(function()
            M.safe_check()
        end)
    end, opts)
    vim.keymap.set('i', '<S-Up>', function()
        require("modern-edit.lib.selection.up").process()
        vim.schedule(function()
            M.safe_check()
        end)
    end, opts)
    vim.keymap.set('v', '<S-Up>', function()
        require("modern-edit.lib.selection.up").process()
        vim.schedule(function()
            M.safe_check()
        end)
    end, opts)
    vim.keymap.set('i', '<S-Down>', function()
        require("modern-edit.lib.selection.down").process()
        vim.schedule(function()
            M.safe_check()
        end)
    end, opts)
    vim.keymap.set('v', '<S-Down>', function()
        require("modern-edit.lib.selection.down").process()
        vim.schedule(function()
            M.safe_check()
        end)
    end, opts)
end

return M
