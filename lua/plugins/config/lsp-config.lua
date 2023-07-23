return function()
    require("lspconfig.ui.windows").default_options.border = "rounded"

    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    -- vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
    -- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
    -- vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
    -- vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

    local function print_workspace_folders()
        local folders = vim.lsp.buf.list_workspace_folders()
        print("Workspace folders:")
        print_table(folders)
        -- for _, folder in ipairs(folders) do
        --     print(folder)
        -- end
    end
    local mappings = {
        n = {
            ["ga"] = { vim.lsp.buf.code_action, desc = "Code action" },
            ["gh"] = { vim.lsp.buf.hover, desc = "Hover diagnostics" },
            ["gd"] = { vim.lsp.buf.definition, desc = "Show definition" },
            ["gD"] = { vim.lsp.buf.declaration, desc = "Show declaration" },
            ["gcl"] = { function()
                local clients = vim.lsp.buf_get_clients()
                if clients then
                    for _, client in ipairs(clients) do
                        if client then
                            print("Client name: " .. client.name)
                        end
                        -- if client.resolved_capabilities.document_formatting then
                        --     print("Current LSP client supports document formatting")
                        -- end
                    end
                end
            end, desc = "Show format" },
            ["gi"] = { vim.lsp.buf.implementation, desc = "Show implementation" },
            ["gr"] = {
                function()
                    -- vim.lsp.buf.references()
                    require("telescope.builtin").lsp_references(require('telescope.themes').get_dropdown({}))
                end,
                desc = "References of current symbol",
            },
            ["gR"] = { vim.lsp.buf.rename, desc = "Rename" },
            ["gp"] = { function()
                print_stack_2file("this is lsp")
            end, desc = "Show list_workspace_folders" },

            ["gsh"] = { vim.lsp.buf.signature_help, desc = "Sign help" },
            -- workspace
            ["gwa"] = { vim.lsp.buf.add_workspace_folder, desc = "Add workspace folder" },
            ["gwr"] = { vim.lsp.buf.remove_workspace_folder, desc = "Remove workspace folder" },

            -- utils
            ["gwl"] = { function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, desc = "Show list_workspace_folders" },
            ["gx"] = { function()
            end, desc = "Show list_workspace_folders" },
        }
    }
    require("core/utils").set_mappings(mappings)
end
