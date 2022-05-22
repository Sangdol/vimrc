"
" Auto Commands
"

augroup custom
  autocmd!

  " Remove any trailing whitespace that is in the file
  autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

  " Moves the cursor to the last position
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Json supports comments
  " https://github.com/neoclide/coc.nvim/wiki/Using-the-configuration-file
  autocmd FileType json syntax match Comment +\/\/.\+$+

  " For moving application windows across screens
  autocmd VimResized * wincmd =

  " For Voom, NERDTree, etc.
  autocmd VimEnter * wincmd l

  " Terminal
  autocmd TermOpen * startinsert

augroup END

" Autosave
augroup autosave
  autocmd!
  autocmd TextChanged,InsertLeave *
        \  if get(g:, 'autosave_enabled', 1) &&
        \     get(b:, 'autosave_enabled', 1) &&
        \     empty(&buftype) && !empty(bufname(''))
        \|   update
        \| endif

  autocmd FileType scala,clojure,python let b:autosave_enabled = 0
  autocmd BufLeave *.scala,*.clj,*.py update
augroup END

function! ToggleAutosave()
  let g:autosave_enabled = !get(g:, 'autosave_enabled', 1)
endfunction

nnoremap <leader>wa :call ToggleAutosave()<CR>
