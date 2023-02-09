require("iron.core").setup {
  config = {
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    repl_open_cmd = require('iron.view').split.vertical.botright(function()
        return vim.o.columns * 0.4
    end),
    scope = require("iron.scope").tab_based,
    close_window_on_exit = true,
    repl_definition = {
      fish = {
        -- Can be a table or a function that
        -- returns a table (see below)
        command = {"fish"}
      },
      python = require("iron.fts.python").ipython,
      sh = require("iron.fts.sh").bash,
      javascript = {
        command = function(meta)
          local filename = vim.api.nvim_buf_get_name(meta.current_bufnr)
          if string.find(filename, "mongo.js") then
            return {'mongosh'}
          else
            return {'node'}
          end
        end
      },
      typescript = {
        command = function(meta)
          local filename = vim.api.nvim_buf_get_name(meta.current_bufnr)
          if string.find(filename, "yarn.ts") then
            return {'yarn', 'ts-node'}
          else
            return {'ts-node'}
          end
        end
      },
    }
  },
  -- If the highlight is on, you can change how it looks
  -- For the available options, check nvim_set_hl
  highlight = {
    italic = true
  },
  ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
}

