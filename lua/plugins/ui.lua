return {
    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        -- enabled = false,
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
        config = function()
            -- require("plugins.config.test_line")()
            require("plugins.config.lualine-config")
            require("notify")("lua line loaded")
        end,
    },
    -- Colorscheme
    {
        { "ellisonleao/gruvbox.nvim", priority = 1000 },
    }
}
