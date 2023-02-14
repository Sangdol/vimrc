require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = {'lua', 'python', 'typescript', 'javascript', 'ruby', 'bash', 'css', 'html', 'json', 'sql', 'vim', 'help'},

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- markdown is slow and highlights are not great
  ignore_install = { "markdown" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    disable = {},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    -- Sang:
    --   - Python and Lua look the same
    --   - Errors in vim when Lua code is in a file
    additional_vim_regex_highlighting = {''},
  },

  -- For textobjects
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ad"] = "@comment.outer",
        ["id"] = "@comment.inner",
        ["as"] = "@statement.outer",
      },

      include_surrounding_whitespace = true,
    },
  },
}

-- Workaound for wrong multiline comment indentation
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/1167#issuecomment-920824125
function _G.javascript_indent()
  local line = vim.fn.getline(vim.v.lnum)
  local prev_line = vim.fn.getline(vim.v.lnum - 1)
  if line:match('^%s*[%*/]%s*') then
    if prev_line:match('^%s*%*%s*') then
      return vim.fn.indent(vim.v.lnum - 1)
    end
    if prev_line:match('^%s*/%*%*%s*$') then
      return vim.fn.indent(vim.v.lnum - 1) + 1
    end
  end

  -- The functions are in the `indent/` directory.
  return vim.fn['GetJavascriptIndent']()
end

vim.cmd[[autocmd FileType javascript setlocal indentexpr=v:lua.javascript_indent()]]
vim.cmd[[autocmd FileType typescript setlocal indentexpr=v:lua.javascript_indent()]]
