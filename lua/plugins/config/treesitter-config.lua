return function()
    local treesitter = require("nvim-treesitter")
    treesitter.setup({
        highlight = {
            enable = true,
            disable = function(_, bufnr) return vim.api.nvim_buf_line_count(bufnr) > 10000 end, -- 大于10000不高亮
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<C-space>",
                node_incremental = "<C-space>",
                scope_incremental = false,
                node_decremental = "<bs>",
            },
        },
        indent = { enable = true },
        autotag = { enable = true },
        context_commentstring = { enable = true, enable_autocmd = false },
        ensure_installed = {
            "bash",
            "c",
            "cpp",
            "c_sharp",
            "html",
            "javascript",
            "json",
            "lua",
            "luadoc",
            "luap",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "regex",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "yaml",
        },
        -- print_table(opts, true),
        -- if type(opts.ensure_installed) == "table" then
        --   ---@type table<string, boolean>
        --   local added = {}
        --   opts.ensure_installed = vim.tbl_filter(function(lang)
        --     if added[lang] then
        --       return false
        --     end
        --     added[lang] = true
        --     return true
        --   end, opts.ensure_installed)
        -- end
    })
end
