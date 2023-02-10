"
" Auto Commands
"

augroup custom
  autocmd!

  " Moves the cursor to the last position
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Json supports comments
  " https://github.com/neoclide/coc.nvim/wiki/Using-the-configuration-file
  autocmd FileType json syntax match Comment +\/\/.\+$+

  " To suppress coc errors on commments
  " https://github.com/neoclide/coc-json/issues/27
  autocmd FileType json set filetype=jsonc

  " For moving application windows across screens
  autocmd VimResized * wincmd =

  " For Voom, NERDTree, etc.
  autocmd VimEnter * wincmd l

  " lua-hightlight / flash on yank
  autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup="SangYankFlash", timeout=200})

  autocmd BufReadPost *gpt3 set filetype=markdown
augroup END

augroup custom_terminal
  " Avoiding going to insert mode when a terminal is opened
  " while the cursor is in the editor: https://github.com/nvim-neotest/neotest/issues/2
  " -> The trick doesn't work anymore. Disabling startinsert altogether.
  "autocmd TermOpen *  if nvim_buf_get_name(0) =~# '^term://.*' | startinsert | endif

  " This makes a problem when doing <Leader>wox on a terminal window
  " since the mode changes to insert mode in the middle of the command.
  "autocmd WinEnter *  if &buftype == 'terminal' | startinsert | endif

  " For some reason, vim starts in insert mode
  " when opening with a session file.
  " => This seems to have been happening due to `startinsert` on TermOpen
  "autocmd SessionLoadPost * stopinsert
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

  autocmd FileType clojure,python let b:autosave_enabled = 0
  autocmd BufLeave,FocusLost *.clj,*.py update
augroup END

function! ToggleAutosave()
  let g:autosave_enabled = !get(g:, 'autosave_enabled', 1)
endfunction

nnoremap <leader>ea :call ToggleAutosave()<CR>
