"
" Auto Commands
"

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" Improve syntax highlighting
autocmd BufRead,BufNewFile *.md set filetype=markdown

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

" Autosave
augroup autosave
  autocmd!
  " This can be extended by adding a separator '\|'.
  " An SO thread about execuding files:
  " https://stackoverflow.com/questions/6496778/vim-run-autocmd-on-all-filetypes-except
  autocmd TextChanged,InsertLeave \(zipfile\)\@!*
        \  if get(g:, 'autosave_enabled', 1) &&
        \     empty(&buftype) &&
        \     !empty(bufname())
        \|   update
        \| endif
augroup END

function! ToggleAutosave()
  let g:autosave_enabled = !get(g:, 'autosave_enabled', 1)
endfunction

nnoremap <leader>wa :call ToggleAutosave()<CR>
