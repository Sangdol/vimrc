"
" Status line
"

function! CurrentDir()
  return fnamemodify(getcwd(), ':t')
endfunction

" [Git(master)] => master
function! CustomGitBranch()
  if !exists('*FugitiveStatusline')
    return ''
  endif

  let fugitive_status = FugitiveStatusline()
  if fugitive_status == ''
    return ''
  endif
  return matchstr(fugitive_status, '\[Git(\zs[^]]*\ze)]')
endfunction

function! StatuslineExpr()
	let focused = g:statusline_winid == win_getid(winnr())
  let dir = focused ?
        \ "%#DirColor#%{CurrentDir()}%#StatusLine#" : "%#DirColorNC#%{CurrentDir()}%#StatusLineNC#"
  let filename = ' %f '
  let branch = "%{CustomGitBranch()}"
  let ro  = "%{&readonly ? 'RO ' : ''}"
  let ft  = "%{len(&filetype) ? &filetype . ' ' : ''}"
  let signify = "%{sy#repo#get_stats_decorated()}"

  let spl = "%{&spell ? 'S ' : ' '}"
  let coc = " %{&runtimepath =~ 'coc.nvim' ? coc#status() : ''}"

  let sep = ' %= '
  let truncateline = ' %< '
  let pos = ' %c'

  return ' ' .. dir .. filename .. ft .. ro .. spl .. 
        \ coc .. 
        \ truncateline ..
        \ sep .. 
        \ branch .. ' ' .. signify ..
        \ pos .. ' '
endfunction

"let &statusline = s:statusline_expr()
set statusline=%!StatuslineExpr()
