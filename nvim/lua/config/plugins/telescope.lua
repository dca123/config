return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim', { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' } },
    config = function()
      local actions = require "telescope.actions"
      require("telescope").setup {
        pickers = {
          buffers = {
            mappings = {
              n = {
                ["bd"] = actions.delete_buffer + actions.move_to_top,
              }
            }
          }
        },
        extensions = {
          fzf = {}
        }
      }
      require('telescope').load_extension('fzf')

      local x = function()
        require('telescope.builtin').registers { prompt_title = "Hello World" }
      end
      vim.keymap.set('n', '<leader>ht', require('telescope.builtin').help_tags)
      vim.keymap.set('n', "<leader><leader>", require('telescope.builtin').find_files, { nowait = true })
      -- vim.keymap.set('n', '"', x, { nowait = true, })
      vim.keymap.set("n", "<leader>b", "<CMD>Telescope buffers<CR>")
      vim.keymap.set('n', "<leader>en", function()
        require('telescope.builtin').find_files {
          cwd = vim.fn.stdpath("config")
        }
      end)
      vim.keymap.set('n', "<leader>ep", function()
        require('telescope.builtin').find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        }
      end)
      require "config.telescope.multigrep".setup()
    end
  }
}
