"
" Utility functions
"
function! StartsWith(str, prefix)
  return stridx(a:str, a:prefix) == a:prefix
endfunction

function! SubstituteLine(pat, sub, flags)
  call setline('.', substitute(getline('.'), a:pat, a:sub, ''))
endfunction

function! CreateDirIfNotExist(target_path)
  if !isdirectory(a:target_path)
    call mkdir(a:target_path, "p", 0700)
  endif
endfunction
