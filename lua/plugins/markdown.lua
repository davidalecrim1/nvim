-- Wide tables are the reason this exists. render-markdown refuses to render at
-- all once the window is horizontally scrolled (core/ui.lua: leftcol == 0), so
-- a table wider than the window either has its cells folded into a tall stack
-- or disappears from the screen when you scroll sideways. markview renders the
-- table at its natural width and keeps it rendered while scrolling.
return {
  { "MeanderingProgrammer/render-markdown.nvim", enabled = false },

  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    keys = {
      { "<leader>um", "<cmd>Markview toggle<cr>", desc = "Toggle Markdown Render" },
      { "<leader>uM", "<cmd>Markview Toggle<cr>", desc = "Toggle Markdown Render (all buffers)" },
    },
    opts = {
      preview = {
        -- Rendered while reading and navigating; raw only while inserting.
        hybrid_modes = { "i" },
      },
    },
  },
}
