return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.enabled = function()
        return vim.bo.filetype ~= "markdown"
          and vim.bo.buftype ~= "prompt"
          and vim.b.completion ~= false
      end
    end,
  },
}
