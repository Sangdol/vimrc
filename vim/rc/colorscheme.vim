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
  " Colors from CocList... highlights
  highlight TablineSel guibg=#458588 gui=None
  highlight TablineBg guifg=#282828 guibg=#181317
  highlight! link Tabline TablineBg
  highlight! link TablineFill TablineBg

  " Frames
  highlight VertSplit guifg=#191919 guibg=None
  highlight SignColumn guibg=None
  highlight StatusLine guibg=#282327 guifg=#717171 gui=None
  highlight StatusLineNC guibg=#181317 guifg=#515151 gui=None
  highlight DirColor guibg=#282327 guifg=#99cccc gui=None
  highlight DirColorNC guibg=#181317 guifg=#cccccc gui=None
  highlight GBStatusColor guibg=#282327 guifg=#ffa61a gui=None
  highlight GBStatusColorNC guibg=#181317 guifg=#ffa61a gui=None

  " Lines
  highlight LineNr guifg=#000000 " Why can't I tone down the color?
  highlight CursorLineNr guifg=#81939b
  highlight CursorLine guibg=#181818

  " Fold
  " None guibg to avoid visual clutters when a terminal is transparent.
  highlight Folded guifg=#cc99cc guibg=None

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
