--[[

  ChatGPT client config

]]--

local client = require('chatgpt-client')
local SEPARATOR = '\n---\n'

-- Call ChatGPT API for improving English of code comments.
function ChatGPTImproveEnglish()
  local filetype = vim.bo.filetype
  local prompt = "Fix the grammar or improve the English. " ..
        "The provided text can be a code comment. \n" ..
        "```" .. filetype .. "\n" ..
        "{placeholder}\n" ..
        "```"
  local comment = vim.fn.GetVisualSelection()
  local text = string.gsub(prompt, '{placeholder}', comment)
  local messages = {{role='user', content=text}}

  local current_tab = vim.api.nvim_win_get_tabpage(0)
  local current_win = vim.api.nvim_get_current_win()

  client.call(messages, function(output)
    -- Restore the current tab and window.
    vim.api.nvim_set_current_tabpage(current_tab)
    vim.api.nvim_set_current_win(current_win)

    -- Open the result in a new vertical buffer.
    vim.cmd('vnew')
    vim.fn.SaveToTempWithTimestamp('~/workbench/chatgpt/', 'md')
    vim.fn.setline(1, vim.split(output, "\n"))
  end)
end

--
-- Ask ChatGPT with a visual selection.
--
function ChatGPTAsk()
  local filetype = vim.bo.filetype
  local instruction = vim.fn.input('Ask: ')
  local prompt = instruction .. "\n\n" ..
        "```" .. filetype .. "\n" ..
        "{placeholder}\n" ..
        "```"
  local code = vim.fn.GetVisualSelection()
  local question = string.gsub(prompt, "{placeholder}", code)
  local messages = {{role = "user", content = question}}

  if instruction == "" then
    vim.api.nvim_err_writeln("The instruction is empty.")
    return
  end

  local current_tab = vim.api.nvim_win_get_tabpage(0)
  local current_win = vim.api.nvim_get_current_win()

  client.call(messages, function(output)
    -- Restore the current tab and window.
    vim.api.nvim_set_current_tabpage(current_tab)
    vim.api.nvim_set_current_win(current_win)

    -- Open the result in a new vertical buffer.
    vim.cmd("vnew")
    vim.fn.SaveToTempWithTimestamp("~/workbench/chatgpt/", "md")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(question, "\n"))
    vim.api.nvim_buf_set_lines(0, -1, -1, false, vim.split(SEPARATOR, "\n"))
    vim.api.nvim_buf_set_lines(0, -1, -1, false, vim.split(output, "\n"))
    vim.api.nvim_buf_set_lines(0, -1, -1, false, vim.split(SEPARATOR, "\n"))
  end)
end

-- For ChatGPT conversation.
-- Each dialogue is separated by a line of "---".
function ChatGPT()
  if vim.bo.filetype ~= 'markdown' then
    print('This is not a markdown file.')
    return
  end

  local text = table.concat(vim.fn.getline(1, '$'), "\n")

  local MAX_LENGTH = 4096 * 4
  if text == '' or #text > MAX_LENGTH then
    print('The text is empty or longer than ' .. MAX_LENGTH .. ' characters.')
    return
  end

  local messages = client.build_messages(text, SEPARATOR)

  local buf = vim.api.nvim_get_current_buf()
  local line_count = vim.api.nvim_buf_line_count(buf)

  client.call(messages, function(output)
    -- First append separators before and after the output.
    vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, vim.split(SEPARATOR, "\n"))
    vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, vim.split(output, "\n"))
    vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, vim.split(SEPARATOR, "\n"))
  end)
end

-- ChatGPT API
vim.keymap.set('n', '<leader>cc', ':lua ChatGPT()<CR>', {noremap = true, silent = true})
vim.keymap.set('x', '<leader>ci', ':lua ChatGPTImproveEnglish()<CR>', {noremap = true, silent = true})
vim.keymap.set('x', '<leader>ca', ':lua ChatGPTAsk()<CR>', {noremap = true, silent = true})
