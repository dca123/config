return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "query",
          "markdown", "markdown_inline",
          "html", "css", "json",
          "javascript", "typescript", "tsx", "jsdoc",
        },
        sync_install = false,
        auto_install = false,
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
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo[0][0].foldmethod = "expr"
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
