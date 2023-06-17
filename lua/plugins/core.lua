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
    { "nvim-lua/plenary.nvim", lazy = true },
    {
        "nvim-neo-tree/neo-tree.nvim", --TODO 配置快捷键
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        event = "VeryLazy",
        -- cmd = "ntree",
        print("neo tree!!"),
        config = require("plugins/config/neo-tree"),
    },
    -- {
    --     "folke/noice.nvim",
    --     dependencies = {
    --         "MunifTanjim/nui.nvim",
    --         "rcarriga/nvim-notify",
    --     },
    --     config = function()
    --     	require("plugins/config/noice")()
    --     end,
    -- },
}
