require("oil").setup({
  -- Custom
  delete_to_trash = true,
  watch_for_changes = true,

  -- Id is automatically added at the beginning, and name at the end
  -- See :help oil-columns
  columns = {
    "icon",
    -- "permissions",
    -- "size",
    -- "mtime",
  },
  -- Buffer-local options to use for oil buffers
  buf_options = {
    buflisted = false,
  },
  -- Window-local options to use for oil buffers
  win_options = {
    wrap = false,
    signcolumn = "no",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    conceallevel = 3,
    concealcursor = "n",
  },
  -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`
  default_file_explorer = true,
  -- Restore window options to previous values when leaving an oil buffer
  restore_win_options = true,
  -- Skip the confirmation popup for simple operations
  skip_confirm_for_simple_edits = false,
  -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
  -- options with a `callback` (e.g. { callback = function() ... end, desc = "", nowait = true })
  -- Additionally, if it is a string that matches "actions.<name>",
  -- it will use the mapping at require("oil.actions").<name>
  -- Set to `false` to remove a keymap
  -- See :help oil-actions for a list of all available actions
  keymaps = {
    ["g?"] = { "actions.show_help", mode = "n" },
    ["<CR>"] = "actions.select",
    ["<C-s>"] = { "actions.select", opts = { vertical = true } },
    ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
    ["<C-t>"] = { "actions.select", opts = { tab = true } },
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = { "actions.close", mode = "n" },
    ["<C-l>"] = "actions.refresh",
    ["-"] = { "actions.parent", mode = "n" },
    ["_"] = { "actions.open_cwd", mode = "n" },
    ["`"] = { "actions.cd", mode = "n" },
    ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
    ["gs"] = { "actions.change_sort", mode = "n" },
    ["gx"] = "actions.open_external",
    ["g."] = { "actions.toggle_hidden", mode = "n" },
    ["g\\"] = { "actions.toggle_trash", mode = "n" },
  },
  -- Set to false to disable all of the above keymaps
  use_default_keymaps = true,
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
    -- This function defines what is considered a "hidden" file
    is_hidden_file = function(name, bufnr)
      return vim.startswith(name, ".")
    end,
    -- This function defines what will never be shown, even when `show_hidden` is set
    is_always_hidden = function(name, bufnr)
      return false
    end,
  },
  -- Configuration for the floating window in oil.open_float
  float = {
    -- Padding around the floating window
    padding = 2,
    max_width = 0,
    max_height = 0,
    border = "rounded",
    win_options = {
      winblend = 10,
    },
  },
})

local oil = require("oil")

-- Helper function to show file info
local function show_file_info()
  local entry = oil.get_cursor_entry()
  if not entry then
    print("No file under cursor")
    return
  end

  local path = oil.get_current_dir() .. entry.name
  local stat = vim.loop.fs_stat(path)

  if not stat then
    print("Could not stat file: " .. path)
    return
  end

  local info = {
    "Path: " .. path,
    "Type: " .. stat.type,
    "Size: " .. stat.size .. " bytes",
    "Access: " .. os.date("%Y-%m-%d %H:%M:%S", stat.atime.sec),
    "Modify: " .. os.date("%Y-%m-%d %H:%M:%S", stat.mtime.sec),
    "Change: " .. os.date("%Y-%m-%d %H:%M:%S", stat.ctime.sec),
  }

  vim.notify(table.concat(info, "\n"), vim.log.levels.INFO, { title = "File Info" })
end

-- Keymap only in Oil buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function(event)
    vim.keymap.set("n", "<leader>ef", show_file_info, {
      buffer = event.buf,
      desc = "Show file info in Oil",
    })
  end,
})
