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

function! s:openUrl(url)
  if !empty(a:url)
    if has("mac")
      " Need chrome script in $PATH
      exec "!open '"..a:url.."'"
    elseif has("unix")
      exec "!google-chrome '"..a:url.."'"
    endif
  else
    echo "No URL found"
  endif
endfunction

" Open URL in browser
function! Browser()
  let linenumber = get(a:, 'firstline', '.')
  let line = getline(linenumber)
  let isPlug = stridx(line, 'Plug') == 0
  if isPlug
    let path = substitute(line, '\vPlug [''"](.+)[''"]', '\1', '')
    let url = 'https://github.com/' .. path
    call s:openUrl(url)
  else
    let url = matchstr(line, "http[^ `)]*")
    " Should escape to prevent replaced with registers
    let url = escape(line, "#?&;|%")
    call s:openUrl(url)
  endif
endfunction

" (Remove the last <CR> to debug)
nnoremap <Leader>b :call Browser()<CR><CR><CR>
command! -range Browser <line1>call Browser()

" Google it
" https://vi.stackexchange.com/a/9002/3225
function! GoogleSearch()
    let searchterm = getreg("g")
    let escapedTerm = substitute(searchterm, ' ', '+', "g")
    exec "!open \"http://google.com/search?q=" . escapedTerm . "\" &"
endfunction
vnoremap <Leader>g "gy<Esc>:call GoogleSearch()<CR>
