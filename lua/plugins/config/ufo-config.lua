-- 代码折叠插件
local ufo = require("ufo")
local handler = function(virtText, lnum, endLnum, width, truncate)
    print_file("handler " .. tostring(virtText) .. "\n")
    local newVirtText = {}
    local suffix = ('  %d '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, 'MoreMsg' })
    print_table(newVirtText, true)
    return newVirtText
end

local ftMap = {
    vim = 'indent',
    python = { 'indent' },
    git = '',
    lua = 'lsp',
}
ufo.setup(
    {
        open_fold_hl_timeout = 200,
        close_fold_kinds = { 'imports', 'comment' },
        provider_selector = function(bufnr, filetype, buftype)
            -- if you prefer treesitter provider rather than lsp,
            -- return ftMap[filetype] or {'treesitter', 'indent'}
            print_file("provider_selector " .. filetype .. "\n")
            return ftMap[filetype] or { 'treesitter' }

            -- refer to ./doc/example.lua for detail
        end,
        fold_virt_text_handler = handler, -- 折叠后虚拟文字提示
        enable_get_fold_virt_text = true,
        preview = {
            win_config = {
                border = { '󱔐', '󱔐', '󱔐', '', '󱔐', '󱔐', '󱔐', '' },
                winhighlight = 'Normal:Folded',
                winblend = 0
            },
            mappings = {
                scrollU = '<C-u>',
                scrollD = '<C-d>',
                jumpTop = '[',
                jumpBot = ']'
            }
        },
    }
)
return ufo
