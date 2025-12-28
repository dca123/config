return {
  {
    "OXY2DEV/markview.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    opts = {}
  },
  {
    "sphamba/smear-cursor.nvim",
    opts = {},
  },
  {
    "karb94/neoscroll.nvim",
    opts = {},
  },
  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    priority = 10, -- Low priority to catch other plugins' keybindings
    opts = {

    }
  },
  {
    "shortcuts/no-neck-pain.nvim",
    opts = {
      width = 120,
      autocmds = {
        enableOnVimEnter = true,
        skipEnteringNoNeckPainBuffer = false,
      },
      mappings = {
        enabled = true,
        toggle = "<leader>z",
      },
      buffers = {
        wo = {
          fillchars = "eob: ",
        },
        bo = {
          filetype = "markdown",
        },
        left = {
          scratchPad = {
            enabled = true,
            pathToFile = vim.fn.stdpath("data") .. "/no-neck-pain-left.md",
          },
        },
        right = {
          scratchPad = {
            enabled = true,
            pathToFile = vim.fn.stdpath("data") .. "/no-neck-pain-right.md",
          },
        },
      },
    },
  },
}
