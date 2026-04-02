return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      require('typescript-tools').setup {
        capabilities = capabilities,
        settings = {
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
            autoImportFileExcludePatterns = {
              "lucide-react",
            }
          }
        }
      }
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library",      words = { "vim%.uv" } },
            { path = "${3rd}/busted/library",   words = { "describe", "it", "before_each", "after_each" } },
            { path = "${3rd}/luassert/library", words = { "assert" } }
          },
        },
      },
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Global config for all servers
      vim.lsp.config('*', {
        capabilities = capabilities,
      })

      -- Server specific configs
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            hint = {
              enable = true,
              setType = true
            }
          }
        }
      })

      vim.lsp.config('denols', {
        root_markers = { "deno.json", "deno.jsonc" },
      })

      vim.lsp.config('gopls', {
        cmd = { "/Users/devinda/go/bin/gopls" },
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            }
          }
        }
      })

      vim.lsp.config('ocamllsp', {
        cmd = { 'ocamllsp' },
        filetypes = {
          'ocaml',
          'ocaml.interface',
          'ocaml.menhir',
          'ocaml.ocamllex',
          'dune',
          'reason'
        },
        root_markers = {
          { 'dune-project', 'dune-workspace' },
          { "*.opam",       "esy.json",      "package.json" },
          '.git'
        },
        settings = {},
      })

      -- Enable servers
      vim.lsp.enable({ "lua_ls", "denols", "astro", "tailwindcss", "gopls", "ocamllsp" })

      vim.keymap.set("n", "<leader>sd", vim.diagnostic.open_float)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

      local methods = vim.lsp.protocol.Methods
      local inlay_hint_handler = vim.lsp.handlers[methods.textDocument_inlayHint]
      vim.lsp.handlers[methods.textDocument_inlayHint] = function(err, result, ctx, config)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client and client.name == 'typescript-tools' then
          result = vim.iter(result):map(function(hint)
            local label = hint.label ---@type string
            if label:len() >= 30 then
              label = label:sub(1, 29) .. "..."
            end
            hint.label = label
            return hint
          end):totable()
        end

        inlay_hint_handler(err, result, ctx, config)
      end


      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          if client:supports_method("textDocument/definition") and not vim.b[args.buf].ts_tools_attached then
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf, desc = "Go to Definition" })
            if client.name == "typescript-tools" then
              vim.b[args.buf].ts_tools_attached = true
            end
          end

          if client:supports_method("textDocument/inlay_hint") then
            vim.lsp.inlay_hint.enable(true, { 0 })
          end
        end,
      })
    end,
  },
}
