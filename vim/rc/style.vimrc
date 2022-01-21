"
" Style
"
set background=dark

colorscheme Tomorrow-Night-Bright

" vim-signify
highlight SignifySignAdd    ctermfg=darkblue  guifg=#00ff00 cterm=NONE gui=NONE
highlight SignifySignDelete ctermfg=darkred    guifg=#ff0000 cterm=NONE gui=NONE
highlight SignifySignChange ctermfg=darkyellow guifg=#ffff00 cterm=NONE gui=NONE

function CurrentDir()
  return fnamemodify(getcwd(), ':t')
endfunction

"Status line
"set laststatus=2 " keep statusline always visible
"set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l,%v][%p%%] %{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}
"set statusline+=%=

function! s:statusline_expr()
  let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? '[RO] ' : ''}"
  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '
  let pct = ' %P'
  let dir = ' [%{CurrentDir()}]'

  return '[%n] %F %<'.mod.ro.ft.fug.sep.pos.'%*'.pct.dir
endfunction
let &statusline = s:statusline_expr()

" Change cursor shape in different modes(In OSX)
" http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
