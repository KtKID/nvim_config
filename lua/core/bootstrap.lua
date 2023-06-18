-- Desc: Bootstrap the core
_G.core = {}

core.plugins = {}
core.plugins.path = vim.fn.stdpath("config").."/lua/plugins"

--一些配置
vim.o.number = true
vim.o.shiftwidth = 4
vim.o.numberwidth = 4 -- always reserve 3 spaces for line number
-- vim.o.tabstop = 4
-- vim.o.softtabstop = 4
vim.o.expandtab = false
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

-- print(vim.fn.stdpath("data"))
-- print(vim.fn.stdpath("cache"))
