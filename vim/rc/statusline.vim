"
" Status line
"

function! CurrentDir()
  return fnamemodify(getcwd(), ':t')
endfunction

let s:nvim_gps_installed = v:null
func! NvimGps() abort
  if s:nvim_gps_installed == v:null
    let s:nvim_gps_installed = luaeval('pcall(require, "nvim-gps")')
  endif

  if !s:nvim_gps_installed
    return ''
  endif

	return luaeval("require'nvim-gps'.is_available()") ?
		\  luaeval("require'nvim-gps'.get_location()") : ''
endf

" Timer-based update
lua require('git-branch-status-timer')
func! GBStatus() abort
  return luaeval("Gstatus:statusbar()") 
endf

function! StatuslineExpr()
	let focused = g:statusline_winid == win_getid(winnr())
  let dir = focused ?
        \ "%#DirColor#%{CurrentDir()}%#StatusLine#" : "%#DirColorNC#%{CurrentDir()}%#StatusLineNC#"
  let filename = ' %f '
  let branch = "%{exists('*gitbranch#name') ? gitbranch#name() : ''}"
  let ro  = "%{&readonly ? 'RO ' : ''}"
  let ft  = "%{len(&filetype) ? &filetype . ' ' : ''}"

  " This slows down startup time (around 300ms).
  let pushpull = focused ? "%#GBStatusColor#%{GBStatus()}%#StatusLine#" : ""
  let signify = "%{sy#repo#get_stats_decorated()}"

  let spl = "%{&spell ? 'S ' : ' '}"
  let coc = " %{&runtimepath =~ 'coc.nvim' ? coc#status() : ''}"

  let sep = ' %= '
  let truncateline = ' %< '
  let pos = ' %c'
  " Put NvimGpsColor 
  let gps = focused ? 
        \ "%#NvimGpsColor#%{NvimGps()}%#StatusLine#" : "%#NvimGpsColorNC#%{NvimGps()}%#StatusLineNC#"

  return ' ' .. dir .. filename .. ft .. ro .. spl .. gps ..
        \ coc .. 
        \ truncateline ..
        \ sep .. 
        \ branch .. ' ' .. pushpull .. ' ' .. signify ..
        \ pos .. ' '
endfunction

"let &statusline = s:statusline_expr()
set statusline=%!StatuslineExpr()
