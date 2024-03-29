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
            -- pcall(require, "neodev")
            require("lspconfig")[server_name].setup {
              capabilities = utils.Capabilities(),
              settings = {
                Lua = {
                  workspace = {
                    library = {
                      [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                      [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                    },
                    maxPreload = 100000,
                    preloadFileSize = 1000,
                  },
                  runtime = {
                    -- LuaJIT in the case of Neovim
                    version = "LuaJIT",
                    path = { "?.lua", "?.lua.txt", "{workspace}/?.lua", "{workspace}/?.lua.txt" },
                  },
                  diagnostics = {
                    enable = true,
                    globals = { "vim", "Color", "UIUtils" },
                    severity = {
                      ["undefined-global"] = "Error!",
                    },
                    neededFileStatus = {
                      ["undefined-global"] = "Any",
                    }
                  },
                },
              },
              on_attach = function(client, bufnr)
                print_file("lua_ls on_attach")
                local navic = require("nvim-navic")
                navic.attach(client, bufnr)
              end
            }
            return
          elseif server_name == "clangd" then
            require("lspconfig")[server_name].setup {
              capabilities = utils.Capabilities(),
              on_attach = function(client, bufnr)
                print_file("clangd on_attach")
                local navic = require("nvim-navic")
                if navic then
                  navic.attach(client, bufnr)
                end
              end
            }
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
