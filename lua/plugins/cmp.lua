return {
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = require "plugins.config.luasnip-config",
    },
    {
        "onsails/lspkind.nvim",
        enabled = true,
        config = require "plugins.config.lspkind-config",
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-cmdline",
            'hrsh7th/nvim-cmp',
        },
        event = "InsertEnter",
        config = require("plugins/config/cmp-config"),
    }

}
