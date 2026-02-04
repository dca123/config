return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim', { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' } },
    config = function()
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")
      local entry_display = require("telescope.pickers.entry_display")
      local make_entry = require("telescope.make_entry")

      require("telescope").setup({
        pickers = {
          buffers = {
            mappings = {
              n = {
                ["bd"] = actions.delete_buffer + actions.move_to_top,
              },
            },
          },
        },
        extensions = {
          fzf = {},
        },
      })
      require("telescope").load_extension("fzf")

      local function is_uri_path(name)
        return name:match("^%a[%w+.-]*://") ~= nil
      end

      local function is_file_buffer(bufnr)
        if vim.bo[bufnr].buftype ~= "" then
          return false
        end

        local name = vim.api.nvim_buf_get_name(bufnr)
        if name == "" then
          return false
        end

        if is_uri_path(name) then
          return false
        end

        return true
      end

      local function terminal_label(bufnr)
        local function basename(path)
          return (path:gsub("\\", "/")):match("([^/]+)$") or path
        end

        local shell0 = basename(vim.o.shell or "")

        local chan = vim.bo[bufnr].channel
        if chan and chan ~= 0 then
          local ok, info = pcall(vim.api.nvim_get_chan_info, chan)
          if ok and info and type(info.argv) == "table" and #info.argv > 0 then
            local argv = info.argv
            local argv0 = basename(argv[1])

            if argv0 ~= shell0 then
              return table.concat(argv, " ")
            end

            -- Common case: {shell, -c, <cmd>}
            if argv[2] == "-c" and argv[3] and argv[3] ~= "" then
              if #argv > 3 then
                return argv[3] .. " " .. table.concat(argv, " ", 4)
              end
              return argv[3]
            end
          end
        end

        -- Fallback: parse terminal buffer name like "term://...:<cmd>"
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name ~= "" then
          local cmd = name:match("^[^:]+:(.*)$")
          if cmd then
            cmd = vim.trim(cmd)
            if cmd ~= "" then
              return cmd
            end
          end
        end

        return "terminal"
      end

      local function terminal_exit_code(bufnr)
        local chan = vim.bo[bufnr].channel
        if not chan or chan == 0 then
          return nil
        end

        -- jobwait() returns {-1} if still running
        local ok, res = pcall(vim.fn.jobwait, { chan }, 0)
        if not ok or type(res) ~= "table" then
          return nil
        end

        local code = res[1]
        if code == -1 then
          return nil
        end

        return code
      end

      local function pick_file_buffers()
        local opts = {}
        opts.entry_maker = (function(ref_opts)
          local base
          return function(entry)
            if not is_file_buffer(entry.bufnr) then
              return nil
            end

            base = base or make_entry.gen_from_buffer(ref_opts)
            return base(entry)
          end
        end)(opts)

        builtin.buffers(opts)
      end

      local function pick_terminal_buffers()
        local opts = { previewer = false, disable_devicons = true }

        opts.entry_maker = (function(ref_opts)
          local displayer

          local function make_displayer()
            return entry_display.create({
              separator = " ",
              items = {
                { width = ref_opts.bufnr_width or 3 },
                { width = 4 },
                { width = 1 },
                { remaining = true },
              },
            })
          end

          local function compute_indicator(entry)
            local hidden = entry.info.hidden == 1 and "h" or "a"
            local readonly = vim.api.nvim_get_option_value("readonly", { buf = entry.bufnr }) and "=" or " "
            local changed = entry.info.changed == 1 and "+" or " "
            return entry.flag .. hidden .. readonly .. changed
          end

          local function exit_badge(bufnr)
            local code = terminal_exit_code(bufnr)
            if code == nil then
              return { " ", "TelescopeResultsComment" }
            end

            if code == 0 then
              return { "✓", "DiagnosticOk" }
            end

            return { "✗", "DiagnosticError" }
          end

          return function(entry)
            if vim.bo[entry.bufnr].buftype ~= "terminal" then
              return nil
            end

            displayer = displayer or make_displayer()

            local label = terminal_label(entry.bufnr)
            local indicator = compute_indicator(entry)
            local badge = exit_badge(entry.bufnr)

            return make_entry.set_default_entry_mt({
              value = label,
              ordinal = entry.bufnr .. " : " .. label,
              display = function()
                return displayer({
                  { entry.bufnr, "TelescopeResultsNumber" },
                  { indicator, "TelescopeResultsComment" },
                  badge,
                  label,
                })
              end,
              bufnr = entry.bufnr,
              indicator = indicator,
            }, ref_opts)
          end
        end)(opts)

        builtin.buffers(opts)
      end

      vim.keymap.set("n", "<leader>ht", builtin.help_tags)
      vim.keymap.set("n", "<leader><leader>", builtin.find_files, { nowait = true })
      vim.keymap.set("n", "<leader>bb", pick_file_buffers, { desc = "Buffers (files)" })
      vim.keymap.set("n", "<leader>bt", pick_terminal_buffers, { desc = "Buffers (terminals)" })

      vim.keymap.set("n", "<leader>en", function()
        builtin.find_files({
          cwd = vim.fn.stdpath("config"),
        })
      end)
      vim.keymap.set("n", "<leader>ep", function()
        builtin.find_files({
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
        })
      end)
      require("config.telescope.multigrep").setup()
    end
  }
}
