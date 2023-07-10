return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", },
    },
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    default = {
        theme = "dropdown",
        -- layout_config = {
        --     vertical = { width = 0.5 }
        --     -- other layout configuration here
        -- },
        mappings = {
            i = {
                ["<C-h>"] = "which_key"
            }
        },
        pickers = {
            find_files = {
                theme = "dropdown",
                -- require('telescope.themes').get_ivy { width = 0.25, }
            },
        },
    },
    pickers = {
        find_files = {
            theme = "ivy",
            -- require('telescope.themes').get_ivy { width = 0.25, }
        },
    },
    extensions = {
        aerial = {
            -- Display symbols as <root>.<parent>.<symbol>
            show_nesting = {
                ['_'] = true, -- This key will be the default
                json = true, -- You can set the option for specific filetypes
                yaml = true,
            }
        }
    }
    -- file_browser = {
    --     theme = "dropdown",
    --     -- require('telescope.themes').get_ivy { width = 0.25, }
    -- },
}
