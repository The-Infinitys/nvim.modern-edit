local M = {}
function M.process()
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'i' then
        M.on_insert()
    end
    if mode == 'v' then
        M.on_visual()
    end
end

function M.on_visual()
end

function M.on_insert()
end

return M
