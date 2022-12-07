"
" Status line
"

function! CurrentDir()
  return fnamemodify(getcwd(), ':t')
endfunction

func! NvimGps() abort
	return luaeval("require'nvim-gps'.is_available()") ?
		\ '[' .. luaeval("require'nvim-gps'.get_location()") .. ']' : ''
endf

" Timer-based update
lua require('git-branch-status')
func! GBStatus() abort
  return luaeval("Gstatus:statusbar()") 
endf

function! s:statusline_expr()
  let branch = "%{exists('*gitbranch#name') ? gitbranch#name() : ''}"
  let ro  = "%{&readonly ? 'RO ' : ''}"
  let ft  = "%{len(&filetype) ? &filetype . ' ' : ''}"

  " This slows down startup time (around 300ms).
  let pushpull = "%{GBStatus()}"
  let signify = "%{sy#repo#get_stats_decorated()}"

  let spl = "%{&spell ? 'S ' : ' '}"
  let coc = " %{&runtimepath =~ 'coc.nvim' ? coc#status() : ''}"

  let sep = ' %= '
  let pos = ' %c'
  let gps = '%{NvimGps()}'

  return ' [%{CurrentDir()}] %f ' .. ft .. ro .. spl .. coc .. '  ' .. gps ..
        \ sep ..
        \ branch .. ' ' .. pushpull .. ' ' .. signify ..
        \ pos .. ' '
endfunction

let &statusline = s:statusline_expr()
