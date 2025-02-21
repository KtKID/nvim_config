return {
    -- Tips
    {
        "rcarriga/nvim-notify",
        keys = {
            {
                "<leader>un",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Dismiss all Notifications",
            },
        },
        opts = {
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 1)
            end,
        },
        event = "VeryLazy",
        config = function()
            vim.notify = require("notify")
        end
    },
    {
        "nvim-lua/plenary.nvim", lazy = true
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("plugins.config.nvim-tree")
        end
    },
    {
        "folke/noice.nvim", --还没配置完
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("plugins/config/noice")()
        end,
    },
    {
        "Shatur/neovim-session-manager",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        -- config = require("plugins.config.session-config")
    },
    {
        "SmiteshP/nvim-navic",
        -- lazy = true,
        -- event = "BufEnter",
        -- require("nvim-navic").setup()
    },
    {
        "rebelot/heirline.nvim",
        event = "BufEnter",
        dependencies = {
            "SmiteshP/nvim-navic",
        },
        config = function()
            require("plugins.config.heirline-config")
        end
    },
    {
        "numToStr/Comment.nvim",
        -- event = "BufEnter",
        config = require("plugins.config.Comment-config"),
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("plugins.config.autopairs-config")
        end
    },
    {
        "kevinhwang91/nvim-ufo",
        event = { "InsertEnter" },
        dependencies = { "kevinhwang91/promise-async" },
        config = function()
            require("plugins.config.ufo-config")
        end
    },
    {
        'stevearc/aerial.nvim',
        event = "BufReadPost",
        -- enabled = false,
        -- Optional dependencies
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        -- config = require("plugins.config.aerial-config")
        config = function()
            require("plugins.config.aerial-config")
        end
    },
    {
        'nvim-telescope/telescope-project.nvim',
    },
    {
        'akinsho/toggleterm.nvim',
        -- version = "*",
        -- cmd = { "ToggleTerm", "TermExec" },
        event = "VeryLazy",
        config = function()
            require("plugins.config.term-config")
        end
    },
    {
        "Kurama622/llm.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
        cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
        config = function ()
            require("plugins.config.llmcode-config")
        end
    }
    -- {
    --     'anuvyklack/pretty-fold.nvim',--折叠代码
    --     config = function()
    --         require('pretty-fold').setup()
    --     end
    -- },
    -- {
    --     "nvim-neo-tree/neo-tree.nvim", --TODO 配置快捷键
    --     dependencies = {
    --         "nvim-tree/nvim-web-devicons",
    --         "MunifTanjim/nui.nvim",
    --     },
    --     event = "VeryLazy",
    --     -- cmd = "ntree",
    --     print("neo tree!!"),
    --     config = require("plugins/config/neo-tree"),
    -- },
}
