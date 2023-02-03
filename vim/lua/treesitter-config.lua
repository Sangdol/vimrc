require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = {'lua', 'python', 'javascript', 'ruby', 'bash', 'css', 'html', 'json', 'sql', 'vim', 'help'},

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
