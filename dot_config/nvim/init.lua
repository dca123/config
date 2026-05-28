require("config.lazy")

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>r",
  "<cmd>source " .. vim.fn.stdpath("config") .. "/init.lua<CR> :lua print('Init reloaded')<CR>")
-- vim.keymap.set("n", "<space>x", ":.lua<CR>");
-- vim.keymap.set("v", "<space>x", ":lua<CR>");

vim.keymap.set('n', 'grn', vim.lsp.buf.rename)
vim.keymap.set('n', 'gra', vim.lsp.buf.code_action)
vim.keymap.set('n', 'grr', vim.lsp.buf.references)

vim.keymap.set({ "n", "v" }, "cy", '"+y', { desc = "Copy to System Clipboard" })

-- Window management
vim.keymap.set({ "n" }, "<M-h>", "<C-w>h", { desc = "Move window left" })
vim.keymap.set({ "n" }, "<M-j>", "<C-w>j", { desc = "Move window bottom" })
vim.keymap.set({ "n" }, "<M-k>", "<C-w>k", { desc = "Move window top" })
vim.keymap.set({ "n" }, "<M-l>", "<C-w>l", { desc = "Move window right" })
vim.keymap.set({ "n" }, "<M-v>", "<C-w>v<C-w>l", { desc = "Split Vertically and Focus" })
vim.keymap.set({ "n" }, "<M-S-v>", "<C-w>q", { desc = "Quit Window" })

-- Clear highlights
vim.keymap.set("n", "<leader>ch", "<CMD>noh<CR>", { desc = "Clear highlights" })
-- Auto-hide search highlights in insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		vim.opt.hlsearch = false
	end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		vim.opt.hlsearch = true
	end,
})
-- Exit terminal mode
vim.keymap.set('t', '<M-Esc>', '<C-\\><C-n>', { noremap = true, desc = "Exit terminal" })
-- Enter terminal mode
vim.keymap.set('n', '<leader>t', '<CMD>terminal<CR>', { noremap = true, desc = "Open terminal" })
vim.keymap.set('n', '<leader>oc', '<CMD>terminal opencode<CR>i', { noremap = true, desc = "Open OpenCode" })

vim.keymap.set("n", '<leader>i',
  function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })
  end,
  { desc = "Toggle inlay hints" }
)

vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.swapfile = false
vim.opt.scrolloff = 999
vim.opt.signcolumn = "yes:1"

-- Keep host terminal/terminal app scrolling in terminal buffers by disabling
-- Neovim mouse handling while a terminal buffer is focused.
local default_mouse = vim.o.mouse
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "TermEnter" }, {
  group = vim.api.nvim_create_augroup("TerminalMouse", { clear = true }),
  callback = function(ev)
    if vim.bo[ev.buf].buftype == "terminal" then
      vim.o.mouse = ""
    else
      vim.o.mouse = default_mouse
    end
  end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("TerminalMouseRestore", { clear = true }),
  callback = function()
    vim.o.mouse = default_mouse
  end,
})

-- Make terminal buffers feel more native: when focused, go straight back into
-- terminal-job mode so typing works immediately.
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = vim.api.nvim_create_augroup("TerminalAutoInsert", { clear = true }),
  callback = function(ev)
    if vim.bo[ev.buf].buftype == "terminal" then
      vim.cmd("startinsert")
    end
  end,
})

-- Terminal buffers usually have empty `filetype`, so `after/ftplugin/terminal.lua`
-- won't run for `:terminal`. Set `filetype=terminal` so the ftplugin applies.
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("TerminalFiletype", { clear = true }),
  callback = function(ev)
    if vim.bo[ev.buf].filetype == "" then
      vim.bo[ev.buf].filetype = "terminal"
    end
  end,
})

vim.opt.title = true
vim.opt.titlestring = [[%{fnamemodify(getcwd(), ':t')}]]

vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldminlines = 5

-- Persistent Undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Copy file path
vim.keymap.set("n", "<leader>cp", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
end, { desc = "Copy file path" })
