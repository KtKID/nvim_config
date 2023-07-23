return {
  "nvim-treesitter/nvim-treesitter",
  -- enabled = false,
  dependencies = { "windwp/nvim-ts-autotag", "JoosepAlviste/nvim-ts-context-commentstring" },
  event = "BufNewFile",
  cmd = {
    "TSBufDisable",
    "TSBufEnable",
    "TSBufToggle",
    "TSDisable",
    "TSEnable",
    "TSToggle",
    "TSInstall",
    "TSInstallInfo",
    "TSInstallSync",
    "TSModuleInfo",
    "TSUninstall",
    "TSUpdate",
    "TSUpdateSync",
  },
  build = ":TSUpdate",
  config = function()
    require("plugins.config.treesitter-config")()
  end

}
