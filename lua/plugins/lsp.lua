return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = require("plugins/config/lsp-config"),
        opts = {
            -- options for vim.diagnostic.config()
            diagnostics = {
                underline = true,
                update_in_insert = true,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "●",
                    -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
                    -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
                    -- prefix = "icons",
                },
            },
        }
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

            tbl = null_ls.get_sources()
            print_table(tbl)

            null_ls.setup({
                border = "rounded",
                cmd = { "nvim" },
                debounce = 250,
                debug = false,
                default_timeout = 5000,
                diagnostic_config = {},
                diagnostics_format = "#{m}",
                fallback_severity = vim.diagnostic.severity.ERROR,
                log_level = "warn",
                notify_format = "[null-ls] %s",
                on_init = nil,
                on_exit = nil,
                root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "Makefile", ".git"),
                should_attach = nil,
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.diagnostics.eslint,
                    null_ls.builtins.completion.spell,
                },
                temp_dir = nil,
                update_in_insert = false,
                -- formatting on save
                --on_attach = function(client, bufnr)
                --	if client.supports_method("textDocument/formatting") then
                --		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                --		vim.api.nvim_create_autocmd("BufWritePre", {
                --			group = augroup,
                --			buffer = bufnr,
                --			callback = function()
                --				vim.lsp.buf.format({ bufnr = bufnr })
                --			end,
                --		})
                --	end
                --end,
            }) -- end of setup
        end,
    },
}
