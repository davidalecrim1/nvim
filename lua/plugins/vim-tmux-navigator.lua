return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Navigate left" },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Navigate down" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Navigate up" },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Navigate right" },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Navigate previous split" },
  },
  init = function()
    -- LazyVim maps these to window navigation; let vim-tmux-navigator handle them.
    pcall(vim.keymap.del, "n", "<C-h>")
    pcall(vim.keymap.del, "n", "<C-j>")
    pcall(vim.keymap.del, "n", "<C-k>")
    pcall(vim.keymap.del, "n", "<C-l>")
  end,
}
