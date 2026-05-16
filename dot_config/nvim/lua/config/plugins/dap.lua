local js_based_files = {
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact"
}

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio",
          {
            "microsoft/vscode-js-debug",
            build = "npm install --legacy-peer-deps && npm run compile -- dapDebugServer && mv dist out"
          }
        }
      },
    },
    config = function()
      local dap = require("dap")

      dap.adapters['pwa-node'] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/out/src/dapDebugServer.js"), "${port}" },
        }
      }

      dap.adapters['pwa-chrome'] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/out/src/dapDebugServer.js"), "${port}" },
        },
        options = {
          timeout = 15000
        }

      }

      for _, language in ipairs(js_based_files) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require 'dap.utils'.pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome to debug client side code",
            url = "http://localhost:3000",
            sourceMaps = true,
            webRoot = "${workspaceFolder}/src",
            protocol = "inspector",
            port = 9230,
            skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
          }
        }
      end


      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>dc", dap.continue)
      vim.keymap.set("n", "<leader>ds", dap.step_into)
      vim.keymap.set("n", "<leader>dx", dap.terminate)

      local dapui = require("dapui")
      dapui.setup()

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end
  },
}
