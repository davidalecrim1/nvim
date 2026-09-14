return {
  "folke/snacks.nvim",
  -- Explorer search (`/`) hardcodes fd and can't fall back: rg lists files
  -- only and can't emit directories, and snacks appends fd's own flags to
  -- whichever tool it picks. Warn plainly instead of "No supported finder found".
  init = function()
    if vim.fn.executable("fd") == 0 and vim.fn.executable("fdfind") == 0 then
      vim.schedule(function()
        vim.notify("snacks explorer search needs `fd` -- install it: brew install fd", vim.log.levels.WARN)
      end)
    end
  end,
  opts = {
    picker = {
      sources = {
        explorer = {
          hidden = true,
        },
      },
    },
  },
}
