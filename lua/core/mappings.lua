local utils = require "core.utils"
local is_available = utils.is_available

-- i = insert mode n = normal mode v = visual mode t = terminal mode
local maps = { i = {}, n = {}, v = {}, t = {} }

local sections = {
  b = { desc = "󰓩 Buffers" },
  bs = { desc = "󰒺 Sort Buffers" },
  d = { desc = " Debugger" },
  f = { desc = "󰍉 Find" },
  g = { desc = "󰊢 Git" },
  l = { desc = " LSP" },
  p = { desc = "󰏖 Packages" },
  S = { desc = "󱂬 Session" },
  t = { desc = " Terminal" },
  u = { desc = " UI" },
}
if not vim.g.icons_enabled then vim.tbl_map(function(opts) opts.desc = opts.desc:gsub("^.* ", "") end, sections) end

-- Plugin Manager
local lazy = require "lazy"
maps.n["<leader>p"] = sections.p
maps.n["<leader>pi"] = { function() lazy.install() end, desc = "Plugins Install" }
maps.n["<leader>ps"] = { function() lazy.home() end, desc = "Plugins Status" }
maps.n["<leader>pS"] = { function() lazy.sync() end, desc = "Plugins Sync" }
maps.n["<leader>pu"] = { function() lazy.check() end, desc = "Plugins Check Updates" }
maps.n["<leader>pU"] = { function() lazy.update() end, desc = "Plugins Update" }


-- Alpha
if is_available "alpha-nvim" then
  maps.n["<leader>h"] = {
    function()
      local wins = vim.api.nvim_tabpage_list_wins(0)
      if #wins > 1 and vim.api.nvim_get_option_value("filetype", { win = wins[1] }) == "neo-tree" then
        vim.fn.win_gotoid(wins[2]) -- go to non-neo-tree window to toggle alpha
      end
      require("alpha").start(false, require("alpha").default_config)
    end,
    desc = "Home Screen",
  }
end


utils.set_mappings(maps)