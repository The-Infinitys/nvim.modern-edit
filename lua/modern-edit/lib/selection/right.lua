local M = {}

local selection_lib = require("modern-edit.lib.selection")


-- 現在のバッファの総行数を取得
local function get_total_line_count()
    return vim.api.nvim_buf_line_count(0)
end

-- 現在の行のバイト長を取得
local function get_current_line_byte_length()
    local line_text = vim.api.nvim_get_current_line()
    return string.len(line_text)
end

-- [[ モード別処理 ]] ----------------------------------------------------

function M.process()
    -- 現在のモードを取得
    local mode = vim.api.nvim_get_mode().mode

    -- ビジュアルモードの主要なモードをまとめてチェック
    if mode == 'v' then
        M.on_visual()
        -- インサートモードの主要なモードをまとめてチェック
    elseif mode == 'i' then
        M.on_insert()
    end
end

function M.on_visual()
       if selection_lib.selection_way == 'down' then
        selection_lib.selection_way = 'right'
    end
 local current_row, current_col = selection_lib.cursor_pos()
    local current_line_byte_length = get_current_line_byte_length()
    local total_lines = get_total_line_count()

    -- 判定条件:
    -- 1. カーソルが**行末**にあるか？ (列番号がバイト長と一致するか)
    -- 2. **次の行**が存在するか？ (現在の行番号 < 総行数)
    if current_col == current_line_byte_length and current_row < total_lines then
        -- 条件を満たす場合: 次の行の先頭へカーソルを移動させる (j)
        -- 'j'キーはビジュアルモードで押されると、選択範囲を次の行まで拡張します。
        local key = vim.api.nvim_replace_termcodes('j0', true, true, true)
        -- ビジュアルモードのキー操作は「ノーマルモード」として解釈させるのが適切
        vim.api.nvim_feedkeys(key, 'v', false)
    else
        -- 条件を満たさない場合: 通常の 'l' キー操作を実行（右へ移動）
        local key = vim.api.nvim_replace_termcodes('l', true, true, true)
        vim.api.nvim_feedkeys(key, 'v', false) -- モードを 'n' に修正
    end
end

function M.on_insert()
    selection_lib.selection_way = 'right'
    selection_lib.selection_start_row,
    selection_lib.selection_start_col = selection_lib.cursor_pos()
    local key = vim.api.nvim_replace_termcodes('<C-o>v', true, true, true)
    vim.api.nvim_feedkeys(key, 'i', false)
end

return M
