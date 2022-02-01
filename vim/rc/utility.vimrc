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

function! Zip(as, bs)
  let i = 0
  let res = []
  for a in a:as
    let res += [[a, a:bs[i]]]
    let i += 1
  endfor

  return res
endfunction

function! ZipMap(as, bs)
  let left = a:as
  let right = a:bs

  if type(left) == type('')
    let left = StringToArray(left)
  endif

  if type(right) == type('')
    let right = StringToArray(right)
  endif

  if type(left) != type([]) 
    throw string(left) .. 'is not an array.'
  endif

  if type(right) != type([])
    throw string(right) .. 'is not an array.'
  endif

  let d = {}
  for [a, b] in Zip(left, right)
    let d[a] = b
  endfor

  return d
endfunction

function! StringToArray(str)
  return split(a:str, '\zs')
endfunction
