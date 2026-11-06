-- LazyVim maps <leader>sr to grug.open() unconditionally: pressing it again
-- stacks another panel, and it splits the current window even when that window
-- is still the start screen, leaving the dashboard on screen next to the
-- results. Toggle the panel and dismiss the dashboard when it opens.
local function dashboard_wins()
  local wins = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "snacks_dashboard" then
      wins[#wins + 1] = win
    end
  end
  return wins
end

local function open()
  local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
  require("grug-far").open({
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= "" and "*." .. ext or nil,
    },
  })

  -- Only safe once the panel has its own window, otherwise this would close
  -- the last window in the tab.
  local wins = dashboard_wins()
  if #vim.api.nvim_tabpage_list_wins(0) > #wins then
    for _, win in ipairs(wins) do
      vim.api.nvim_win_close(win, true)
    end
  end
end

local function toggle()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "grug-far" then
      -- Instance close asks for confirmation before aborting an in-flight
      -- replace/sync, so prefer it over closing the window directly.
      local ok, inst = pcall(require("grug-far").get_instance, buf)
      if ok and inst then
        inst:close()
      else
        vim.api.nvim_win_close(win, true)
      end
      return
    end
  end

  open()
end

return {
  "MagicDuck/grug-far.nvim",
  keys = {
    { "<leader>sr", toggle, mode = { "n", "x" }, desc = "Search and Replace (toggle)" },
  },
}
