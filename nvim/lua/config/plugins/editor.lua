return {
  {
    'vyfor/cord.nvim',
    build = ':Cord update',
    opts = {}
  },
  { 'echasnovski/mini.pairs', version = false, config = true },
  { "windwp/nvim-ts-autotag", opts = {} },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {}
  },
  {
    dir = "~/Projects/example.nvim",
    opts = { name = "Devinda" }
  },
  {
    "OXY2DEV/markview.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    opts = {}
  }
}
