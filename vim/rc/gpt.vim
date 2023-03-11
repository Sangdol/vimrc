"
" GPT-3 playground
"
function! GptComplete() abort
  if expand('%:e') != 'md'
    echoerr 'This is not a markdown file.'
    return
  endif

  let text = join(getline(1, '$'), "\n")

  let MAX_LENGTH = 4096
  if empty(text) || len(text) > MAX_LENGTH
    echoerr 'The text is empty or longer than ' . MAX_LENGTH . ' characters.'
    return
  endif

  echom 'Asking GPT-3 for "' .. text .. '"'

  let data = {
        \ 'prompt': text,
        \ 'max_tokens': 1000,
        \ 'temperature': 0,
        \ 'model': 'text-davinci-003'
        \ }
  let url = "https://api.openai.com/v1/completions"
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
    let output = body.choices[0].text
  endif

  call append(line('$'), split(output, "\n"))
endfunction

nnoremap <leader>eg :call GptComplete()<CR>

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

function! ChatGPT() abort
  if expand('%:e') != 'md'
    echoerr 'This is not a markdown file.'
    return
  endif

  let text = join(getline(1, '$'), "\n")

  let MAX_LENGTH = 4096 * 4
  if empty(text) || len(text) > MAX_LENGTH
    echoerr 'The text is empty or longer than ' . MAX_LENGTH . ' characters.'
    return
  endif

  let separator = "\n---\n"
  let messages = BuildMessages(text, separator)

  let output = CallChatGPT(messages)

  " First append separators before and after the output.
  call append(line('$'), '')
  call append(line('$'), split(separator, "\n"))
  call append(line('$'), '')
  call append(line('$'), split(output, "\n"))
  call append(line('$'), '')
  call append(line('$'), split(separator, "\n"))
  call append(line('$'), '')
endfunction

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

nnoremap <leader>eg :call GptComplete()<CR>
nnoremap <leader>ep :call ChatGPT()<CR>
