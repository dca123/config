-- toggle "use client" for client / server components
vim.keymap.set("n", "rtc", function()
  local first_line = vim.fn.getline(1)
  local has_use_client = string.find(first_line, "use client") ~= nil
  if has_use_client then
    vim.fn.deletebufline('%', 1)
    vim.notify("Removed 'use client'", vim.log.levels.INFO)
  else
    vim.fn.append(0, [["use client"]])
    vim.notify("Added 'use client'", vim.log.levels.INFO)
  end
end)

vim.cmd("iab log console.log()<Left>")
vim.cmd("iab if if()<Left>")
vim.opt_local.iskeyword:append("-")
