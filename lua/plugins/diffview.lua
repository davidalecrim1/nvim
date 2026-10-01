-- Change-review surface: file panel on the left, diff on the right.
-- LazyVim already owns <leader>gd/<leader>gf/<leader>gg, so this lives on <leader>gv.
-- Diffview views live per tabpage, so get_current_view() misses one that is
-- open in another tab and we would end up with two. Focus any matching view
-- first; only open a new one when none exists. DiffView always carries a
-- `files` dict, FileHistoryView does not - that is how we tell them apart.
local function focus_or_open(cmd, history)
  return function()
    local lib = require("diffview.lib")
    local cur_tab = vim.api.nvim_get_current_tabpage()
    for _, view in ipairs(lib.views) do
      if
        vim.api.nvim_tabpage_is_valid(view.tabpage)
        and (view.files == nil) == (history ~= nil)
      then
        if view.tabpage == cur_tab then
          vim.cmd("DiffviewClose")
        else
          vim.api.nvim_set_current_tabpage(view.tabpage)
        end
        return
      end
    end
    vim.cmd(cmd)
  end
end

-- Diff the whole branch against where it forked off the trunk.
local function diff_trunk()
  local function exists(ref)
    return vim.system({ "git", "rev-parse", "--verify", "--quiet", ref }):wait().code == 0
  end
  local trunk = exists("origin/main") and "origin/main"
    or exists("origin/master") and "origin/master"
    or exists("main") and "main"
    or "master"
  vim.cmd("DiffviewOpen " .. trunk .. "...HEAD")
end

-- Pick any past commit and review everything from it up to HEAD. The range is
-- anchored on the commit's parent so the picked commit is itself included:
-- <sha>...HEAD alone is empty when you pick HEAD, which just looks broken.
local function diff_commit()
  Snacks.picker.git_log({
    -- Plain `git show` prints no patch for a merge commit, so picking one of
    -- those previewed as a bare message. Diff against the first parent instead:
    -- everything the merged branch brought in, the way a PR reads.
    preview = function(ctx)
      Snacks.picker.preview.cmd({
        "git",
        "--no-pager",
        "show",
        "-m",
        "--first-parent",
        "--stat",
        "--patch",
        ctx.item.commit,
      }, ctx, { ft = "git" })
    end,
    confirm = function(picker, item)
      picker:close()
      if not (item and item.commit) then
        return
      end
      -- The very first commit of a repo has no parent to anchor on.
      local parent = item.commit .. "^"
      local check = { "git", "rev-parse", "--verify", "--quiet", parent }
      if vim.system(check, { cwd = item.cwd }):wait().code ~= 0 then
        parent = item.commit
      end
      vim.cmd("DiffviewOpen " .. parent .. "...HEAD")
    end,
  })
end

-- Diffview folds unchanged regions so only the diff is visible. Toggling turns
-- that off and shows the whole file. The choice is re-applied whenever a diff
-- buffer opens so it sticks while browsing the file list.
local show_full_file = false

local function toggle_full_file()
  show_full_file = not show_full_file
  local lib = require("diffview.lib")
  for _, view in ipairs(lib.views) do
    if vim.api.nvim_tabpage_is_valid(view.tabpage) and view.cur_layout then
      for _, win in ipairs(view.cur_layout.windows) do
        if vim.api.nvim_win_is_valid(win.id) then
          vim.wo[win.id].foldenable = not show_full_file
        end
      end
    end
  end
end

return {
  "sindrets/diffview.nvim",
  lazy = false,
  cmd ={ "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
  keys = {
    { "<leader>gv", focus_or_open("DiffviewOpen"), desc = "Diffview (working tree)" },
    { "<leader>gV", focus_or_open("DiffviewFileHistory %", true), desc = "Diffview (file history)" },
    { "<leader>gm", diff_trunk, desc = "Diffview (vs trunk)" },
    { "<leader>gC", diff_commit, desc = "Diffview (pick commit vs HEAD)" },
  },
  opts = function()
    local actions = require("diffview.actions")
    return {
      enhanced_diff_hl = true,
      hooks = {
        diff_buf_win_enter = function(_, winid)
          vim.wo[winid].foldenable = not show_full_file
        end,
      },
      view = {
        default = { winbar_info = true },
        merge_tool = { layout = "diff3_mixed", winbar_info = true },
      },
      file_panel = {
        listing_style = "tree",
        win_config = { position = "left", width = 36 },
      },
      keymaps = {
        view = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
          -- g<C-x> is the default but awkward to reach; gl = "layout".
          { "n", "gl", actions.cycle_layout, { desc = "Cycle layout (side-by-side / stacked)" } },
          { "n", "zF", toggle_full_file, { desc = "Toggle full file / diff only" } },
        },
        file_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
          -- o/l open the diff but keep the cursor in the panel for browsing;
          -- <cr> opens it and jumps into the diff, like VS Code's file list.
          { "n", "<cr>", actions.focus_entry, { desc = "Open diff and focus it" } },
          { "n", "s", actions.toggle_stage_entry, { desc = "Stage / unstage entry" } },
          { "n", "u", actions.toggle_stage_entry, { desc = "Stage / unstage entry" } },
          { "n", "S", actions.stage_all, { desc = "Stage all" } },
          { "n", "U", actions.unstage_all, { desc = "Unstage all" } },
          { "n", "X", actions.restore_entry, { desc = "Discard changes in entry" } },
          { "n", "zF", toggle_full_file, { desc = "Toggle full file / diff only" } },
        },
        file_history_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
        },
      },
    }
  end,
}
