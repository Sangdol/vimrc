local separator = '\n---\n'

function GptComplete()
  if vim.fn.expand('%:e') ~= 'md' then
    vim.api.nvim_err_writeln('This is not a markdown file.')
    return
  end

  local text = table.concat(vim.fn.getline(1, '$'), '\n')

  local MAX_LENGTH = 4096
  if text == '' or #text > MAX_LENGTH then
    vim.api.nvim_err_writeln('The text is empty or longer than ' .. MAX_LENGTH .. ' characters.')
    return
  end

  vim.api.nvim_echo({ { 'Asking GPT-3 for "' .. text .. '"' } }, true, {})

  local data = {
        prompt = text,
        max_tokens = 1000,
        temperature = 0,
        model = 'text-davinci-003'
      }
  local url = "https://api.openai.com/v1/completions"
  local headers =
        ' -H "Content-Type: application/json"' ..
        ' -H "Authorization: Bearer ' .. vim.env.OPENAI_API_KEY .. '"'

  local file = vim.fn.tempname()
  vim.fn.writefile({vim.fn.json_encode(data)}, file)

  local res = vim.fn.system('curl -s -X POST ' .. headers .. ' --data @' .. file .. ' ' .. url)
  local body = vim.fn.json_decode(res)

  -- Append the whole request and response when there was an error.
  local output
  if vim.fn.has_key(body, 'error') then
    output = res
  else
    output = body.choices[1].text
  end

  vim.fn.append(vim.fn.line('$'), vim.fn.split(output, "\n"))
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

  local messages = BuildMessages(text, separator)

  local output = CallChatGPT(messages)

  -- First append separators before and after the output.
  vim.fn.append('$', '')
  vim.fn.append('$', vim.split(separator, "\n"))
  vim.fn.append('$', '')
  vim.fn.append('$', vim.split(output, "\n"))
  vim.fn.append('$', '')
  vim.fn.append('$', vim.split(separator, "\n"))
  vim.fn.append('$', '')
end

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
  local output = CallChatGPT(messages)

  -- Open the result in a new vertical buffer.
  vim.cmd('vnew')
  vim.fn.SaveToTempWithTimestamp('~/workbench/chatgpt/', 'md')
  vim.fn.setline(1, vim.split(output, "\n"))
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

  local output = CallChatGPT(messages)

  -- Open the result in a new vertical buffer.
  vim.cmd("vnew")
  vim.fn.SaveToTempWithTimestamp("~/workbench/chatgpt/", "md")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(question, "\n"))
  vim.api.nvim_buf_set_lines(0, -1, -1, false, {""})
  vim.api.nvim_buf_set_lines(0, -1, -1, false, vim.split(separator, "\n"))
  vim.api.nvim_buf_set_lines(0, -1, -1, false, {""})
  vim.api.nvim_buf_set_lines(0, -1, -1, false, vim.split(output, "\n"))
  vim.api.nvim_buf_set_lines(0, -1, -1, false, {""})
  vim.api.nvim_buf_set_lines(0, -1, -1, false, vim.split(separator, "\n"))
  vim.api.nvim_buf_set_lines(0, -1, -1, false, {""})
end

-- Completion API
vim.api.nvim_set_keymap('n', '<leader>cp', ':lua GptComplete()<CR>', {noremap = true, silent = true})

-- ChatGPT API
vim.api.nvim_set_keymap('n', '<leader>cc', ':lua ChatGPT()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', '<leader>ci', ':lua ChatGPTImproveEnglish()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('x', '<leader>ca', ':lua ChatGPTAsk()<CR>', {noremap = true, silent = true})
