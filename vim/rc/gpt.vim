"
" GPT-3 playground
"

"
" Ask GPT-3 to complete the text.
" https://beta.openai.com/docs/api-reference/completions/create
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
" For ChatGPT conversaion.
" Each dialogue is separated by a line of "---".
"
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

"
" Call ChatGPT API for imporving English of code comments.
"
function! ChatGPTImproveCodeComment() abort range
  let filetype = &filetype
  let prompt = "Fix the grammar or improve the code comment: \n" ..
        \ "```" .. filetype .. "\n" ..
        \ "{placeholder}\n" ..
        \ "```"
  let comment = GetVisualSelection()
  let text = substitute(prompt, '{placeholder}', comment, '')
  let messages = [{'role': 'user', 'content': text}]
  let output = CallChatGPT(messages)

  " Open the result in a new vertical buffer.
  execute 'vnew'
  call SaveToTempWithTimestamp('~/workbench/chatgpt/', 'md')
  call setline(1, split(output, "\n"))
endfunction

"
" Ask ChatGPT with a selected code.
"
function! ChatGPTAskCode() abort range
  let filetype = &filetype
  let text = GetVisualSelection()
  let instruction = input('Ask: ')
  let prompt = instruction .. "\n" ..
        \ "```" .. filetype .. "\n" ..
        \ "{placeholder}\n" ..
        \ "```"
  let code = GetVisualSelection()
  let text = substitute(prompt, '{placeholder}', code, '')
  let messages = [{'role': 'user', 'content': text}]

  " Adding an empty line after instruction.
  echom ''

  let output = CallChatGPT(messages)

  " Open the result in a new vertical buffer.
  execute 'vnew'
  call SaveToTempWithTimestamp('~/workbench/chatgpt/', 'md')
  call setline(1, split(output, "\n"))
endfunction

"
" Get improved code comment from the GPT Editing API
"
function! GPTEditComment() abort range
  let filetype = &filetype
  let instruction = "Fix the grammar or improve the " .. filetype .. " code comment."
  let comment = GetVisualSelection()
  
  let output = CallGPTEditing(comment, instruction, 0)

  " Paste the result below the visual selection.
  call setline('.', split(output, "\n"))
endfunction

"
" Get editing result from the GPT Editing API
"
function! GPTEditCode() abort range
  let extension = expand('%:e')
  let instruction = input('Instruction: ')
  let code = GetVisualSelection()
  
  " Adding an empty line after instruction.
  echom ''

  let output = CallGPTEditing(code, instruction, 1)

  " Open the result in a new vertical buffer.
  execute 'vnew'
  call SaveToTempWithTimestamp('~/workbench/refactoring/', extension)
  call append(line('1'), split(output, "\n"))
endfunction

"
" Completion API
"
nnoremap <leader>cp :call GptComplete()<CR>

"
" ChatGPT API
"
nnoremap <leader>cc :call ChatGPT()<CR>
xnoremap <leader>ci :call ChatGPTImproveCodeComment()<CR>
xnoremap <leader>ca :call ChatGPTAskCode()<CR>

"
" Editing API
"
xnoremap <leader>ce :call GPTEditComment()<CR>
xnoremap <leader>cr :call GPTEditCode()<CR>
