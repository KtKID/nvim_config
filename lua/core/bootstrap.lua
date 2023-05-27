-- Desc: Bootstrap the core
_G.core = {}

core.plugins = {}
core.plugins.path = vim.fn.stdpath("config").."/lua/plugins"

print("this is Bootstrap")

print(vim.fn.stdpath("data"))
print(vim.fn.stdpath("cache"))

print_table(core)
-- core.install = 

-- local function load_module_file(module)
--     local found_module = nil
-- end