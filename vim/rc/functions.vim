"
" Functions and commands
"

" From https://vim.fandom.com/wiki/Append_output_of_an_external_command
" which is way better than the one from
" https://unix.stackexchange.com/questions/8101/how-to-insert-the-result-of-a-command-into-the-text-in-vim/8296#8296
"
" Usage:
"   :Tab ls
"   :Tab echo g:
function! Tab(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction

command! -nargs=+ -complete=command Tab call Tab(<q-args>)

" message in new tab
nnoremap <Leader>et :Tab mes<CR>
" last command in new tab
nnoremap <Leader>el :Tab <C-R>:<CR>

"
" From https://vim.fandom.com/wiki/Delete_files_with_a_Vim_command#Comments
"
function! DeleteFile(...)
  if(exists('a:1'))
    let theFile=a:1
  elseif ( &ft == 'help' )
    echohl Error
    echo "Cannot delete a help buffer!"
    echohl None
    return -1
  else
    let theFile=expand('%:p')
  endif
  let delStatus=delete(theFile)
  if(delStatus == 0)
    echo "Deleted " . theFile
  else
    echohl WarningMsg
    echo "Failed to delete " . theFile
    echohl None
  endif
  return delStatus
endfunction
"delete the current file
com! Rm call DeleteFile()
"delete the file and quit the buffer (quits vim if this was the last file)
com! RM call DeleteFile() <Bar> q!

"
" Custom gx replacement
"
function! s:open_url(url)
  echom 'Opening "' .. a:url .. '"'
  if !empty(a:url)
    if has("mac")
      silent exec "!open '"..a:url.."'"
    elseif has("unix")
      silent exec "!google-chrome '"..a:url.."'"
    endif
  else
    echom "No URL found"
  endif
endfunction

" Open URL in browser
function! s:browser()
  let line = getline('.')
  let line = trim(line)
  let is_plug = StartsWith(line, 'Plug')
  if is_plug
    let path = substitute(line, '\vPlug [''"](.{-})[''"].*', '\1', '')
    let url = 'https://github.com/' .. path
    call s:open_url(url)
  else
    let line = matchstr(line, "http[^ `)]*")
    " Should escape to prevent replaced with registers. Refer to :h c_#, c_%
    " Why escaping ; and |?
    let url = escape(line, "#;|%")
    call s:open_url(url)
  endif
endfunction

nnoremap <Leader>b :call <SID>browser()<CR>

"
" Google it
" https://www.reddit.com/r/vim/comments/ebaoku/function_to_google_any_text_object/
"
function! GoogleText(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@

  if a:0  " Invoked from Visual mode, use '< and '> marks.
    silent exe "normal! `<" . a:type . "`>y"
  elseif a:type == 'line'
    silent exe "normal! '[V']y"
  elseif a:type == 'block'
    silent exe "normal! `[\<C-V>`]y"
  else
    silent exe "normal! `[v`]y"
  endif

  let search = substitute(trim(@@), ' \+', '+', 'g')
  let @+ = search
  silent exec '!open "http://google.com/search?q=' . search . '" &'

  let &selection = sel_save
  let @@ = reg_save
endfunction

nmap <silent> ga :set opfunc=GoogleText<CR>g@
vmap <silent> ga :<C-u>call GoogleText(visualmode(), 1)<Cr>

"
" Save with a timestamp
"
function! s:save_to_temp_with_timestamp(...) abort
  let path = a:1
  let ext = a:2
  let suffix = get(a:, 3, '')

  let timestamp = strftime("%Y%m%d_%H%M%S")
  let filename = timestamp .. '.' .. ext

  if !empty(suffix)
    let filename = timestamp .. '_' .. suffix .. '.' .. ext
  endif

  let target_path = expand(path)

  call CreateDirIfNotExist(target_path)

  if empty(bufname())
    exe 'w ' .. target_path .. filename
  else
    echo 'This file already has a filename.'
  endif
endfunction

nnoremap <Leader>wtg :call <SID>save_to_temp_with_timestamp('~/workbench/gpt3/', 'md')<CR>
nnoremap <Leader>wtx :call <SID>save_to_temp_with_timestamp('~/workbench/vim-notes/', 'txt')<CR>
nnoremap <Leader>wtm :call <SID>save_to_temp_with_timestamp('~/workbench/vim-notes/', 'md')<CR>
nnoremap <Leader>wtp :call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'py')<CR>
nnoremap <Leader>wtj :call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'js')<CR>
nnoremap <Leader>wtt :call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'ts')<CR>
nnoremap <Leader>wtb :call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'sh')<CR>
nnoremap <Leader>wtf :call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'fish')<CR>
nnoremap <Leader>wtl :call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'lua')<CR>
nnoremap <Leader>wtv :call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'vim')<CR>
nnoremap <Leader>wth :call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'html')<CR>
nnoremap <Leader>wto :call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'js', 'mongo')<CR>

nnoremap <Leader>wog :tabnew<CR>:call <SID>save_to_temp_with_timestamp('~/workbench/gpt3/', 'md')<CR>
nnoremap <Leader>wox :tabnew<CR>:call <SID>save_to_temp_with_timestamp('~/workbench/vim-notes/', 'txt')<CR>
nnoremap <Leader>wom :tabnew<CR>:call <SID>save_to_temp_with_timestamp('~/workbench/vim-notes/', 'md')<CR>
nnoremap <Leader>wop :tabnew<CR>:call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'py')<CR>
nnoremap <Leader>woj :tabnew<CR>:call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'js')<CR>
nnoremap <Leader>wot :tabnew<CR>:call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'ts')<CR>
nnoremap <Leader>wob :tabnew<CR>:call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'sh')<CR>
nnoremap <Leader>wof :tabnew<CR>:call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'fish')<CR>
nnoremap <Leader>wol :tabnew<CR>:call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'lua')<CR>
nnoremap <Leader>wov :tabnew<CR>:call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'vim')<CR>
nnoremap <Leader>woh :tabnew<CR>:call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'html')<CR>
nnoremap <Leader>woo :tabnew<CR>:call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'js', 'mongo')<CR>

"
" Translate the keyboard middle line characters to numbers
" since numbers are too far from fingers.
"
" alphanumeric_line_number examples
" - 10
" - 10,20
" - aa    " => 11
" - aa,af " => 11,14
function! s:translate_linenumber(alphanumeric_line_number)
  if a:alphanumeric_line_number !~ '\d'
    let d = ZipMap('-+asdfghjkl;,', '-+1234567890,')
    let chars = StringToArray(a:alphanumeric_line_number)
    let line_number = join(map(chars, {idx, val -> d[val]}), '')

    return line_number
  else
    return a:alphanumeric_line_number
  endif
endfunction

" Copy nth line to the current line
function! s:copy_line_of(alphanumeric_line_number)
  let line_number = s:translate_linenumber(a:alphanumeric_line_number)
  exec line_number .. 't.'
endfunction

command! -nargs=1 C call <SID>copy_line_of(<q-args>)

" Delete line without jumping cursor
function! s:delete_line_of(alphanumeric_line_number)
  let line_number = s:translate_linenumber(a:alphanumeric_line_number)
  exec line_number .. 'd'
  exec "normal \<C-o>"
endfunction

command! -nargs=1 D call <SID>delete_line_of(<q-args>)

" Run macros over selected lines
" https://github.com/stoeffel/.dotfiles/blob/master/vim/visual-at.vim
xnoremap @ :<C-u>call <SID>execute_macro_over_visual_range()<CR>

function! s:execute_macro_over_visual_range()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

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

"
" Show the current syntax group
" https://stackoverflow.com/a/9464929/524588
"
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

command! -nargs=0 SynStack call SynStack()
