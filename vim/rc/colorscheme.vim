"
" Colorscheme and custom highlights
"

function! s:highlights() abort
  " To have the same opacity as a terminal
  " https://stackoverflow.com/questions/37712730/set-vim-background-transparent
  highlight Normal guibg=NONE ctermbg=NONE

  " Etc.
  highlight SangYankFlash guifg=#cc241d guibg=#282828

endfunction

" Why augroup? https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
augroup CustomColors
  autocmd!
  autocmd ColorScheme * call s:highlights()
augroup END

" This has to come after `plug#end()` to be able to
" use colorscheme installed by Plug.
colorscheme github_dark_default

nnoremap <silent> <leader>ed :colorscheme github_dark_default<CR>
nnoremap <silent> <leader>el :colorscheme github_light_default<CR>
