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
  highlight markdownH1 guifg=#e4b854 gui=bold
  highlight markdownH2 guifg=#701516 gui=bold
  highlight markdownH3 guifg=#6d8086
  highlight markdownHeadingRule guifg=#8094b4
  highlight markdownListMarker guifg=#b30b00
  highlight mkdInlineURL guifg=#3d6117
  highlight markdownLinkText guifg=#614100

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

  " Statusline
  let statuslineBg = "#484347"
  let statuslineFg = "#717171"
  let statuslineNcBg = "#383337"
  let statuslineNcFg = "#515151"
  let dirColorFg = "#b9ecec"
  let dirColorNcFg = "#cccccc"
  let gbStatusColorFg = "#ffa61a"

  execute 'highlight StatusLine guibg=' . statuslineBg . ' guifg=' . statuslineFg . ' gui=None'
  execute 'highlight StatusLineNC guibg=' . statuslineNcBg . ' guifg=' . statuslineNcFg . ' gui=None'
  execute 'highlight DirColor guibg=' . statuslineBg . ' guifg=' . dirColorFg . ' gui=None'
  execute 'highlight DirColorNC guibg=' . statuslineNcBg . ' guifg=' . dirColorNcFg . ' gui=None'
  execute 'highlight GBStatusColor guibg=' . statuslineBg . ' guifg=' . gbStatusColorFg . ' gui=None'
  execute 'highlight GBStatusColorNC guibg=' . statuslineNcBg . ' guifg=' . gbStatusColorFg . ' gui=None'
  execute 'highlight NvimGpsColor guibg=' . statuslineBg . ' guifg=' . gbStatusColorFg . ' gui=None'
  execute 'highlight NvimGpsColorNC guibg=' . statuslineNcBg . ' guifg=' . gbStatusColorFg . ' gui=None'

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
colorscheme tundra
