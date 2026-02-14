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

      local function basename(path)
        return (path:gsub("\\", "/")):match("([^/]+)$") or path
      end

      local function tty_from_pty(pty)
        if type(pty) ~= "string" or pty == "" then
          return nil
        end

        -- Examples:
        --   macOS: /dev/ttys003 -> ttys003
        --   Linux: /dev/pts/1   -> pts/1
        local norm = pty:gsub("\\", "/")
        return (norm:gsub("^/dev/", ""))
      end

      local function terminal_running_command(bufnr, cache)
        cache = cache or {}
        cache.running = cache.running or {}

        if cache.running[bufnr] ~= nil then
          return cache.running[bufnr] or nil
        end

        local chan = vim.bo[bufnr].channel
        if not chan or chan == 0 then
          cache.running[bufnr] = false
          return nil
        end

        local ok, info = pcall(vim.api.nvim_get_chan_info, chan)
        if not ok or not info or type(info.pty) ~= "string" or info.pty == "" then
          cache.running[bufnr] = false
          return nil
        end

        local tty = tty_from_pty(info.pty)
        if not tty or tty == "" then
          cache.running[bufnr] = false
          return nil
        end

        local shell_pid = tonumber(vim.fn.jobpid(chan))
        if not shell_pid then
          cache.running[bufnr] = false
          return nil
        end

        local cmd = { "ps", "-t", tty, "-o", "pid=,ppid=,command=" }
        local ps = vim.system(cmd, { text = true }):wait()
        if not ps or ps.code ~= 0 or not ps.stdout or ps.stdout == "" then
          cache.running[bufnr] = false
          return nil
        end

        local processes = {}
        for _, line in ipairs(vim.split(vim.trim(ps.stdout), "\n", { trimempty = true })) do
          local pid, ppid, command = line:match("^%s*(%d+)%s+(%d+)%s+(.*)$")
          pid, ppid = tonumber(pid), tonumber(ppid)
          if pid and ppid and command and command ~= "" then
            processes[pid] = { ppid = ppid, command = vim.trim(command) }
          end
        end

        local function is_descendant(pid)
          local depth = 0
          local cur = pid
          while processes[cur] and depth < 50 do
            if cur == shell_pid then
              return true, depth
            end
            cur = processes[cur].ppid
            depth = depth + 1
          end
          return false, depth
        end

        local best_cmd
        local best_depth = -1
        for pid, proc in pairs(processes) do
          if pid ~= shell_pid and not proc.command:match("^ps%s") then
            local ok_desc, depth = is_descendant(pid)
            if ok_desc and depth > best_depth then
              best_depth = depth
              best_cmd = proc.command
            end
          end
        end

        cache.running[bufnr] = best_cmd or false
        return best_cmd
      end

      local function terminal_last_command(bufnr, cache)
        cache = cache or {}
        cache.last = cache.last or {}

        if cache.last[bufnr] ~= nil then
          return cache.last[bufnr] or nil
        end

        if not vim.api.nvim_buf_is_loaded(bufnr) then
          cache.last[bufnr] = false
          return nil
        end

        local line_count = vim.api.nvim_buf_line_count(bufnr)
        local start = math.max(line_count - 200, 0)
        local lines = vim.api.nvim_buf_get_lines(bufnr, start, line_count, false)

        local patterns = {
          "^%s*[>$#]%s+(.+)$",
          "^%s*❯%s+(.+)$",
          "^%s*➜%s+(.+)$",
          "^%s*%$%s+(.+)$",
        }

        for i = #lines, 1, -1 do
          local line = vim.trim(lines[i] or "")
          if line ~= "" then
            for _, pat in ipairs(patterns) do
              local cmd = line:match(pat)
              if cmd then
                cmd = vim.trim(cmd)
                if cmd ~= "" then
                  cache.last[bufnr] = cmd
                  return cmd
                end
              end
            end
          end
        end

        cache.last[bufnr] = false
        return nil
      end

      local function terminal_label(bufnr, cache)
        local shell0 = basename(vim.o.shell or "")

        -- Prefer last executed command (works for quick commands like `git status`).
        local last = terminal_last_command(bufnr, cache)
        if last and last ~= "" then
          return last
        end

        -- Fallback: detect currently-running foreground-ish process via `ps`.
        local running = terminal_running_command(bufnr, cache)
        if running and running ~= "" then
          local running0 = basename(running:match("^(%S+)") or running)
          if running0 ~= shell0 then
            return running
          end
        end

        -- Fallback to channel argv (often just the shell)
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

            return argv0
          end
        end

        -- Fallback: parse terminal buffer name like "term://...:<cmd>".
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name ~= "" then
          local cmd = name:match("^term://.*:(.*)$") or name:match(".*:(.*)$")
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
        opts._terminal_cmd_cache = {}

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

            local label = terminal_label(entry.bufnr, ref_opts._terminal_cmd_cache)
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
