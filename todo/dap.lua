return {
    "mfussenegger/nvim-dap",
    enabled = true, --vim.fn.has "win32" == 0,
    event = "BufReadPre",
    module = { "dap" },
    wants = { "nvim-dap-virtual-text", "DAPInstall.nvim", "nvim-dap-ui", "nvim-dap-python", "which-key.nvim" },
    dependencies = {
        {
            "jay-babu/mason-nvim-dap.nvim",
            dependencies = { "nvim-dap" },
            cmd = { "DapInstall", "DapUninstall" },
            opts = { handlers = {} },
            -- config = function()
            --     require("mason-nvim-dap").setup()
            -- end,
        },
        {
            "rcarriga/nvim-dap-ui",
            opts = { floating = { border = "rounded" } },
            config = require "plugins.config.nvim-dap-ui-config",
        },
        {
            "alpha2phi/DAPInstall.nvim",
        },
        {
            "nvim-telescope/telescope-dap.nvim",
        },
        {
            "jbyuki/one-small-step-for-vimkind", module = "osv",
        },
    },
    -- config = function()
    --     require("plugins.config.dap.dap-install").setup()
    -- end
}
