require'nvim-tree'.setup {
  renderer = {
    highlight_git = true,
    indent_markers = {
      enable = true
    },
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌"
        },
        folder = {
          arrow_open = "",
          arrow_closed = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        }
      }
    }
  },
  view = {
    -- :h nvim-tree-mappings
    mappings = {
      list = {
        { key = "!", action = "run_file_command" },
        { key = ".", action = "" },
        { key = "<C-e>", action = "" } -- to disable "edit_in_place"
      }
    }
  },
  actions = {
    open_file = {
      resize_window = false
    }
  }
}
