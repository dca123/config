return {
  {
    'vyfor/cord.nvim',
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
  -- {
  --   'bloznelis/before.nvim',
  --   config = function()
  --     local before = require('before')
  --     before.setup()
  --
  --     vim.keymap.set('n', '<C-h>', before.jump_to_last_edit, {})
  --     vim.keymap.set('n', '<C-l>', before.jump_to_next_edit, {})
  --     vim.keymap.set('n', '<leader>oe', before.show_edits_in_telescope, {})
  --   end
  -- },
--   {
--     dir = "~/Projects/example.nvim",
--     opts = { name = "Devinda" }
--   },
}
