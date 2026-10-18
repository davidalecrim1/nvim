-- $HOME is a git repo (the dotfiles repo) whose .gitignore ignores everything
-- below ~/Documents/Code. Tools that inherit parent ignore rules therefore see
-- almost nothing when nvim is started there, and the explorer drops every entry
-- git reports as ignored.
--
-- Explorer: git status is the only source of ignore data, so ask for ignored
-- entries (nested directories stay collapsed, `I` still toggles them off).
--
-- Files and grep: skip ignore files from directories above the search root only,
-- so the home repo's rules no longer apply while each project's own .gitignore
-- still filters its build output.
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = { ignored = true },
        files = { args = { "--no-ignore-parent" } },
        grep = { args = { "--no-ignore-parent" } },
      },
    },
  },
}
