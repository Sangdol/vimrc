"
" Utility functions
"
function! StartsWith(str, prefix)
  return stridx(a:str, a:prefix) == a:prefix
endfunction
