local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

-- local WinBars = {
--     fallthrough = false,
--     {     -- A special winbar for terminals
--         condition = function()
--             return conditions.buffer_matches({ buftype = { "terminal" } })
--         end,
--         utils.surround({ "", "" }, "dark_red", {
--             FileType,
--             Space,
--             TerminalName,
--         }),
--     },
--     {     -- An inactive winbar for regular files
--         condition = function()
--             return not conditions.is_active()
--         end,
--         utils.surround({ "", "" }, "bright_bg", { hl = { fg = "gray", force = true }, FileNameBlock }),
--     },
--     -- A winbar for regular files
--     utils.surround({ "", "" }, "bright_bg", FileNameBlock),
-- }
local colors = {
    bright_bg = utils.get_highlight("Folded").bg,
    bright_fg = utils.get_highlight("Folded").fg,
    red = utils.get_highlight("DiagnosticError").fg,
    dark_red = utils.get_highlight("DiffDelete").bg,
    green = utils.get_highlight("String").fg,
    blue = utils.get_highlight("Function").fg,
    gray = utils.get_highlight("NonText").fg,
    orange = utils.get_highlight("Constant").fg,
    purple = utils.get_highlight("Statement").fg,
    cyan = utils.get_highlight("Special").fg,
    diag_warn = utils.get_highlight("DiagnosticWarn").fg,
    diag_error = utils.get_highlight("DiagnosticError").fg,
    diag_hint = utils.get_highlight("DiagnosticHint").fg,
    diag_info = utils.get_highlight("DiagnosticInfo").fg,
    git_del = utils.get_highlight("diffDeleted").fg,
    git_add = utils.get_highlight("diffAdded").fg,
    git_change = utils.get_highlight("diffChanged").fg,
}


local configPath = "plugins.config.ui."

local Git = require(configPath .. "heirline-git")
local File = require(configPath .. "heirline-file")
local LspUI = require(configPath .. "heirline-lsp")
local VimodeUI = require(configPath .. "heirline-vimode")
VimodeUI = utils.surround({ "█", "█" }, "bright_bg", { VimodeUI, Snippets })
local Tab = require(configPath .. "heirline-tab")

-- 对齐
local Align = { provider = "%=" }
-- 空格
local space = {
    {
        provider = " ",
    },
}

local VmodeUI =
{
    condition = function()
        return conditions.buffer_matches({
            -- buftype = { "nofile", "prompt", "help", "quickfix", },
            -- filetype = { "^git.*", "fugitive", "*.lua" },
            filetype = core.heirline_support_filetype
        })
    end,
    VimodeUI,
}
local FileStatusLine = {
    condition = function()
        return conditions.buffer_matches({
            -- buftype = { "nofile", "prompt", "help", "quickfix", },
            -- filetype = { "^git.*", "fugitive", "*.lua" },
            filetype = core.heirline_support_filetype
        })
    end,
    space,
    File.FileSize,
    space,
    File.FileIcon,
    File.FileType,
    space,
    File.Ruler,
    space,
    File.ScrollBar,
    space,
    File.FileEncoding,
    space,
    File.FileFormat
}

local DefaultStatusLine = {
}
local SpecialStatusline = {
}
local LspStatusLine = {
    condition = function()
        return conditions.buffer_matches({
            -- buftype = { "nofile", "prompt", "help", "quickfix", },
            -- filetype = { "^git.*", "fugitive", "*.lua" },
            filetype = core.heirline_support_filetype
        })
    end,
    LspUI,
    LspUI.Diagnostics,
}

local InactiveStatusline = {
    condition = conditions.is_not_active,
    VimodeUI
}

-- 最外层
local StatusLine = {
    VmodeUI,
    space,
    Git.gitBlock,
    Align,
    LspStatusLine,
    Align,
    space,
    FileStatusLine,
    hl = { bg = "dark_red" },
}
local TabLine = {
    Tab.TabLineOffset,
    Tab.BufferLine,
    Tab.TabPages,
    --  hl = { bg = "gray" },
}
local WinBar = {
    fallthrough = false,
    { -- A special winbar for terminals
        condition = function()
            return conditions.buffer_matches({ buftype = { "terminal" } })
        end,
        utils.surround({ "", "" }, "dark_red", {
            File.FileType,
            space,
            -- TerminalName,
        }),
    },
    { -- An inactive winbar for regular files
        condition = function()
            return not conditions.is_active()
        end,
        utils.surround({ "", "" }, "bright_bg", { hl = { fg = "gray", force = true }, File.FileNameBlock }),
    },
    -- A winbar for regular files
    utils.surround({ "", "" }, "bright_bg", File.FileNameBlock),
}

local heir = require("heirline").setup({
    statusline = StatusLine,
    -- winbar = WinBar,
    tabline = TabLine,
    opts = {
        colors = colors,
        -- if the callback returns true, the winbar will be disabled for that window
        -- the args parameter corresponds to the table argument passed to autocommand callbacks. :h nvim_lua_create_autocmd()
        disable_winbar_cb = function(args)
            return conditions.buffer_matches({
                buftype = { "nofile", "prompt", "help", "quickfix" },
                -- 这里加上不显示的文件类型
                filetype = { "^git.*", "fugitive", "Trouble", "dashboard", "NvimTree" },
            }, args.buf)
        end,
    }
})
-- Yep, with heirline we're driving manual!
vim.o.showtabline = 2
vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
return heir
