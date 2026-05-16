# Neovim Configuration

This is a custom Neovim configuration optimized for a modern development experience. It uses **lazy.nvim** as the plugin manager and is structured for modularity and performance.

## Features

- **Plugin Management**: Powered by [lazy.nvim](https://github.com/folke/lazy.nvim).
- **LSP Support**: Configured for various languages with autocompletion via `blink.cmp`.
- **File Navigation**: Uses `telescope.nvim` for fuzzy finding and `oil.nvim` for file system editing.
- **UI Enhancements**: 
  - **Dracula** colorscheme.
  - Custom status line and greeter.
  - **markview.nvim** for beautiful Markdown previews directly in the buffer.
- **Git Integration**: `gitsigns.nvim` for inline git diffs.

## Structure

- `init.lua`: The main entry point.
- `lua/config/`:
  - `lazy.lua`: Plugin manager bootstrap and core settings.
  - `plugins/`: Modular plugin configurations (LSP, UI, Editor, etc.).
- `after/ftplugin/`: Language-specific settings.

## Keybindings

- `<leader>r`: Reload configuration.
- `<leader>ff`: Find files (Telescope).
- `<leader>fg`: Live grep (Telescope).
- `grn`: Rename symbol (LSP).
- `gra`: Code actions (LSP).

---

*This README was generated to demonstrate the **markview.nvim** plugin.*
