"
" Auto Commands
"

augroup custom
  autocmd!

  " Remove any trailing whitespace that is in the file
  autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

  " for html close tag shortcut
  autocmd FileType html set omnifunc=xmlcomplete#CompleteTags

  " Moves the cursor to the last position
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Json supports comments
  " https://github.com/neoclide/coc.nvim/wiki/Using-the-configuration-file
  autocmd FileType json syntax match Comment +\/\/.\+$+

  " Terminal
  autocmd TermOpen * startinsert
  autocmd TermOpen * setlocal nonumber norelativenumber

  " For moving windows across screens
  autocmd VimResized * wincmd =

  " For Voom, NERDTree, etc.
  autocmd VimEnter * wincmd l

  " Spell check
  autocmd FileType gitcommit setlocal spell

augroup END

" Autosave
augroup autosave
  autocmd!
  autocmd TextChanged,InsertLeave *
        \  if get(g:, 'autosave_enabled', 1) &&
        \     empty(&buftype) && !empty(bufname(''))
        \|   update
        \| endif
augroup END

function! ToggleAutosave()
  let g:autosave_enabled = !get(g:, 'autosave_enabled', 1)
endfunction

nnoremap <leader>wa :call ToggleAutosave()<CR>
