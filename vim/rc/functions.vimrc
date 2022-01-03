"
" Functions
" TODO scope for variables (is it needed for the variables in functions?)
"

" From https://vim.fandom.com/wiki/Append_output_of_an_external_command
" which is way better than the one from
" https://unix.stackexchange.com/questions/8101/how-to-insert-the-result-of-a-command-into-the-text-in-vim/8296#8296
"
" Usage:
"   :TabMessage ls
"   :TabMessage echo g:
function! TabMessage(cmd)
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

" -complete=command: completion to make the command work with a shorter form
"  such as :Tab
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

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

function! s:openUrl(url)
  echom 'Opening "' .. a:url .. '"'
  if !empty(a:url)
    if has("mac")
      " Need chrome script in $PATH
      exec "!open '"..a:url.."'"
    elseif has("unix")
      exec "!google-chrome '"..a:url.."'"
    endif
  else
    echom "No URL found"
  endif
endfunction

" Open URL in browser
function! Browser()
  let linenumber = get(a:, 'firstline', '.')
  let line = getline(linenumber)
  let line = trim(line)
  let isPlug = StartsWith(line, 'Plug')
  if isPlug
    let path = substitute(line, '\vPlug [''"](.{-})[''"].*', '\1', '')
    let url = 'https://github.com/' .. path
    call s:openUrl(url)
  else
    let line = matchstr(line, "http[^ `)]*")
    " Should escape to prevent replaced with registers
    let url = escape(line, "#?&;|%")
    call s:openUrl(url)
  endif
endfunction

" (Remove the last <CR> to debug)
nnoremap <Leader>b :call Browser()<CR><CR>
command! -range Browser <line1>call Browser()

" Google it
" https://vi.stackexchange.com/a/9002/3225
function! GoogleSearch()
    let searchterm = getreg("g")
    let escapedTerm = substitute(searchterm, ' ', '+', "g")
    let escapedTerm = substitute(escapedTerm, '\n', '+', "g")
    let escapedTerm = substitute(escapedTerm, '*', '', "g")
    exec '!open "http://google.com/search?q=' . escapedTerm . '" &'
endfunction
vnoremap <Leader>g "gy<Esc>:call GoogleSearch()<CR><CR>

" Save to /tmp
function! SaveToTempWithTimestamp()
  let timestamp = strftime("%Y-%m-%d_%H:%M:%S")
  let filename = 'vim_' .. timestamp .. '.md'

  exe 'w ' .. '/tmp/' .. filename
endfunction
noremap <Leader>wt :call SaveToTempWithTimestamp()<CR>
