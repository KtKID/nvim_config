vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

for _, module in ipairs({
	"core.utils",
	"core.bootstrap",
	"core.lazy",
	"core.mappings",
}) do
	local status_ok, err = pcall(require, module)
	if not status_ok then
		vim.api.nvim_err_writeln("Failed to load " .. module .. "\n\n" .. err)
		print("Error loading " .. module .. "\n\n" .. err)
	end
end
