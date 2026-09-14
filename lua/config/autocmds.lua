-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Diffview index/commit panes are named diffview:// but keep buftype empty so
-- Neovim treats them as real files. helm_ls panics on that URI; format/lint
-- should not run on a review buffer either.
local function is_diffview_buf(buf)
  return vim.api.nvim_buf_get_name(buf):sub(1, 11) == "diffview://"
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("diffview_no_tools", { clear = true }),
  callback = function(ev)
    if is_diffview_buf(ev.buf) then
      vim.b[ev.buf].autoformat = false
    end
  end,
})

local start = vim.lsp.start
function vim.lsp.start(config, opts)
  local bufnr = vim._resolve_bufnr(opts and opts.bufnr)
  if is_diffview_buf(bufnr) then
    return
  end
  return start(config, opts)
end

local lint_patched = false
local function patch_lint()
  local ok, lint = pcall(require, "lint")
  if not ok or lint_patched then
    return
  end
  lint_patched = true
  local try_lint = lint.try_lint
  lint.try_lint = function(...)
    if is_diffview_buf(0) then
      return
    end
    return try_lint(...)
  end
end

if package.loaded["lint"] then
  patch_lint()
end
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("diffview_no_lint", { clear = true }),
  pattern = "LazyLoad",
  callback = function(ev)
    if ev.data == "nvim-lint" then
      patch_lint()
    end
  end,
})
