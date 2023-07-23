-- Desc: Bootstrap the core
_G.core = {}

core.plugins = {}
core.plugins.path = vim.fn.stdpath("config") .. "/lua/plugins"

core.win_border = { '󱔐', '󱔐', '󱔐', '', '󱔐', '󱔐', '󱔐', '' }
core.cmp_border = {}

core.heirline_support_filetype = { "lua", "cpp" }

--一些配置
vim.o.number = true
vim.o.shiftwidth = 4
vim.o.numberwidth = 4 -- always reserve 3 spaces for line number
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4 -- 设置自动缩进的宽度为 4 个空格
vim.o.expandtab = true
vim.o.autoindent = true

-- 搜索忽略大小写
vim.o.ignorecase = true
-- 搜索大写自动过滤小写
vim.o.smartcase = true

-- 显示光标所在行线
vim.o.cursorline = true

-- 终端真彩色
vim.o.termguicolors = true
vim.signcolumn = "yes"

-- 折叠代码
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
-- 将.lua.txt 视为 lua
vim.api.nvim_exec([[ autocmd BufNewFile,BufRead *.lua.txt set filetype=lua ]], false)

--
vim.fn.sign_define("DiagnosticSignError",
    { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",
    { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",
    { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",
    { text = "󰧑", texthl = "DiagnosticSignHint" })
-- print(vim.fn.stdpath("data"))
-- print(vim.fn.stdpath("cache"))
-- vim.api.nvim_create_autocmd('xgt',{function ()
--     print("xgt autocmd")

-- end})
