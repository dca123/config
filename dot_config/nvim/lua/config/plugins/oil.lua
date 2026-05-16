return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    config = function()
      require("oil").setup({
        view_options = {
          is_hidden_file = function(name, bufnr)
            local dir = require("oil").get_current_dir(bufnr)
            local target = vim.fn.expand("~/.config/zsh")
            if dir and (dir == target or dir == target .. "/") then
              return false
            end
            return vim.startswith(name, ".")
          end,
        },
      })
      vim.keymap.set("n", "<leader>fb", "<CMD>Oil<CR>", { desc = "Open Oil" })
    end
  }
}
