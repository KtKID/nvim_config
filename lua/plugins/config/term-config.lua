local term = require("toggleterm")
print("this is toggle ")

-- term.new
--
--

function term.set_term_keymaps()
    print("set_keymaps")
    local opts = {noremap = true}
    vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-w>h]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-w>j]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-w>k]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-w>l]], opts)
end

-- vim.cmd('autocmd! TermOpen term://* lua term.set_term_keymaps()')

term.setup({
    -- size can be a number or function which is passed the current terminal
    size = 10,
    open_mapping = [[<c-\>]],
    -- direction = "float",
    direction = "horizontal",
})

return term
