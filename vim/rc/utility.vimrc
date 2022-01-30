"
" Utility functions
"
function! StartsWith(str, prefix)
  return a:prefix != '' && stridx(a:str, a:prefix) == 0
endfunction

function! Contains(str, sub)
  return a:sub != '' && stridx(a:str, a:sub) >= 0
endfunction

function! SubstituteLine(pat, sub, flags)
  call setline('.', substitute(getline('.'), a:pat, a:sub, ''))
endfunction

function! CreateDirIfNotExist(target_path)
  if !isdirectory(a:target_path)
    call mkdir(a:target_path, "p", 0700)
  endif
endfunction

function! FocusableWinCount()
  let count = 0
  for w in range(1, winnr('$'))
    if nvim_win_get_config(win_getid(w)).focusable
      let count += 1
    endif
  endfo

  return count
endfunction
