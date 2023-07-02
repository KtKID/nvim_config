local npairs             = require "nvim-autopairs"
local Rule               = require 'nvim-autopairs.rule'

local brackets           = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
-- npairs.add_rules {}
--     Rule(' ', ' ')
--         :with_pair(function(opts)
--             local pair = opts.line:sub(opts.col - 1, opts.col)
--             return vim.tbl_contains({
--                 brackets[1][1] .. brackets[1][2],
--                 brackets[2][1] .. brackets[2][2],
--                 brackets[3][1] .. brackets[3][2],
--             }, pair)
--         end)
-- }
-- for _, bracket in pairs(brackets) do
--     npairs.add_rules {
--         Rule(bracket[1] .. ' ', ' ' .. bracket[2])
--             :with_pair(function() return false end)
--             :with_move(function(opts)
--                 return opts.prev_char:match('.%' .. bracket[2]) ~= nil
--             end)
--             :use_key(bracket[2])
--     }
-- end

local cmp_status_ok, cmp = pcall(require, "cmp")
if cmp_status_ok then
    cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done { tex = "" })
end
npairs.setup({
    check_ts = true,
    ts_config = { java = false },
    fast_wrap = {
        map = "<M-e>", -- '('后按alt+e插入括号提示符
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
    },
    ignored_next_char = "[%w%.]", -- 下一个是数字字母或. will ignore alphanumeric and `.` symbol
    -- npairs.add_rules {
    --     Rule(' ', ' ')
    --         :with_pair(function(opts)
    --             local pair = opts.line:sub(opts.col - 1, opts.col)
    --             return vim.tbl_contains({
    --                 brackets[1][1] .. brackets[1][2],
    --                 brackets[2][1] .. brackets[2][2],
    --                 brackets[3][1] .. brackets[3][2],
    --             }, pair)
    --         end)
    -- }

})


local cond = require'nvim-autopairs.conds'
-- Rule
local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
npairs.add_rules(
    {
        Rule(' ', ' ')
            :with_pair(function(opts)
                local pair = opts.line:sub(opts.col - 1, opts.col)
                return vim.tbl_contains({
                    brackets[1][1] .. brackets[1][2],
                    brackets[2][1] .. brackets[2][2],
                    brackets[3][1] .. brackets[3][2],
                }, pair)
            end)
    }
)
-- 在括号中按空格，会在左边和右边都加上空格
for _, bracket in pairs(brackets) do
    npairs.add_rules {
        Rule(bracket[1] .. ' ', ' ' .. bracket[2])
            :with_pair(function() return false end)
            :with_move(function(opts)
                return opts.prev_char:match('.%' .. bracket[2]) ~= nil
            end)
            :use_key(bracket[2])
    }
end
-- 以\startxx开头后，按空格，会自动补全stopxx
-- npairs.add_rules({
--     Rule("\\start(%w*) $", "tex")
--         :replace_endpair(function(opts)
--             local beforeText = string.sub(opts.line, 0, opts.col)
--             local _, _, match = beforeText:find("\\start(%w*)")
--             if match and #match > 0 then
--                 return " \\stop" .. match
--             end
--             return ''
--         end)
--         :with_move(cond.none())
--         :use_key("<space>")
--         :use_regex(true)
-- })
return npairs
