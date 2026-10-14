-- Live grep defaults to regex, so pasted text is treated as a pattern and dots,
-- parens, brackets, etc. must be escaped. Make it search literally instead, the
-- way VS Code and Zed do. Alt+r in the picker toggles regex back on for power
-- searches; the R flag in the title marks regex mode so it's not ambiguous.
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        grep = {
          regex = false,
        },
      },
      toggles = {
        regex = { value = true },
      },
    },
  },
}
