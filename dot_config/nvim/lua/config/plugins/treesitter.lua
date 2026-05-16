return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      ts.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      ts.install({
        "lua", "vim", "vimdoc", "query",
        "markdown", "markdown_inline",
        "html", "css", "json",
        "javascript", "typescript", "tsx", "jsdoc",
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "lua", "vim", "query",
          "markdown",
          "html", "css", "json",
          "javascript", "javascriptreact", "typescript", "typescriptreact",
        },
        callback = function()
          vim.treesitter.start()
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo.foldmethod = "expr"
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
