"
" Functions
"

" Insert the output of a vim command
" how to: (insert mode) ^R=Exec('ls')
" https://unix.stackexchange.com/a/8296/8610
funct! Exec(command)
    redir =>output
    silent exec a:command
    redir END
    return output
endfunct!

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
