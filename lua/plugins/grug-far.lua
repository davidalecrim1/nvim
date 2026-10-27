return {
  "MagicDuck/grug-far.nvim",
  keys = {
    {
      "<leader>sr",
      function()
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "snacks_dashboard" then
            vim.api.nvim_set_current_win(win)
            vim.cmd("enew")
            vim.bo.buflisted = false
            vim.bo.bufhidden = "wipe"
            break
          end
        end
        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
        require("grug-far").open({
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        })
      end,
      mode = { "n", "x" },
      desc = "Search and Replace",
    },
  },
}
