--[[

 Non-blocking ChatGPT API clients

 Refer to https://platform.openai.com/docs/api-reference/chat

]]--

local M = {}
local Job = require('plenary.job')

local function gpt_curl(file, url, callback)

  Job:new({
    command = 'curl',
    args = {
      '-s', '-X', 'POST',
      '--data', '@' .. file,
      '-H', 'Content-Type: application/json',
      '-H', 'Authorization: Bearer ' .. vim.env.OPENAI_API_KEY,
      url
    },
    on_exit = function(j, return_code)
      vim.schedule(function()
        if return_code ~= 0 then
          print('Error: curl failed. Error code: ' .. return_code)
          return
        end

        local result = j:result()
        local decoded_result = vim.fn.json_decode(table.concat(result, "\n"))
        callback(decoded_result)
      end)
    end,
  }):start()
end

--
-- Build ChatGPT messages from the text with separators.
--
function M.build_messages(text, separator)
  local sections = vim.fn.split(text, separator)

  local messages = {}
  -- The first message is from user and the second is from the assistant.
  -- The third is from the user and so on.
  for i = 1, #sections do
    local role
    if i % 2 == 1 then
      role = 'user'
    else
      role = 'assistant'
    end
    table.insert(messages, {role = role, content = sections[i]})
  end

  return messages
end

function M.call(messages, callback)
  print(' == Asking ChatGPT.. ==')

  local data = {
    model = 'gpt-4',
    messages = messages,
  }
  local url = "https://api.openai.com/v1/chat/completions"

  local file = vim.fn.tempname()
  vim.fn.writefile({vim.fn.json_encode(data)}, file)

  gpt_curl(file, url, function(body)
    -- Append the whole request and response when there was an error.
    local output
    if body['error'] then
      output = vim.fn.json_encode(body)
    else
      output = body.choices[1].message.content
    end

    callback(output)
  end)
end

return M
