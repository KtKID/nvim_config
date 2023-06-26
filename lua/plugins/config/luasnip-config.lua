return function()
    local types = require("luasnip.util.types")
    local node_util = require("luasnip.nodes.util")
    local ls = require("luasnip")

    ls.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
        ext_opt = {
            [types.choiceNode] = {
                active = {
                    virt_text = { { "󰧑", "GruvboxOrange" } },
                },
            },
        }
    })
    ls.setup({

    })
    vim.tbl_map(function(type) require("luasnip.loaders.from_" .. type).lazy_load() end, { "vscode", "snipmate", "lua" })
end
