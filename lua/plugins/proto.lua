return {
  -- Add syntax parser
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "proto" })
      end
    end,
  },

  -- Enable Buf Language Server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        buf_ls = {},
      },
    },
  },

  -- Auto-formatting on save
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        proto = { "buf" },
      },
    },
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        proto = { "buf_lint" },
      },
    },
  },
}
