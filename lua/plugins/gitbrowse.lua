-- LazyVim already maps <leader>gB / <leader>gY to open/copy the current file+line
-- on the current branch. Those URLs break once the branch is renamed, rebased or
-- deleted, so these add the permalink variants (pinned to the file's last commit)
-- for links that get shared with other people.
return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>gu",
      function()
        Snacks.gitbrowse({ what = "permalink" })
      end,
      mode = { "n", "x" },
      desc = "Git Browse Permalink (open)",
    },
    {
      "<leader>gU",
      function()
        Snacks.gitbrowse({
          what = "permalink",
          open = function(url)
            vim.fn.setreg("+", url)
          end,
          notify = false,
        })
      end,
      mode = { "n", "x" },
      desc = "Git Browse Permalink (copy)",
    },
  },
}
