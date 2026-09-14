-- LazyGit reuses `activeBorderColor` for two different things: the border
-- of the panel that currently has keyboard focus, AND the label of the
-- "currently shown" tab inside grouped, UNFOCUSED panels (e.g. "Local
-- branches" vs "Remotes"/"Tags"). There's no separate LazyGit config field
-- to split these, so any saturated accent color (orange, green, ...) ends
-- up looking like a selection indicator even on panels that aren't
-- focused. Using the same grey as the borders (bold, for weight) keeps
-- unfocused titles reading as one uniform line; true focus is then shown
-- by the whole border going bold-bright instead of a color shift.
return {
  "folke/snacks.nvim",
  opts = {
    lazygit = {
      theme = {
        activeBorderColor = { fg = "FloatBorder", bold = true },
      },
    },
  },
}
