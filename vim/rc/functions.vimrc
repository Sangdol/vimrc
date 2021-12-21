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

" Open URL in browser
function! Browser()
	let line = getline(".")
	let line = matchstr(line, "http[^ `)]*")
	" Should escape to prevent replaced with registers
	let line = escape(line, "#?&;|%")
	if !empty(line)
		if has("mac")
      " Need chrome script in $PATH
			exec "!open '"..line.."'"
		elseif has("unix")
			exec "!google-chrome '"..line.."'"
		endif
	else
		echo "No URL found"
	endif
endfunction

" (Remove the last <CR> to debug)
nnoremap <Leader>b :call Browser()<CR><CR><CR>

" Google it
" https://vi.stackexchange.com/a/9002/3225
function! GoogleSearch()
    let searchterm = getreg("g")
    let escapedTerm = substitute(searchterm, ' ', '+', "g")
    exec "!open \"http://google.com/search?q=" . escapedTerm . "\" &"
endfunction
vnoremap <Leader>g "gy<Esc>:call GoogleSearch()<CR>
