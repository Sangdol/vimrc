"
" Auto Commands
"

" Automatically cd into the directory that the file is in
" https://github.com/tpope/vim-fugitive/issues/3
autocm BufEnter * if expand('%:p') !~ '://' | :lchdir %:p:h | endif

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" Improve syntax highlighting
autocmd BufRead,BufNewFile *.md set filetype=markdown

" for html close tag shortcut
autocmd FileType html set omnifunc=xmlcomplete#CompleteTags

