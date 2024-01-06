-- https://github.com/xiyaowong/coc-symbol-line
function _G.symbol_line()
  local curwin = vim.g.statusline_winid or 0
  local curbuf = vim.api.nvim_win_get_buf(curwin)
  local ok, line = pcall(vim.api.nvim_buf_get_var, curbuf, 'coc_symbol_line')
  -- show window number
  return ok and line or ' ⋮' .. vim.api.nvim_win_get_number(curwin)
end

vim.o.winbar = '%!v:lua.symbol_line()'
