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

-- Open a file in the current window and drop the buffer it replaced, so the
-- picker doesn't leave a trail of buffers behind. Buffers with unsaved changes
-- or that are still shown in another window are kept.
vim.keymap.set("n", "<leader>fo", function()
  local replaced = vim.api.nvim_get_current_buf()
  Snacks.picker.files({
    confirm = function(picker, item)
      local path = item and (item.file or (item.buf and vim.api.nvim_buf_get_name(item.buf)))
      if not path or path == "" then
        return
      end
      if vim.fn.mode():sub(1, 1) == "i" then
        vim.cmd.stopinsert()
      end
      picker:close()
      vim.schedule(function()
        vim.cmd.edit(vim.fn.fnameescape(path))
        if
          replaced ~= vim.api.nvim_get_current_buf()
          and vim.api.nvim_buf_is_valid(replaced)
          and vim.bo[replaced].buftype == ""
          and not vim.bo[replaced].modified
          and #vim.fn.win_findbuf(replaced) == 0
        then
          pcall(vim.api.nvim_buf_delete, replaced, {})
        end
      end)
    end,
  })
end, { desc = "Open file (replace current buffer)" })

-- Terminal toggle, same action LazyVim binds to <c-/> (works in normal and terminal mode)
local toggle_terminal = function()
  local util = require("lazyvim.util")
  require("snacks.terminal").focus(nil, { cwd = util.root() })
end
for _, lhs in ipairs({ "<leader>ft", "<c-/>", "<c-_>", "<c-`>" }) do
  vim.keymap.set({ "n", "t" }, lhs, toggle_terminal, { desc = "Toggle Terminal" })
end

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

-- Visual-mode context yank: copies the selection plus the absolute path and
-- line range, so pasting into an AI agent carries its own provenance.
local context_yank_fence = {
  sh = "bash",
  zsh = "bash",
  javascript = "js",
  javascriptreact = "jsx",
  typescript = "ts",
  typescriptreact = "tsx",
  markdown = "md",
}

local function context_yank()
  local first, last = vim.fn.getpos("v"), vim.fn.getpos(".")
  if first[2] > last[2] or (first[2] == last[2] and first[3] > last[3]) then
    first, last = last, first
  end

  local l1, l2 = first[2], last[2]
  local lines = vim.api.nvim_buf_get_lines(0, l1 - 1, l2, false)
  if vim.fn.mode() == "v" then
    if l1 == l2 then
      lines[1] = lines[1]:sub(first[3], last[3])
    else
      lines[1] = lines[1]:sub(first[3])
      lines[#lines] = lines[#lines]:sub(1, last[3])
    end
  end

  local ft = vim.bo.filetype
  local lang = context_yank_fence[ft] or ft
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    path = "[No Name]"
  end
  local ref = path .. ":" .. (l1 == l2 and tostring(l1) or (l1 .. "-" .. l2))
  local fence = lang ~= "" and ("```" .. lang) or "```"
  local payload = fence .. "\n" .. table.concat(lines, "\n") .. "\n```\n\n" .. ref

  vim.fn.setreg("+", payload)
  vim.fn.setreg('"', payload)
  vim.notify(string.format("Copied %d lines + ref", #lines), vim.log.levels.INFO)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end

vim.keymap.set({ "x", "s" }, "Y", context_yank, { desc = "Yank selection + file/line context" })
