get_lsp_priority = function(client_name)
    local filetype = vim.bo.filetype
    if filetype == 'lua' then
        if client_name == "lua_ls" then
            return 10
        elseif client_name == "null_ls" then
            return 7
        end
    elseif filetype == "cpp" then
        if client_name == "clangd" then
            return 10
        end
    end
    return -1
end
require("aerial").setup({
    -- Priority list of preferred backends for aerial.
    -- This can be a filetype map (see :help aerial-filetype-map)
    backends = { "treesitter", "lsp", "markdown", "man" },

    layout = {
        -- These control the width of the aerial window.
        -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_width and max_width can be a list of mixed types.
        -- max_width = {30, 0.2} means "the lesser of 40 columns or 20% of total"
        max_width = { 40, 0.2 },
        width = nil,
        min_width = 15,

        -- key-value pairs of window-local options for aerial window (e.g. winhl)
        win_opts = {},

        -- Determines the default direction to open the aerial window. The 'prefer'
        -- options will open the window in the other direction *if* there is a
        -- different buffer in the way of the preferred direction
        -- Enum: prefer_right, prefer_left, right, left, float
        default_direction = "float",

        -- Determines where the aerial window will be opened
        --   edge   - open aerial at the far right/left of the editor
        --   window - open aerial to the right/left of the current window
        placement = "window",

        -- When the symbols change, resize the aerial window (within min/max constraints) to fit
        resize_to_content = true,

        -- Preserve window size equality with (:help CTRL-W_=)
        preserve_equality = false,
    },
    -- 只在aerial窗口内生效
    keymaps = {
        ["?"] = "actions.show_help",
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.jump",
        ["<2-LeftMouse>"] = "actions.jump",
        ["<C-v>"] = "actions.jump_vsplit",
        ["<C-s>"] = "actions.jump_split",
        ["p"] = "actions.scroll",
        ["<C-j>"] = "actions.down_and_scroll",
        ["<C-k>"] = "actions.up_and_scroll",
        ["{"] = "actions.prev",
        ["}"] = "actions.next",
        ["[["] = "actions.prev_up",
        ["]]"] = "actions.next_up",
        ["q"] = "actions.close",
        ["o"] = "actions.tree_toggle",
        ["za"] = "actions.tree_toggle",
        ["O"] = "actions.tree_toggle_recursive",
        ["zA"] = "actions.tree_toggle_recursive",
        ["l"] = "actions.tree_open",
        ["zo"] = "actions.tree_open",
        ["L"] = "actions.tree_open_recursive",
        ["zO"] = "actions.tree_open_recursive",
        ["h"] = "actions.tree_close",
        ["zc"] = "actions.tree_close",
        ["zC"] = "actions.tree_close_recursive",
        ["H"] = "actions.tree_close_recursive",
        ["zr"] = "actions.tree_increase_fold_level",
        ["zoO"] = "actions.tree_open_all",
        ["zm"] = "actions.tree_decrease_fold_level",
        ["zcC"] = "actions.tree_close_all",
        ["zx"] = "actions.tree_sync_folds",
        ["zX"] = "actions.tree_sync_folds",
    },
    -- Determines how the aerial window decides which buffer to display symbols for
    --   window - aerial window will display symbols for the buffer in the window from which it was opened
    --   global - aerial window will display symbols for the current window
    attach_mode = "window",

    -- List of enum values that configure when to auto-close the aerial window
    --   unfocus       - close aerial when you leave the original source window
    --   switch_buffer - close aerial when you change buffers in the source window
    --   unsupported   - close aerial when attaching to a buffer that has no symbol source
    close_automatic_events = {},
    -- When true, don't load aerial until a command or function is called
    -- Defaults to true, unless `on_attach` is provided, then it defaults to false
    lazy_load = true,

    -- Disable aerial on files with this many lines
    disable_max_lines = 10000,

    -- Disable aerial on files this size or larger (in bytes)
    disable_max_size = 2000000, -- Default 2MB

    -- A list of all symbols to display. Set to false to display all symbols.
    -- This can be a filetype map (see :help aerial-filetype-map)
    -- To see all available values, see :help SymbolKind
    filter_kind = {
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Module",
        "Method",
        "Struct",
    },
    -- split_width：每个打开的窗口都会在 Aerial 窗口中标记其光标位置。每行只会部分高亮显示，以指示该位置的窗口。
    -- full_width：每个打开的窗口都会在 Aerial 窗口中标记其光标位置。每行都会以全宽度的高亮显示，以指示该位置的窗口。
    -- last：只有最近聚焦的窗口会在 Aerial 窗口中标记其光标位置。
    -- none：不在 Aerial 窗口中显示光标位置。
    highlight_mode = "split_width",

    -- Highlight the closest symbol if the cursor is not exactly on one.
    highlight_closest = true,

    -- Highlight the symbol in the source buffer when cursor is in the aerial win
    highlight_on_hover = true,

    -- When jumping to a symbol, highlight the line for this many ms.
    -- Set to false to disable
    highlight_on_jump = 500,

    -- Jump to symbol in source window when the cursor moves
    autojump = false,
    -- Define symbol icons. You can also specify "<Symbol>Collapsed" to change the
    -- icon when the tree is collapsed at that symbol, or "Collapsed" to specify a
    -- default collapsed icon. The default icon set is determined by the
    -- "nerd_font" option below.
    -- If you have lspkind-nvim installed, it will be the default icon set.
    -- This can be a filetype map (see :help aerial-filetype-map)
    icons = {},
    -- Control which windows and buffers aerial should ignore.
    -- Aerial will not open when these are focused, and existing aerial windows will not be updated
    ignore = {
        -- Ignore unlisted buffers. See :help buflisted
        unlisted_buffers = false,

        -- List of filetypes to ignore.
        filetypes = {},

        -- Ignored buftypes.
        -- Can be one of the following:
        -- false or nil - No buftypes are ignored.
        -- "special"    - All buffers other than normal, help and man page buffers are ignored.
        -- table        - A list of buftypes to ignore. See :help buftype for the
        --                possible values.
        -- function     - A function that returns true if the buffer should be
        --                ignored or false if it should not be ignored.
        --                Takes two arguments, `bufnr` and `buftype`.
        buftypes = "special",

        -- Ignored wintypes.
        -- Can be one of the following:
        -- false or nil - No wintypes are ignored.
        -- "special"    - All windows other than normal windows are ignored.
        -- table        - A list of wintypes to ignore. See :help win_gettype() for the
        --                possible values.
        -- function     - A function that returns true if the window should be
        --                ignored or false if it should not be ignored.
        --                Takes two arguments, `winid` and `wintype`.
        wintypes = "special",
    },

    -- Use symbol tree for folding. Set to true or false to enable/disable
    -- Set to "auto" to manage folds if your previous foldmethod was 'manual'
    -- This can be a filetype map (see :help aerial-filetype-map)
    manage_folds = true,

    -- 代码折叠时是否同步到树中
    -- Only works when manage_folds = true
    link_folds_to_tree = true,

    -- Fold code when you open/collapse symbols in the tree.
    -- Only works when manage_folds = true
    link_tree_to_folds = true,
    -- Call this function when aerial attaches to a buffer.
    on_attach = function(bufnr) end,

    -- Call this function when aerial first sets symbols on a buffer.
    on_first_symbols = function(bufnr) end,

    -- Automatically open aerial when entering supported buffers.
    -- This can be a function (see :help aerial-open-automatic)
    open_automatic = false,

    -- Run this command after jumping to a symbol (false will disable)
    post_jump_cmd = "normal! zz",
    -- Invoked after each symbol is parsed, can be used to modify the parsed item,
    -- or to filter it by returning false.
    --
    --   bufnr：一个 Neovim 缓冲区编号，表示解析符号的缓冲区。
    -- item：一个 aerial.Symbol 类型的对象，表示解析的符号。
    -- ctx：一个记录，包含以下字段：
    -- backend_name：表示解析符号的后端名称，例如 treesitter、lsp、man 等。
    -- lang：关于语言的信息。
    -- symbols?：仅适用于 lsp 后端，表示符号列表。
    -- symbol?：仅适用于 lsp 后端，表示当前符号。
    -- syntax_tree?：仅适用于 treesitter 后端，表示语法树。
    -- match?：仅适用于 treesitter 后端，表示 TS 查询匹配。
    -- post_parse_symbol 函数在每个符号解析后调用，可以用于修改解析的项目，或通过返回 false 过滤它。
    post_parse_symbol = function(bufnr, item, ctx)
        return true
    end,
    -- When true, aerial will automatically close after jumping to a symbol
    close_on_select = false,

    -- The autocmds that trigger symbols update (not used for LSP backend)
    update_events = "TextChanged,InsertLeave",

    -- Show box drawing characters for the tree hierarchy
    show_guides = true,

    -- Customize the characters used when show_guides = true
    guides = {
        -- When the child item has a sibling below it
        mid_item = "├─",
        -- When the child item is the last in the list
        last_item = "└─",
        -- When there are nested child guides to the right
        nested_top = "│ ",
        -- Raw indentation
        whitespace = "  ",
    },


    -- 浮动窗口
    -- Options for opening aerial in a floating win
    float = {
        -- Controls border appearance. Passed to nvim_open_win
        border = core.win_border,

        -- Determines location of floating window
        --   cursor - Opens float on top of the cursor
        --   editor - Opens float centered in the editor
        --   win    - Opens float centered in the window
        relative = "cursor",

        -- These control the height of the floating window.
        -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_height and max_height can be a list of mixed types.
        -- min_height = {8, 0.1} means "the greater of 8 rows or 10% of total"
        max_height = 0.9,
        height = nil,
        min_height = { 8, 0.1 },

        override = function(conf, source_winid)
            -- This is the config that will be passed to nvim_open_win.
            -- Change values here to customize the layout
            return conf
        end,
    },

    -- Options for the floating nav windows
    nav = {
        border = core.win_border, --"rounded",
        max_height = 0.9,
        min_height = { 10, 0.1 },
        max_width = 0.5,
        min_width = { 0.2, 20 },
        win_opts = {
            cursorline = true,
            winblend = 10,
        },
        -- Jump to symbol in source window when the cursor moves
        autojump = false,
        -- Show a preview of the code in the right column, when there are no child symbols
        preview = false,
        -- Keymaps in the nav window
        keymaps = {
            -- ["<CR>"] = "actions.jump",
            -- ["<2-LeftMouse>"] = "actions.jump",
            -- ["<C-v>"] = "actions.jump_vsplit",
            -- ["<C-s>"] = "actions.jump_split",
            -- ["h"] = "actions.left",
            -- ["l"] = "actions.right",
            -- ["<C-c>"] = "actions.close",
            -- ["zb"] = "actions.tree_close_recursive",
        },
    },

    -- lsp
    lsp = {
        -- Fetch document symbols when LSP diagnostics update.
        -- If false, will update on buffer changes.
        diagnostics_trigger_update = true,

        -- Set to false to not update the symbols when there are LSP errors
        update_when_errors = true,

        -- How long to wait (in ms) after a buffer change before updating
        -- Only used when diagnostics_trigger_update = false
        update_delay = 300,

        -- Map of LSP client name to priority. Default value is 10.
        -- Clients with higher (larger) priority will be used before those with lower priority.
        -- Set to -1 to never use the client.
        priority = {
            lua_ls = get_lsp_priority("lua_ls"),
            clangd = get_lsp_priority("clangd"),
        },
    },

    treesitter = {
        -- How long to wait (in ms) after a buffer change before updating
        update_delay = 300,
    },

    markdown = {
        -- How long to wait (in ms) after a buffer change before updating
        update_delay = 300,
    },
})
