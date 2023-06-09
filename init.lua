
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

for _, core in ipairs {
	"core.utils",
	"core.bootstrap",
	"core.lazy",
	"core.mappings",
} do
	local status_ok, err = pcall(require, core)
	if not status_ok then
		vim.api.nvim_err_writeln("Failed to load " .. core .. "\n\n" .. err)
		print("Error loading " .. core .. "\n\n" .. err)
	end
end
