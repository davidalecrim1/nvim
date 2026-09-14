-- Neovim 0.12+ default keymaps come from vim/_core/defaults.lua as callbacks.
-- snacks.nvim resolves debug sources like "@vim/_core/defaults" to a path
-- without the ".lua" suffix, which breaks preview/jump for those keymaps.
return {
  "folke/snacks.nvim",
  init = function()
    local function patch()
      local ok, M = pcall(require, "snacks.picker.source.vim")
      if not ok or M._keymaps_path_fix then
        return
      end
      M._keymaps_path_fix = true
      local keymaps = M.keymaps
      function M.keymaps(opts)
        local items = keymaps(opts)
        for _, item in ipairs(items) do
          if item.file and vim.fn.filereadable(item.file) == 0 then
            local path = item.file .. ".lua"
            if vim.fn.filereadable(path) == 1 then
              item.file = path
            end
          end
        end
        return items
      end
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      once = true,
      callback = patch,
    })
    vim.defer_fn(patch, 0)
  end,
}
