
"
" Status line
"

function! CurrentDir()
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

function! UnpushedUnpulledCounts()
  let res = UnpushedCount() .. UnpulledCount()
  if res == ''
    return ''
  else
    return '[' .. res .. ']'
  endif
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

" This doesn't update the values often enough, for example, after a commit.
" Updating this causes a lag, about 300ms, so it's not easy to find a good
" idea to update it often.
" Need to find a good way to update it without making lags.
autocmd BufEnter * call ClearPushedCount() | call ClearPulledCount()

function! s:statusline_expr()
  let branch = "%{exists('*gitbranch#name') ? gitbranch#name() : ''}"
  let ro  = "%{&readonly ? 'RO ' : ''}"
  let ft  = "%{len(&filetype) ? &filetype . ' ' : ''}"

  " This slows down startup time (around 300ms).
  let pushpull = "%{UnpushedUnpulledCounts()}"
  let signify = "%{sy#repo#get_stats_decorated()}"

  let spl = "%{&spell ? 'S ' : ' '}"
  let coc = " %{&runtimepath =~ 'coc.nvim' ? coc#status() : ''}"

  let sep = ' %= '
  let pos = ' %c'

  return ' [%{CurrentDir()}] %f ' .. ft .. ro .. spl .. coc ..
        \ sep ..
        \ branch .. ' ' .. pushpull .. signify ..
        \ pos .. ' '
endfunction

let &statusline = s:statusline_expr()
