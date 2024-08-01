--[[

  ChatGPT client config

]]--

local client = require('chatgpt-client')
local SEPARATOR = '\n---\n'
local RAW_RESPONSE_DIR = vim.fn.expand('~/.sang_storage/gpt/raw/')

--
-- Log the raw response from ChatGPT API.
--
-- @param filename filename without directory and extension
-- @param message_count number of messages
-- @param body response body
--
local function log_raw_response(filename, message_count, body)
  if body == nil then
    print('Cannot create a log file: The body is empty.')
    return
  end

  local prefix = vim.fn.expand(RAW_RESPONSE_DIR)

  -- Create the directory if it does not exist.
  vim.fn.mkdir(prefix, 'p')

  local fullpath = prefix .. filename .. '_' .. message_count .. '.json'
  local file = io.open(fullpath, 'w')

  if file == nil then
    print('Cannot create a log file: ' .. fullpath)
    return
  end

  file:write(body)
  file:close()
end

--
-- Main function for calling ChatGPT API.
--
function ChatGPTCall(messages, callback)
  -- Current filename without directory and extension
  local current_filename = vim.fn.expand('%:t:r')

  local data = {
    model = 'gpt-4o',
    messages = messages,
  }
  local url = "https://api.openai.com/v1/chat/completions"

  local file = vim.fn.tempname()
  vim.fn.writefile({vim.fn.json_encode(data)}, file)

  client.gpt_curl(file, url, function(res)
    local body = vim.fn.json_decode(res)
    local output
    if body['error'] then
      -- Append the whole request and response when there was an error.
      output = res
    else
      output = body.choices[1].message.content
    end

    callback(output)
    log_raw_response(current_filename, #messages, res)
  end)

  print(' == Asking ChatGPT using model ' .. data.model .. ' == ')
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

  ChatGPTCall(messages, function(output)
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

  ChatGPTCall(messages, function(output)
    -- First append separators before and after the output.
    vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, vim.split(SEPARATOR, "\n"))
    vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, vim.split(output, "\n"))
    vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, vim.split(SEPARATOR, "\n"))
  end)
end

vim.keymap.set('n', '<leader>cc', ':lua ChatGPT()<CR>', {noremap = true, silent = true})
vim.keymap.set('x', '<leader>ca', ':lua ChatGPTAsk()<CR>', {noremap = true, silent = true})
