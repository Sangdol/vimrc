"
" Colorscheme and custom highlights
"

function! s:highlights() abort
  " To have the same opacity as a terminal
  " https://stackoverflow.com/questions/37712730/set-vim-background-transparent
  highlight Normal guibg=NONE ctermbg=NONE guifg=#bbbbbb
  " selection color
  highlight Visual term=reverse cterm=reverse guibg=Grey

  " To make unused variables less noticeable
  " :h coc-highlights
  "
  " Default:
  "   CocUnusedHighlight -> CocFadeOut -> Conceal
  "   highlight Conceal ctermfg=7 ctermbg=242 guifg=LightGrey guibg=Black
  highlight CocFadeOut ctermfg=7 ctermbg=242 guifg=Black guibg=Black
  highlight CocHintSign guifg=gray

  " Custom colors for markdown
  highlight SangH1 guifg=#e4b854 gui=bold
  highlight SangH2 guifg=#701516 gui=bold
  highlight SangH3 guifg=#6d8086
  highlight Link guifg=#3d6117
  highlight Line guifg=#8094b4
  highlight Bullet guifg=#b30b00

  " Tabline
  "
  " Other candidates
  " - jade: guifg=#458588 guibg=#458588
  "
  " Colors from CocList... highlights
  highlight TablineSel guifg=#458588 guibg=#b16286
  highlight TablineBg guifg=#282828
  highlight! link Tabline TablineBg
  highlight! link TablineFill TablineBg

  " Frames
  highlight VertSplit guifg=None guibg=None
  highlight SignColumn guibg=None
  highlight StatusLine guibg=None guifg=#8094b4 gui=None
  highlight StatusLineNC guibg=None guifg=#515151 gui=None

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
colorscheme Tomorrow-Night-Eighties
