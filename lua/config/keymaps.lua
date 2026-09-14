-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
vim.keymap.set("n", "<leader>j", "}", { desc = "Next paragraph" })
vim.keymap.set("n", "<leader>k", "{", { desc = "Previous paragraph" })

-- Split panes (match tmux: prefix+v / prefix+-)
vim.keymap.set("n", "<leader>v", "<cmd>vsplit<cr><cmd>wincmd =<cr>", { desc = "Split right (horizontal)" })
vim.keymap.set("n", "<leader>-", "<cmd>split<cr><cmd>wincmd =<cr>", { desc = "Split below (vertical)" })
vim.keymap.del("n", "<leader>|")

-- macOS Option/Command word + line editing. iTerm already sends these through;
-- <M-b>/<M-f> cover the common Esc+b / Esc+f Option+arrow encoding.
local macos_edit = {
  {
    keys = { "<A-Left>", "<M-b>" },
    n = "b",
    i = "<S-Left>",
    c = "<S-Left>",
    x = "b",
    desc = "Word left",
  },
  {
    keys = { "<A-Right>", "<M-f>" },
    n = "w",
    i = "<S-Right>",
    c = "<S-Right>",
    x = "w",
    desc = "Word right",
  },
  {
    keys = { "<D-Left>" },
    n = "0",
    i = "<Home>",
    c = "<Home>",
    x = "0",
    desc = "Line start",
  },
  {
    keys = { "<D-Right>" },
    n = "$",
    i = "<End>",
    c = "<End>",
    x = "$",
    desc = "Line end",
  },
  {
    keys = { "<A-BS>" },
    n = "db",
    i = "<C-w>",
    c = "<C-w>",
    x = "d",
    desc = "Delete word backward",
  },
  {
    keys = { "<D-BS>" },
    n = "d0",
    i = "<C-u>",
    c = "<C-u>",
    x = "d",
    desc = "Delete to line start",
  },
}

for _, spec in ipairs(macos_edit) do
  for _, lhs in ipairs(spec.keys) do
    vim.keymap.set("n", lhs, spec.n, { desc = spec.desc })
    vim.keymap.set("i", lhs, spec.i, { desc = spec.desc })
    vim.keymap.set("c", lhs, spec.c, { desc = spec.desc })
    vim.keymap.set("x", lhs, spec.x, { desc = spec.desc })
  end
end
