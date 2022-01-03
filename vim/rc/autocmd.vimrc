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
function! AutoSaveAutoCmd()
  autocmd TextChanged,InsertLeave <buffer>
        \  if get(g:, 'autosave_enabled', 1) &&
        \     empty(&buftype) &&
        \     !empty(bufname())
        \|   update
        \| endif
endfunction

" Autosave
augroup autosave
  autocmd!
  autocmd BufReadPost * if !StartsWith(bufname(), 'zipfile') | :call AutoSaveAutoCmd() | endif
augroup END

function! ToggleAutosave()
  let g:autosave_enabled = !get(g:, 'autosave_enabled', 1)
endfunction

nnoremap <leader>wa :call ToggleAutosave()<CR>
