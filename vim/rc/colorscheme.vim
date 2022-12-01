"
" Colorscheme and custom highlights
"

function! s:highlights() abort
  " To have the same opacity as a terminal
  " https://stackoverflow.com/questions/37712730/set-vim-background-transparent
  highlight Normal guibg=NONE ctermbg=NONE
  " selection color
  highlight Visual term=reverse cterm=reverse guibg=Grey

  highlight SignColumn guibg=gray10

  " To make unused variables less noticeable
  " :h coc-highlights
  "
  " Default:
  "   CocUnusedHighlight -> CocFadeOut -> Conceal
  "   highlight Conceal ctermfg=7 ctermbg=242 guifg=LightGrey guibg=Black
  highlight CocFadeOut ctermfg=7 ctermbg=242 guifg=Black guibg=Black
  highlight CocHintSign guifg=gray

  " Custom colors
  highlight SangH1 guifg=#e4b854 gui=bold

  syntax match VoomHeaderH2 /\v  . \|.+/
  highlight SangH2 guifg=#701516 gui=bold

  syntax match VoomHeaderH3 /\v  . . \|.+/
  highlight SangH3 guifg=#6d8086
endfunction

" Why augroup? https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
augroup CustomColors
  autocmd!
  autocmd ColorScheme * call s:highlights()
augroup END

" This has to come after `plug#end()` to be able to
" use colorscheme installed by Plug.
colorscheme Tomorrow-Night-Eighties
