"
" Colorscheme and custom highlights
"

function! s:highlights() abort
  " To have the same opacity as a terminal
  " https://stackoverflow.com/questions/37712730/set-vim-background-transparent
  highlight Normal guibg=NONE ctermbg=NONE

  " Custom colors for markdown
  highlight markdownH1 guifg=#e4b854 gui=bold
  highlight markdownH2 guifg=#701516 gui=bold
  highlight markdownH3 guifg=#6d8086
  highlight markdownHeadingRule guifg=#8094b4
  highlight markdownListMarker guifg=#b30b00
  highlight mkdInlineURL guifg=#3d6117
  highlight markdownLinkText guifg=#614100

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
