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
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local null_ls = require("null-ls")
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

            local async_formatting = function(bufnr)
                bufnr = bufnr or vim.api.nvim_get_current_buf()

                vim.lsp.buf_request(
                    bufnr,
                    "textDocument/formatting",
                    vim.lsp.util.make_formatting_params({}),
                    function(err, res, ctx)
                        if err then
                            local err_msg = type(err) == "string" and err or err.message
                            -- you can modify the log message / level (or ignore it completely)
                            vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
                            return
                        end

                        -- don't apply results if buffer is unloaded or has been modified
                        if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
                            return
                        end

                        if res then
                            local client = vim.lsp.get_client_by_id(ctx.client_id)
                            vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
                            vim.api.nvim_buf_call(bufnr, function()
                                vim.cmd("silent noautocmd update")
                            end)
                        end
                    end
                )
            end

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
                    -- null_ls.builtins.formatting.stylua,
                    null_ls.builtins.diagnostics.eslint,
                    null_ls.builtins.completion.spell,
                },
                temp_dir = nil,
                update_in_insert = false,
                -- formatting on save
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePost", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                async_formatting(bufnr)
                            end,
                        })
                    end
                end,
            }) -- end of setup
        end,
    },
}
