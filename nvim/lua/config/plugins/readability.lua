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
    "karb94/neoscroll.nvim",
    opts = {
      hide_cursor = true
    },
  },
  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    priority = 10, -- Low priority to catch other plugins' keybindings
    keys = {
      {
        "<leader>w",
        function()
          require("tiny-glimmer.lib").cursor_line("pulse")
        end,
        desc = "Flash current line",
      },
    },
    opts = {
      yank = {
        enabled = true,
        default_animation = "fade",
      },
      -- Search navigation animation
      search = {
        enabled = true,
        default_animation = "pulse",
        next_mapping = "n", -- Key for next match
        prev_mapping = "N", -- Key for previous match
      },

      -- Paste operation animation
      paste = {
        enabled = true,
        default_animation = "reverse_fade",
        paste_mapping = "p", -- Paste after cursor
        Paste_mapping = "P", -- Paste before cursor
      },

      -- Undo operation animation
      undo = {
        enabled = true,
        default_animation = {
          name = "fade",
          settings = {
            from_color = "DiffDelete",
            max_duration = 500,
            min_duration = 500,
          },
        },
        undo_mapping = "u",
      },

      -- Redo operation animation
      redo = {
        enabled = true,
        default_animation = {
          name = "fade",
          settings = {
            from_color = "DiffAdd",
            max_duration = 500,
            min_duration = 500,
          },
        },
        redo_mapping = "<c-r>",
      },
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
        colors = {
          background = require("dracula").colors().bg,
          text = require("dracula").colors().fg,
          blend = 0.01
        },
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
