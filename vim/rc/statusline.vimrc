
"
" Status line
"

function CurrentDir()
  return fnamemodify(getcwd(), ':t')
endfunction

" ⇡
function! UnpushedCount() abort
  if !has_key(b:, 'unpushed_count')
    let b:unpushed_count = trim(system("git rev-list --left-only --count 'HEAD...@{upstream}'"))
  endif

  if b:unpushed_count > 0
    return '⇡' .. b:unpushed_count
  endif

  return ''
endfunction

" ⇣
function! UnpulledCount() abort
  if !has_key(b:, 'unpulled_count')
    let b:unpulled_count = trim(system("git rev-list --right-only --count 'HEAD...@{upstream}'"))
  endif

  if b:unpulled_count > 0
    return '⇣' .. b:unpulled_count
  endif

  return ''
endfunction

function! ClearPushedCount()
  if has_key(b:, 'unpushed_count')
    unlet b:unpushed_count
  endif
endfunction

function! ClearPulledCount()
  if has_key(b:, 'unpulled_count')
    unlet b:unpulled_count
  endif
endfunction

autocmd BufEnter * call ClearPushedCount() | call ClearPulledCount()

function! s:statusline_expr()
  let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? '[RO] ' : ''}"
  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? FugitiveStatusline() : ''}"
  let sy = "%{sy#repo#get_stats_decorated()}"

  let coc = " %{coc#status()}"

  " This slows down startup time (around 300ms).
  let git = "[%{UnpushedCount()}%{UnpulledCount()}]"

  let sep = ' %= '
  let pos = ' %c'
  let dir = ' [%{CurrentDir()}] '

  return ' %f %<'.mod.ro.ft.fug.git.sy.coc.sep.pos.'%*'.dir
endfunction
let &statusline = s:statusline_expr()

" Change cursor shape in different modes(In OSX)
" http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

