--[[

 Non-blocking ChatGPT API clients

 Refer to https://platform.openai.com/docs/api-reference/chat

]]--

local M = {}
local Job = require('plenary.job')

function M.gpt_curl(file, url, callback)
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

        callback(table.concat(j:result(), "\n"))
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

return M
