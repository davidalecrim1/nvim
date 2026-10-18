-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Add a trailing newline when writing. Opening/viewing a file does not change it.
vim.opt.fixendofline = true

-- Pin the root to the directory nvim was started in. The default spec looks for
-- `.git` upward, and $HOME is itself a repo (the dotfiles repo), so every folder
-- below it resolves to $HOME -- the explorer, file/grep pickers and terminal all
-- jumped out of the project you opened.
vim.g.root_spec = { "cwd" }
