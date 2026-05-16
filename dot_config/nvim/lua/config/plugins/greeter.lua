return {
  {
    "goolord/alpha-nvim",
    -- dependencies = { 'echasnovski/mini.icons' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require("alpha")
      local theme = require("config.greeter.theme")
      alpha.setup(theme.config)
    end,
  },
}
