return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              buildFlags = { "-tags=integration" },
              analyses = {
                ST1000 = false, -- package comments; excluded by golangci-lint defaults
              },
            },
          },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters = opts.linters or {}
      opts.linters.golangcilint = opts.linters.golangcilint or {}
      local config = vim.fn.expand("~/.golangci.yml")
      if vim.fn.filereadable(config) == 1 then
        opts.linters.golangcilint.prepend_args = { "--config", config }
      else
        opts.linters.golangcilint.prepend_args = {}
      end
    end,
  },
  {
    "nvim-neotest/neotest",
    ft = { "go", "gomod", "gowork", "gotmpl" },
    opts = {
      adapters = {
        ["neotest-golang"] = {
          go_test_args = { "-v", "-race", "-count=1", "-tags=integration" },
          go_list_args = { "-tags=integration" },
          dap_go_opts = {
            delve = {
              build_flags = { "-tags=integration" },
            },
          },
        },
      },
    },
  },
}
