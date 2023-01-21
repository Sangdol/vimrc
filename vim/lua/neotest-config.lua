--
-- Neotest config
-- See https://github.com/wookayin/dotfiles/blob/master/nvim/lua/config/testing.lua
--
require("neotest").setup {
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
      args = { "-vv", "-s" },
      runner = 'pytest',
    }),
    require("neotest-vim-test")({
      allow_file_types = { "typescript", "javascript" },
    }),
  },
}
