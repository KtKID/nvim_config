print("this is tree config")
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- change color for arrows in tree to light blue
vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

local tree = require("nvim-tree")
local api = require("nvim-tree.api")

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

tree.setup({
    view = {
        width = 3,
        side = "right",
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
    renderer = {
        icons = {
            glyphs = {
                folder = {
                    arrow_closed = "", -- arrow when folder is closed
                    arrow_open = "", -- arrow when folder is open
                },
            },
        },
    },
})

return tree

-- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree }),
-- function open_nvim_tree()
--     require("nvim-tree.api").tree.open()
-- end
