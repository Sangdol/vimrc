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
  autocmd TermOpen * startinsert | setlocal nonumber

  " For moving application windows across screens
  autocmd VimResized * wincmd =

  " For Voom, NERDTree, etc.
  autocmd VimEnter * wincmd l

  " Spell check
  autocmd FileType gitcommit setlocal spell

augroup END
