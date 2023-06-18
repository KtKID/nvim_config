return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- { "folke/neoconf.nvim", cmd = "Neoconf", config = true },--管理全局或本地配置
    -- { "folke/neodev.nvim",  opts = {} },--用于 init.lua 和插件开发的 Neovim 设置，带有 nvim lua API 的完整签名帮助、文档和完成。
    "mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    -- {
    --   "hrsh7th/cmp-nvim-lsp",
    --   cond = function()
    --     return require("lazyvim.util").has("nvim-cmp")
    --   end,
    -- },
  },
  ---@class PluginLspOpts
  opts = {
    -- options for vim.diagnostic.config()
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
        -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
        -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
        -- prefix = "icons",
      },
      severity_sort = true,
    },
    -- add any global capabilities here
    capabilities = {},
    -- Automatically format on save
    autoformat = true,
    -- Enable this to show formatters used in a notification
    -- Useful for debugging formatter issues
    format_notify = false,
    -- options for vim.lsp.buf.format
    -- `bufnr` and `filter` is handled by the LazyVim formatter,
    -- but can be also overridden when specified
    format = {
      formatting_options = nil,
      timeout_ms = nil,
    },
  },
}
