return {
    "lewis6991/gitsigns.nvim",
    enabled = vim.fn.executable "git" == 1,
    event = { "BufReadPre", "BufNewFile" },
    --   event = "User AstroGitFile",
    config = require("plugins.config.git-config"),
}
