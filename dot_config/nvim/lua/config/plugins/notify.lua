return {
  {
    "rcarriga/nvim-notify",
    opts = {
      merge_duplicates = true,
    },
    config = function(_, opts)
      -- Dynamically get the background from your Dracula theme
      local dracula_bg = require("dracula").colors().bg
      opts.background_colour = dracula_bg
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },
  {
    "TobinPalmer/Tip.nvim",
    event = "VimEnter",
    init = function()
      -- Default config
      --- @type Tip.config
      require("tip").setup({
        seconds = 2,
        title = "Tip!",
        url = "https://vtip.43z.one", -- Or https://vimiscool.tech/neotip
      })
    end,
  }
}
