local utils = require "core.utils"
local is_available = utils.is_available

-- 原生vim命令
vim.api.nvim_set_keymap("i", "ii", "<Esc>", { noremap = true })

-- i = insert mode n = normal mode v = visual mode t = terminal mode
local maps = { i = {}, n = {}, v = {}, t = {} }

local sections = {
  b = { desc = "󰓩 Buffers" },
  bs = { desc = "󰒺 Sort Buffers" },
  d = { desc = " Debugger" },
  e = { desc = " Debugger123" },
  f = { desc = "󰍉 Find" },
  g = { desc = "󰊢 Git" },
  l = { desc = " LSP" },
  p = { desc = "󰏖 Packages" },
  S = { desc = "󱂬 Session" },
  t = { desc = " Terminal" },
  u = { desc = " UI" },
}

if not vim.g.icons_enabled then vim.tbl_map(function(opts) opts.desc = opts.desc:gsub("^.* ", "") end, sections) end


-- Window
maps.n["<C-h>"] = { "<C-W>h" }
maps.n["<C-l>"] = { "<C-W>l" }
maps.n["<C-j>"] = { "<C-W>j" }
maps.n["<C-k>"] = { "<C-W>k" }

maps.n["<leader>q"] = { ":qa<CR>", desc = " Quit" }

-- Tab
-- 切换到前一个 tab
maps.n["]t"] = { function() vim.cmd.tabnext() end, desc = "Next tab" }
maps.n["[t"] = { function() vim.cmd.tabprevious() end, desc = "Previous tab" }
maps.n["<leader>w"] = { function() vim.cmd.tabclose() end, desc = "Close Cur tab" }

-- Buffers
maps.n["<leader>b"] = { desc = "󰓩 Buffers" } -- sections.b
maps.n["<A-h>"] = { "<cmd>bprev<cr>", desc = "Previous Buffer" }
maps.n["<A-l>"] = { "<cmd>bnext<cr>", desc = "Next Buffer" }
maps.n["<A-q>"] = {
  function()
    -- 获取当前窗口的缓冲区号
    local bufnr = vim.api.nvim_get_current_buf()

    vim.cmd("bprevious")

    -- 关闭当前文件所在的缓冲区
    vim.api.nvim_buf_delete(bufnr, { force = false })
  end,
  desc = "Close Cur Buffer"
}

-- File
maps.n["<C-s>"] = { "<cmd>w<cr>", desc = "Save" }
maps.n["<C-q>"] = {
  function()
    print("lead <C>q")
    local tree = require("plugins.config.nvim-tree")
    tree.set_focus()
  end,
  desc = "Save"
}

-- Explorer

maps.n["<leader>e"] = {
  function()
    -- require("neo-tree.command").execute({ toggle = true, dir = vim.fn.stdpath("config") })
    local tree = require("plugins.config.nvim-tree")
    if tree.toggle() then
      local filePath = vim.fn.expand('%:p')
      if filePath then
        print(filePath)
        require("nvim-tree.api").tree.open({ find_file = true })
        -- require("nvim-tree.api").tree.change_root({ filePath })
      else
        require("nvim-tree.api").tree.open({ path = vim.fn.stdpath("config") })
      end
    end
  end,
  desc = " Explorer Neotree Config"
}
maps.n["<leader>E"] = { desc = " nvim-tree" }
maps.n["<leader>Et"] = {
  function()
    local tree = require("plugins.config.nvim-tree")
    tree.toggle_replace()
  end
}
maps.n["<leader>Ed"] = {
  function()
    -- require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
    local dirPath = vim.fn.expand('%:p:h')
    if dirPath then
      print(dirPath)
      require("nvim-tree.api").tree.open({ path = dirPath })
    else
      print("no file")
    end
  end,
  desc = " Explorer Neotree Root"
}

-- aerial代码大纲
maps.n["<leader>a"] = { " Aerial" }
maps.n["<leader>aa"] = {
  function()
    require("aerial").toggle()
  end,
  desc = " Aerial toggle"
}
maps.n["<leader>af"] = {
  function()
    require("aerial").focus()
  end,
  desc = " Aerial Focus"
}
maps.n["<leader>ao"] = {
  function()
    require("aerial").open({ opts = { focus = true, direction = "float" } })
  end,
  desc = " Aerial Open Float"
}
maps.n["<leader>as"] = {
  function()
    require("aerial").select({ index = nil, split = "v" })
  end,
  desc = " Aerial Open Select"
}

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

-- Telescope
if is_available "telescope.nvim" then
  maps.n["<leader>f"] = sections.f
  maps.n["<leader>g"] = sections.g
  maps.n["<leader>f`"] = { function() require("telescope.builtin").reloader() end, desc = "Git branches" }
  maps.n["<leader>gb"] = { function() require("telescope.builtin").git_branches() end, desc = "Git branches" }
  maps.n["<leader>gc"] = { function() require("telescope.builtin").git_commits() end, desc = "Git commits" }
  maps.n["<leader>gt"] = { function() require("telescope.builtin").git_status() end, desc = "Git status" }
  maps.n["<leader>f<CR>"] = { function() require("telescope.builtin").resume() end, desc = "Resume previous search" }
  maps.n["<leader>f'"] = { function() require("telescope.builtin").marks() end, desc = "Find marks" }
  maps.n["<leader>fa"] = {
    function()
      local cwd = vim.fn.stdpath "config" .. "/.."
      local search_dirs = {}
      for _, dir in ipairs(astronvim.supported_configs) do                      -- search all supported config locations
        if dir == astronvim.install.home then dir = dir .. "/lua/user" end      -- don't search the astronvim core files
        if vim.fn.isdirectory(dir) == 1 then table.insert(search_dirs, dir) end -- add directory to search if exists
      end
      if vim.tbl_isempty(search_dirs) then                                      -- if no config folders found, show warning
        utils.notify("No user configuration files found", vim.log.levels.WARN)
      else
        if #search_dirs == 1 then cwd = search_dirs[1] end -- if only one directory, focus cwd
        require("telescope.builtin").find_files {
          prompt_title = "Config Files",
          search_dirs = search_dirs,
          cwd = cwd,
        } -- call telescope
      end
    end,
    desc = "Find AstroNvim config files",
  }
  maps.n["<leader>fb"] = { function() require("telescope.builtin").buffers() end, desc = "Find buffers" }
  maps.n["<leader>fc"] =
  { function() require("telescope.builtin").grep_string() end, desc = "Find for word under cursor" }
  maps.n["<leader>fC"] = { function() require("telescope.builtin").commands() end, desc = "Find commands" }
  maps.n["<leader>ff"] = {
    function() require("telescope.builtin").find_files({ enable_preview = false }) end,
    desc = "Find files"
  }
  -- maps.n["<leader>ff"] = { function() require("telescope.builtin").find_files(require('telescope.themes').get_dropdown({})) end, desc = "Find files" }
  maps.n["<leader>fF"] = {
    function() require("telescope.builtin").find_files { hidden = true, no_ignore = true } end,
    desc = "Find all files",
  }
  maps.n["<leader>fh"] = { function() require("telescope.builtin").help_tags() end, desc = "Find help" }
  maps.n["<leader>fk"] = { function() require("telescope.builtin").keymaps() end, desc = "Find keymaps" }

  --Layout
  maps.n["<leader>fl"] = {
    function() require 'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({})) end,
    desc = "Find man"
  }

  maps.n["<leader>fm"] = { function() require("telescope.builtin").man_pages() end, desc = "Find man" }
  -- if is_available "nvim-notify" then
  --   maps.n["<leader>fn"] =
  --   { function() require("telescope").extensions.notify.notify() end, desc = "Find notifications" }
  -- end
  maps.n["<leader>fo"] = { function() require("telescope.builtin").oldfiles() end, desc = "Find history" }

  -- project
  maps.n["<leader>fp"] = { function() require("telescope").load_extension('projects') end, desc = "Find project" }
  maps.n["<leader>fP"] = { function() require("telescope").extensions.projects.projects {} end, desc = "Find project" }

  maps.n["<leader>fr"] = { function() require("telescope.builtin").registers() end, desc = "Find registers" }
  maps.n["<leader>ft"] =
  { function() require("telescope.builtin").colorscheme { enable_preview = true } end, desc = "Find themes" }
  maps.n["<leader>fw"] = { function() require("telescope.builtin").live_grep() end, desc = "Find words" }
  maps.n["<leader>fW"] = {
    function()
      require("telescope.builtin").live_grep {
        additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
      }
    end,
    desc = "Find words in all files",
  }
  maps.n["<leader>l"] = sections.l
  maps.n["<leader>lD"] = { function() require("telescope.builtin").diagnostics() end, desc = "Search diagnostics" }

  maps.n["<leader>lf"] = { function() vim.lsp.buf.format() end, desc = "Format buffer" }

  maps.n["<leader>ls"] = {
    function()
      local aerial_avail, _ = pcall(require, "aerial")
      if aerial_avail then
        require("telescope").extensions.aerial.aerial()
      else
        require("telescope.builtin").lsp_document_symbols()
      end
    end,
    desc = "Search symbols",
  }


  maps.n["<leader>u"] = sections.u

  maps.n["<leader>c"] = {
    function()
      require('telescope.builtin').colorscheme({ enable_preview = true })
    end,
    desc = "colorscheme"
  }

  maps.n["<leader>u1"] = "gruvbox"
  maps.n["<leader>u1m"] = "mode"
  maps.n["<leader>u1mm"] = {
    function()
      -- local box = require("gruvbox")
    end
  }

  -- Comment
  if is_available "Comment.nvim" then
    maps.n["<leader>/"] = {
      function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Comment line",
    }
    maps.v["<leader>/>"] =
    { "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", desc = "Toggle comment line" }
  end

  -- Folding
  if is_available "nvim-ufo" then
    maps.n["zoo"] = { function() require("ufo").openAllFolds() end, desc = "Open all folds" }
    maps.n["zcc"] = { function() require("ufo").closeAllFolds() end, desc = "Close all folds" }
    maps.n["zr"] = { function() require("ufo").openFoldsExceptKinds() end, desc = "Fold less" }
    maps.n["zm"] = { function() require("ufo").closeFoldsWith() end, desc = "Fold more" }
    maps.n["zh"] = { function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Hover fold" }
    maps.n["zn"] = {
      function()
        local ufo = require("ufo")
        ufo.goNextClosedFold()
      end,
      desc = "Go Next fold"
    }
    maps.n["zp"] = {
      function()
        local ufo = require("ufo")
        ufo.goPreviousClosedFold()
        ufo.peekFoldedLinesUnderCursor()
      end,
      desc = "Go prev fold"
    }
    maps.n["zk"] = {
      function()
      end,
      desc = "Peek fold"
    }
  end
end

-- Session Manager
-- if is_available "session_manager" then
-- maps.n["<leader>s"] = sections.S
-- maps.n["<leader>sl"] = { "<cmd>SessionManager! load_last_session<cr>", desc = "Load last session" }
-- maps.n["<leader>ss"] = { "<cmd>SessionManager! save_current_session<cr>", desc = "Save this session" }
-- maps.n["<leader>sd"] = { "<cmd>SessionManager! delete_session<cr>", desc = "Delete session" }
-- maps.n["<leader>sf"] = { "<cmd>SessionManager! load_session<cr>", desc = "Search sessions" }
-- maps.n["<leader>s."] =
--   { "<cmd>SessionManager! load_current_dir_session<cr>", desc = "Load current directory session" }
-- end

-- print("ready set mappings")
-- print_table(maps)
utils.set_mappings(maps)
