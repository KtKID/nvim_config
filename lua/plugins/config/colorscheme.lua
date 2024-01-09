return function()
    local palette = require("plugins.config.ui.colors")
    require('kanagawa').setup({
        theme = "wave",
        colors = {
            theme = {
                -- change specific usages for a certain theme, or for all of them
                    wave = {
                        ui = {
                            fg         = palette.fujiWhite,
                            fg_dim     = palette.oldWhite,
                            fg_reverse = palette.waveBlue1,

                            bg_dim     = palette.sumiInk1,
                            bg_gutter  = palette.sumiInk4,

                            bg_m3      = palette.sumiInk0,
                            bg_m2      = palette.sumiInk1,
                            bg_m1      = palette.sumiInk2,

                            bg         = palette.sumiInk3,
                            bg_p1      = palette.sumiInk4,
                            bg_p2      = palette.sumiInk5,

                            special    = palette.springViolet1,
                            nontext    = palette.sumiInk6,
                            whitespace = palette.sumiInk6,

                            bg_search  = palette.waveBlue2,
                            bg_visual  = palette.waveBlue1,

                            pmenu      = {
                                fg       = palette.fujiWhite,
                                fg_sel   = "none", -- This is important to make highlights pass-through
                                bg       = palette.waveBlue1,
                                bg_sel   = palette.waveBlue2,
                                bg_sbar  = palette.waveBlue1,
                                bg_thumb = palette.waveBlue2,
                            },
                            float      = {
                                fg        = palette.oldWhite,
                                bg        = palette.sumiInk0,
                                fg_border = palette.sumiInk6,
                                bg_border = palette.sumiInk0,
                            },
                        },
                },
                -- dragon = {
                --         ui = {
                --             bg = palette.waveRed,
                --         }
                -- },
                all = {
                    ui = {
                        -- bg = palette.waveRed,
                    }
                }
            }
        },
    })
    vim.cmd("colorscheme kanagawa-wave")
end
