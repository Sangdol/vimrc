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

" https://vim.fandom.com/wiki/Delete_files_with_a_Vim_command#Comments
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

function! s:open_url(url)
  echom 'Opening "' .. a:url .. '"'
  if !empty(a:url)
    if has("mac")
      exec "!open '"..a:url.."'"
    elseif has("unix")
      exec "!google-chrome '"..a:url.."'"
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

" (Remove the last <CR> to debug)
nnoremap <Leader>b :call <SID>browser()<CR><CR>

" Google it
" https://www.reddit.com/r/vim/comments/ebaoku/function_to_google_any_text_object/
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
  exec '!open "http://google.com/search?q=' . search . '" &'

  let &selection = sel_save
  let @@ = reg_save
endfunction

nmap <silent> ga :set opfunc=GoogleText<CR>g@
vmap <silent> ga :<C-u>call GoogleText(visualmode(), 1)<Cr>

" Save with a timestamp
function! s:save_to_temp_with_timestamp(path, ext) abort
  let timestamp = strftime("%Y-%m-%d_%H%M%S")
  let filename = 'vim_' .. timestamp .. '.' .. a:ext
  let target_path = expand(a:path)

  call CreateDirIfNotExist(target_path)

  if empty(bufname())
    exe 'w ' .. target_path .. filename
  else
    echo 'This file already has a filename.'
  endif
endfunction

noremap <Leader>wtm :call <SID>save_to_temp_with_timestamp('~/workbench/vim-notes/', 'md')<CR>
noremap <Leader>wtp :call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'py')<CR>
noremap <Leader>wtj :call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'js')<CR>
noremap <Leader>wts :call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'sh')<CR>
noremap <Leader>wtl :call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'lua')<CR>
noremap <Leader>wtv :call <SID>save_to_temp_with_timestamp('~/workbench/code/', 'vim')<CR>

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

" GPT-3 playground
" It only works for a file with a `gpt3` extension to avoid accidental use.
function! Ask() abort
  if expand('%:e') != 'gpt3'
    echoerr 'This is not a gpt3 file.'
    return
  endif

  let text = join(getline(1, '$'), "\n")

  if empty(text) || len(text) > 2048
    echoerr 'The text is empty or longer than 2048 characters.'
    return
  endif

  echom 'Asking GPT-3 for "' .. text .. '"'

  let data = {
        \ 'prompt': text,
        \ 'max_tokens': 100,
        \ 'temperature': 0,
        \ 'model': 'text-davinci-003'
        \ }
  let url = "https://api.openai.com/v1/completions"
  let headers =
        \' -H "Content-Type: application/json"' ..
        \' -H "Authorization: Bearer ' .. $OPENAI_API_KEY .. '"'

  let file = tempname()
  call writefile([json_encode(data)], file)

  echom 'File is saved to ' .. file

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

nnoremap <leader>eg :call Ask()<CR>
noremap <Leader>wtg :call <SID>save_to_temp_with_timestamp('~/workbench/gpt3/', 'gpt')<CR>

" Show the current syntax group
" https://stackoverflow.com/a/9464929/524588
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

command! -nargs=0 SynStack call SynStack()
