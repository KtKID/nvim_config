return {
  {
    "williamboman/mason.nvim",
    event = "BufNewFile",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
      "MasonUpdate",    -- AstroNvim extension here as well
      "MasonUpdateAll", -- AstroNvim specific
    },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "flake8",
      },
      ui = {
        icons = {
          package_installed = "✓",
          package_uninstalled = "✗",
          package_pending = "⟳",
        },
      },
    },
    build = ":MasonUpdate",
    -- config = function(_, opts)
    --   require("mason").setup(opts)
    --   local mr = require("mason-registry")
    --   local function ensure_installed()
    --     for _, tool in ipairs(opts.ensure_installed) do
    --       local p = mr.get_package(tool)
    --       if not p:is_installed() then
    --         p:install()
    --       end
    --     end
    --   end
    --   if mr.refresh then
    --     mr.refresh(ensure_installed)
    --   else
    --     ensure_installed()
    --   end

    --   -- require("plugins/config/mason-lspconfig").setup()
    --   -- require("plugins/config/mason-lspconfig")
    -- end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "BufReadPre",
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls", "clangd" },
      }
      local utils = require("core.utils")
      require("mason-lspconfig").setup_handlers({
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          if server_name == "lua_ls" then
            require("lspconfig")[server_name].setup {
              capabilities = utils.Capabilities(),
              settings = {
                Lua = {
                  diagnostics = {
                    enable = true,
                    globals = { "vim" },
                  },
                },
              },
            }
            return
          else
            require("lspconfig")[server_name].setup {}
          end
        end,
        -- Next, you can provide a dedicated handler for specific servers.
        -- For example, a handler override for the `rust_analyzer`:
        -- ["rust_analyzer"] = function ()
        --     require("rust-tools").setup {}
        -- end
      })
    end,
  }
}
