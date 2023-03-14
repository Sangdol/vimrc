"
" Call ChatGPT API.
" https://platform.openai.com/docs/api-reference/chat
"
function! CallChatGPT(messages) abort
  echom 'Asking ChatGPT...'

  let messages = a:messages
  let data = {
        \ 'model': 'gpt-3.5-turbo',
        \ 'messages': messages,
        \ }
  let url = "https://api.openai.com/v1/chat/completions"
  let headers =
        \' -H "Content-Type: application/json"' ..
        \' -H "Authorization: Bearer ' .. $OPENAI_API_KEY .. '"'

  let file = tempname()
  call writefile([json_encode(data)], file)

  let res = system('curl -s -X POST ' .. headers .. ' --data @' .. file .. ' ' .. url)
  let body = json_decode(res)

  " Append the whole request and response when there was an error.
  if has_key(body, 'error')
    let output = res
  else
    let output = body.choices[0].message.content
  endif

  return output
endfunction

"
" Build ChatGPT messages from the text with separators.
"
function! BuildMessages(text, separator) abort
  let sections = split(a:text, a:separator)

  let messages = []
  " The first message is from user and the second is from the assistant.
  " The third is from the user and so on.
  for i in range(0, len(sections) - 1)
    if i % 2 == 0
      let role = 'user'
    else
      let role = 'assistant'
    endif
    let messages += [{'role': role, 'content': sections[i]}]
  endfor

  return messages
endfunction

"
" Call GPT Editing API.
" https://platform.openai.com/docs/api-reference/edits
"
function! CallGPTEditing(input, instruction, is_code)
  echom 'Asking GPT-3 for Editing'

  let input = a:input
  let instruction = a:instruction
  let model = a:is_code ? 'code-davinci-edit-001' : 'text-davinci-edit-001'
  let data = {
        \ 'model': model,
        \ 'temperature': 0,
        \ 'input': input,
        \ 'instruction': instruction,
        \ }
  let url = "https://api.openai.com/v1/edits"
  let headers =
        \' -H "Content-Type: application/json"' ..
        \' -H "Authorization: Bearer ' .. $OPENAI_API_KEY .. '"'

  let file = tempname()
  call writefile([json_encode(data)], file)

  let res = system('curl -s -X POST ' .. headers .. ' --data @' .. file .. ' ' .. url)
  let body = json_decode(res)
  if has_key(body, 'error')
    let output = res
  else
    let output = body.choices[0].text
  endif

  return output
endfunction


