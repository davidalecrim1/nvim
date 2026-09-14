return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = true, -- Enable inline git blame
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- Display text at the End Of Line
      delay = 300, -- Delay in milliseconds before blame shows up
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "   <author>, <author_time:%R> - <summary>",
    -- Staged hunks get a hollow sign so the gutter distinguishes them from
    -- unstaged work, the way VS Code's gutter does.
    signs_staged_enable = true,
    signs_staged = {
      add = { text = "┃" },
      change = { text = "┃" },
      delete = { text = "▁" },
      topdelete = { text = "▔" },
      changedelete = { text = "~" },
    },
  },
}
