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

function M.safe_check()
    local current_row, current_col = M.cursor_pos()
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'i' then
        return
    end
    if mode == 'v' then
        if M.selection_way == 'left' then
            if not (current_col < M.selection_start_col) and not (current_row <= M.selection_start_row) then
                M.esc()
            end
        elseif M.selection_way == 'right' then
            current_col = current_col + 1
            if not (current_col > M.selection_start_col) and not (current_row >= M.selection_start_row) then
                vim.api.nvim_feedkeys('l', 'n', false)
                M.esc()
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
