-- Snacks' keymaps picker (<leader>sk) can't be reordered or pinned - it just
-- fuzzy-matches every registered keymap in registration order. This gives a
-- second, curated picker for the handful of mappings worth remembering.
local favorites = {
  { lhs = "<leader>ca", desc = "code: action" },
  { lhs = "<leader>rn", desc = "code: rename symbol" },
  { lhs = "<C-o>", desc = "code: jump back (after gd / go to definition)" },
  { lhs = "gd", desc = "lsp: go to definition" },
  { lhs = "gr", desc = "lsp: go to references" },
  { lhs = "<leader>gg", desc = "git: lazygit (root dir)" },
  { lhs = "<leader>ghr", desc = "git: discard hunk (restore to branch, then :w)" },
  { lhs = "<leader>ghR", desc = "git: discard every hunk in the file (then :w)" },
  { lhs = "]h", desc = "git: next hunk" },
  { lhs = "[h", desc = "git: previous hunk" },
  { lhs = "<leader>gv", desc = "diffview: uncommitted work (tree + index)" },
  { lhs = "<leader>gm", desc = "diffview: branch commits vs trunk" },
  { lhs = "<leader>gV", desc = "diffview: history of current file" },
  { lhs = "<leader>gC", desc = "diffview: pick a commit, everything since it vs HEAD" },
  { lhs = "zF", desc = "diffview: toggle full file / diff only" },
  { lhs = "gl", desc = "diffview: cycle layout (side-by-side / stacked)" },
  { lhs = "gf", desc = "diffview: open current file in the files tab" },
  { lhs = "<leader>gB", desc = "github: open file+line (current branch)" },
  { lhs = "<leader>gY", desc = "github: copy URL of file+line (current branch)" },
  { lhs = "<leader>gu", desc = "github: open file+line (permalink)" },
  { lhs = "<leader>gU", desc = "github: copy permalink of file+line" },
  { lhs = "1gt", desc = "tab: go to tab 1 (files)" },
  { lhs = "gt", desc = "tab: next tab (toggle files <-> diffview)" },
  { lhs = "2gt", desc = "tab: go to tab 2 (diffview)" },
  { lhs = "<C-w>q", desc = "window: close (like split buffer)" },
  { lhs = "<C-w>v", desc = "window: split vertically" },
  { lhs = "<C-w>s", desc = "window: split horizontally" },
  { lhs = "<C-w>w", desc = "window: cycle to next" },
  { lhs = "<C-w>o", desc = "window: close every other" },
  { lhs = "<C-w>=", desc = "window: equalize sizes" },
  { lhs = "<C-w>H", desc = "window: move far left (J/K/L for the others)" },
  { lhs = "<leader>fo", desc = "file: open (replace current buffer)" },
  { lhs = "<leader>fb", desc = "buffer: switch to open buffer" },
  { lhs = "<leader>br", desc = "buffer: delete to the right" },
  { lhs = "<leader>bl", desc = "buffer: delete to the left" },
  { lhs = "<leader>sr", desc = "search: search and replace" },
}

local function favorite_keymaps()
  Snacks.picker.pick({
    source = "favorite_keymaps",
    items = vim.tbl_map(function(f)
      return { text = f.lhs .. " " .. f.desc, lhs = f.lhs, desc = f.desc }
    end, favorites),
    format = function(item)
      return {
        { item.lhs, "SnacksPickerKeymapLhs" },
        { "  " },
        { item.desc },
      }
    end,
    confirm = function(picker, item)
      picker:close()
      vim.schedule(function()
        local keys = vim.api.nvim_replace_termcodes(item.lhs, true, false, true)
        vim.api.nvim_feedkeys(keys, "m", false)
      end)
    end,
  })
end

return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>sK", favorite_keymaps, desc = "Favorite Keymaps" },
  },
}
