"
" Colorscheme and custom highlights
"
function! s:common_colorscheme() abort
  " Custom colors for markdown
  highlight markdownH1 guifg=#e4b854 gui=bold
  highlight markdownH2 guifg=#701516 gui=bold
  highlight markdownH3 guifg=#6d8086
  highlight markdownHeadingRule guifg=#8094b4
  highlight markdownListMarker guifg=#b30b00
  highlight mkdInlineURL guifg=#3d6117
  highlight markdownLinkText guifg=#614100

  " Fold
  " None guibg to avoid visual clutters when a terminal is transparent.
  highlight Folded guifg=#cc99cc guibg=None

  " Etc.
  highlight SangYankFlash guifg=#cc241d guibg=#282828
endfunction

function! s:dark_colorscheme() abort
  " To make unused variables less noticeable
  " :h coc-highlights
  "
  " Default:
  "   CocUnusedHighlight -> CocFadeOut -> Conceal
  "   highlight Conceal ctermfg=7 ctermbg=242 guifg=LightGrey guibg=Black
  highlight CocFadeOut ctermfg=7 ctermbg=242 guifg=Black guibg=Black
  highlight CocHintSign guifg=gray

  " To have the same opacity as a terminal
  " https://stackoverflow.com/questions/37712730/set-vim-background-transparent
  highlight Normal guibg=NONE ctermbg=NONE guifg=#bbbbbb

  " Statusline
  let statuslineBg = "#484347"
  let statuslineFg = "#717171"
  let statuslineNcBg = "#383337"
  let statuslineNcFg = "#515151"
  let dirColorFg = "#b9ecec"
  let dirColorNcFg = "#cccccc"
  let gbStatusColorFg = "#ffa61a"

  " Cursorline
  highlight CursorLineNr guifg=#81939b
  highlight CursorLine guibg=#181818

  execute 'highlight StatusLine guibg=' . statuslineBg . ' guifg=' . statuslineFg . ' gui=None'
  execute 'highlight StatusLineNC guibg=' . statuslineNcBg . ' guifg=' . statuslineNcFg . ' gui=None'
  execute 'highlight DirColor guibg=' . statuslineBg . ' guifg=' . dirColorFg . ' gui=None'
  execute 'highlight DirColorNC guibg=' . statuslineNcBg . ' guifg=' . dirColorNcFg . ' gui=None'
  execute 'highlight GBStatusColor guibg=' . statuslineBg . ' guifg=' . gbStatusColorFg . ' gui=None'
endfunction

function! s:light_colorscheme() abort
  " To have the same opacity as a terminal
  " https://stackoverflow.com/questions/37712730/set-vim-background-transparent
  highlight Normal guibg=NONE ctermbg=NONE 
endfunction

function! s:highlights() abort
  call s:common_colorscheme()

  " Get the current colorscheme name
  redir => current_colorscheme
  silent! colorscheme
  redir END

  " Dark or Light?
  if match(tolower(current_colorscheme), 'dark') >= 0
    call s:dark_colorscheme()
  elseif match(tolower(current_colorscheme), 'light') >= 0
    call s:light_colorscheme()
  endif

  " Apply project local vimrc colors
  call RunProjectLocalVimrc()
endfunction

" Why augroup? https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
augroup CustomColors
  autocmd!
  autocmd ColorScheme * call s:highlights()
augroup END

" This has to come after `plug#end()` to be able to
" use colorscheme installed by Plug.
colorscheme github_dark_default

nnoremap <silent> <leader>e[ :colorscheme github_dark_default<CR>
nnoremap <silent> <leader>e] :colorscheme github_light_default<CR>
