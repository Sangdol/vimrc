local iron = require("iron.core")

iron.setup {
  config = {
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    -- Your repl definitions come here
    repl_definition = {
      sh = {
        -- Can be a table or a function that
        -- returns a table (see below)
        command = {"fish"}
      }
    },
    -- How the repl window will be displayed
    -- See below for more information
    repl_open_cmd = require('iron.view').split.vertical.botright(100),
    scope = require("iron.scope").tab_based,
    close_window_on_exit = true,
    repl_definition = {
     -- forcing a default
      python = require("iron.fts.python").ipython
    }
  },
  -- Iron doesn't set keymaps by default anymore.
  -- You can set them here or manually add keymaps to the functions in iron.core
  keymaps = {
    send_motion = "<space>zs",
    visual_send = "<space>zs",
    send_file = "<S-CR>",
    send_line = "<C-CR>",
    send_mark = "<space>zd",
    mark_motion = "<space>zma",
    mark_visual = "<space>zma",
    remove_mark = "<space>zmr",
    cr = "<space>z<cr>",
    interrupt = "<space>zc<space>",
    exit = "<space>zq",
    clear = "<space>zl",
  },
  -- If the highlight is on, you can change how it looks
  -- For the available options, check nvim_set_hl
  highlight = {
    italic = true
  },
  ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
}

