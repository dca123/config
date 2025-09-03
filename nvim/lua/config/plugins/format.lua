return {
  {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
      local prettierd = {
        "javascript",
        "typescript",
        "typescriptreact",
        "javascriptreact",
        "css",
        "json",
        "jsonc",
        "astro",
        "graphql",
      }
      local formatters_by_ft = {}
      for _, v in pairs(prettierd) do
        formatters_by_ft[v] = { 'prettierd' }
      end

      require("conform").setup({
        formatters_by_ft = formatters_by_ft,
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
        ft_parsers = {
          javascript = "babel",
          javascriptreact = "babel",
          typescript = "typescript",
          typescriptreact = "typescript",
          css = "css",
          html = "html",
          json = "json",
          jsonc = "json",
          yaml = "yaml",
          markdown = "markdown",
          ["markdown.mdx"] = "mdx",
          astro = "astro"
        },
      })
    end
  },
}
