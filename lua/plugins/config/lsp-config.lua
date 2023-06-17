return function()
    require("lspconfig.ui.windows").default_options.border = "rounded"

    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    -- vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
    -- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
    -- vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
    -- vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

    local mappings = {
        n = {
            ["gh"] = { function() vim.diagnostic.open_float() end,
                desc = "Hover diagnostics",
            },
            ["gg"] = { function() vim.lsp.buf.definition() end,
                desc = "Show the definition of current symbol",
            },
            ["gr"] = {
                function() 
                    -- vim.lsp.buf.references() 
                    require("telescope.builtin").lsp_references(require('telescope.themes').get_dropdown({}))
                end,
                desc = "References of current symbol",
            }
        }
    }
    print("set lsp mappings")
    require("core/utils").set_mappings(mappings)
end
