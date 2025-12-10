local M = {}

function M.setup()
  -- --- 基本設定 ---
  vim.opt.clipboard = "unnamedplus"
  vim.opt.keymodel = "stopsel"
  vim.opt.whichwrap:append("<,>,[,],b,s")
  vim.opt.virtualedit = "onemore"

  local opts = { noremap = true, silent = true }

  -- 各モジュールの設定を呼び出す
  require("modern-edit.lib.clipboard").setup(opts)
  require("modern-edit.lib.history").setup(opts)
  require("modern-edit.lib.selection").setup(opts)
end

return M