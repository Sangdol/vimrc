--
-- Call ChatGPT API.
-- https://platform.openai.com/docs/api-reference/chat
--
function GPTCurl(file, url)
  local headers =
        ' -H "Content-Type: application/json"' ..
        ' -H "Authorization: Bearer ' .. vim.env.OPENAI_API_KEY .. '"'
  local res = vim.fn.system('curl -s -X POST ' .. headers .. ' --data @' .. file .. ' --max-time 20 ' .. url)
  return vim.fn.json_decode(res)
end

function CallChatGPT(messages)
  print(' == Asking ChatGPT.. ==')

  local data = {
    model = 'gpt-4',
    messages = messages,
  }
  local url = "https://api.openai.com/v1/chat/completions"

  local file = vim.fn.tempname()
  vim.fn.writefile({vim.fn.json_encode(data)}, file)

  local body = GPTCurl(file, url)

  -- Append the whole request and response when there was an error.
  local output
  if body['error'] then
    output = vim.fn.json_encode(body)
  else
    output = body.choices[1].message.content
  end

  return output
end

--
-- Build ChatGPT messages from the text with separators.
--
function BuildMessages(text, separator)
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
