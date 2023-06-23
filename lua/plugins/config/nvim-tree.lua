print("this is tree config")
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- change color for arrows in tree to light blue
vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])


local tree = require("nvim-tree")
local api = require("nvim-tree.api")
local lib = require("nvim-tree.lib")

local function open_nvim_tree(data)
    -- buffer is a [No Name]
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

    -- buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    if not no_name and not directory then
        return
    end

    -- change to the directory
    if directory then
        vim.cmd.cd(data.file)
    end

    -- open the tree
    require("nvim-tree.api").tree.open()
end

-- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- api.events.subscribe(api.events.Event.FileCreated, function(file)
--     print("tree create file")
--   vim.cmd("edit " .. file.fname)
-- end)
function tree.find_directory_and_focus()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local function open_nvim_tree(prompt_bufnr, _)
        actions.select_default:replace(function()
            local api = require("nvim-tree.api")

            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            api.tree.open()
            api.tree.find_file(selection.cwd .. "/" .. selection.value)
        end)
        return true
    end

    require("telescope.builtin").find_files({
        find_command = { "fd", "--type", "directory", "--hidden", "--exclude", ".git/*" },
        attach_mappings = open_nvim_tree,
    })
end

function tree.focus_file()
    
end

function tree.open_file_with_newtab()
    local node = lib.get_node_at_cursor()
    if node then
        print(node.absolute_path)
    end
end
function tree.set_focus()
    local view = require'nvim-tree.view'
    local node = lib.get_node_at_cursor()
    print("focus ")
    print(node)

    -- 如果有node，则将其设置为焦点
    if node then
        view.winid = vim.api.nvim_get_current_win()
        view.open()
        lib.select_node(node)
        vim.api.nvim_command(":normal! zz") -- 将当前节点滚动到屏幕中心
    else
        print("not node")
    end
end

function tree.toggle(path)
    local api = require("nvim-tree.api")
    if api.tree.is_visible() then
        print("tree open")
        api.tree.close()
        return false
    else
        --     api.tree.open(path)
        return true
    end
end

function tree.toggle_replace()
    local api = require("nvim-tree.api")
    if api.tree.is_visible() then
        api.tree.close()
    else
        api.node.open.replace_tree_buffer()
    end
end

local function on_attach(buff)
    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = buff, noremap = true, silent = true, nowait = true }
    end

    vim.keymap.set('n', '<C-o>', tree.open_file_with_newtab, opts('CD'))
    vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
    vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
    vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
    vim.keymap.set('n', '<C-f>', function ()
            local filePath = vim.fn.expand('%:p')
            print(filePath)
            -- api.tree.find_file({update_root=true,focus=true})
    end)
    vim.keymap.set('n', '<C-k>', api.node.show_info_popup, opts('Info'))
    vim.keymap.set('n', '<C-n>', function ()
        api.node.navigate.opened.next()
        print("next")
    end)
    vim.keymap.set('n', '<C-p>', function ()
        api.node.navigate.opened.prev()
    end)
    vim.keymap.set('n', '<C-p>', function ()
        api.node.navigate.opened.prev()
        print("next")
    end)
    vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
    vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
    vim.keymap.set('n', 'td', api.node.open.tab_drop, opts('Open: Tab Drop'))
    vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
    vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
    vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory'))
    vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', '<Tab>', api.node.open.preview, opts('Open Preview'))

    vim.keymap.set("n", "[d", tree.find_directory_and_focus)

    vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
    vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
    vim.keymap.set('n', 'bmv', api.marks.bulk.move, opts('Move Bookmarked'))
    vim.keymap.set('n', 'B', api.tree.toggle_no_buffer_filter, opts('Toggle No Buffer'))
    vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
    vim.keymap.set('n', 'C', api.tree.toggle_git_clean_filter, opts('Toggle Git Clean'))
    vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
    vim.keymap.set('n', ']c', api.node.navigate.git.next, opts('Next Git'))
    vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
    vim.keymap.set('n', 'D', api.fs.trash, opts('Trash'))
    vim.keymap.set('n', 'E', api.tree.expand_all, opts('Expand All'))
    vim.keymap.set('n', 'e', api.fs.rename_basename, opts('Rename: Basename'))
    vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
    vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
    vim.keymap.set('n', 'F', api.live_filter.clear, opts('Clean Filter'))
    vim.keymap.set('n', 'f', api.live_filter.start, opts('Filter'))
    vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
    vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
    vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
    vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))
    vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts('Last Sibling'))
    vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts('First Sibling'))
    vim.keymap.set('n', 'm', api.marks.toggle, opts('Toggle Bookmark'))
    vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts('Open: No Window Picker'))
    vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
    vim.keymap.set('n', 'P', api.node.navigate.parent, opts('Parent Directory'))
    vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
    vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
    vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
    vim.keymap.set('n', 's', api.node.run.system, opts('Run System'))
    vim.keymap.set('n', 'S', api.tree.search_node, opts('Search'))
    vim.keymap.set('n', 'U', api.tree.toggle_custom_filter, opts('Toggle Hidden'))
    vim.keymap.set('n', 'W', api.tree.collapse_all, opts('Collapse'))
    vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
    vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
    vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
    vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
    -- END_DEFAULT_ON_ATTACH
end

tree.setup({
    view = {
        width = 25,
        side = "left",
    },
    -- disable window_picker for
    -- explorer to work well with
    -- window splits
    actions = {
        open_file = {
            window_picker = {
                enable = false,
            },
        },
    },
    update_focused_file = {
        enable = true,
        update_root = true,
        ignore_list = {},
      },
    renderer = {
        highlight_opened_files="icon",
        icons = {
            glyphs = {
                folder = {
                    arrow_closed = "", -- arrow when folder is closed
                    arrow_open = "", -- arrow when folder is open
                },
            },
        },
    },
    on_attach = on_attach,
})



return tree

-- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree }),
-- function open_nvim_tree()
--     require("nvim-tree.api").tree.open()
-- end
