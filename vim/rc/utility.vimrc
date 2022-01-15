"
" Utility functions
"
function! StartsWith(str, prefix)
  return stridx(a:str, a:prefix) == a:prefix
endfunction

function! SubstituteLine(pat, sub, flags)
  call setline('.', substitute(getline('.'), a:pat, a:sub, ''))
endfunction
