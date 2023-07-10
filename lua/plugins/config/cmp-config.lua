return function()
    local cmp = require("cmp")
    -- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local luasnip = require('luasnip')
    local lspkind = require('lspkind')

    local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
    end

    cmp.setup({
        -- print("cmp setup")
        enabled = function()
            if require "cmp.config.context".in_treesitter_capture("comment") == true or require "cmp.config.context".in_syntax_group("Comment") then
                return false
            else
                return true
            end
        end,
        snippet = {
            expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        duplicates = {
            nvim_lsp = 1,
            luasnip = 1,
            cmp_tabnine = 1,
            buffer = 1,
            path = 1,
        },
        view = {
            entries = { name = 'custom', selection_order = 'near_cursor' }
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        mapping = {
            ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
            ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
            ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
            ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
            ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
            ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
            ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
            ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
            ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            ["<C-y>"] = cmp.config.disable,
            ["<C-e>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
            ["<CR>"] = cmp.mapping.confirm { select = false },
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),
            -- ["<S-Tab>"] = cmp.mapping(function(fallback)
            --     if cmp.visible() then
            --         cmp.select_prev_item()
            --     elseif luasnip.jumpable(-1) then
            --         luasnip.jump(-1)
            --     else
            --         fallback()
            --     end
            -- end, { "i", "s" }),
        },
        sources = cmp.config.sources({
            { name = "luasnip",  priority = 1000 },
            { name = "nvim_lsp", priority = 700 },
            { name = 'copilot',  priority = 501 },
            { name = "buffer",   priority = 500 },
            { name = "path",     priority = 250 },
        }, {
            { name = "LSP" }, { name = "Luasnip" }, { name = "Buffer" }, { name = "Path" }
        }),
        formatting = {
            format = lspkind.cmp_format({
                mode = "symbol",
                menu = ({
                    buffer = "[Buffer]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                    nvim_lua = "[Lua]",
                    latex_symbols = "[Latex]",
                })
            }),
        },
    })
    -- cmp.event:on(
    --     'confirm_done',
    --     cmp_autopairs.on_confirm_done()
    -- )
end
