"
" Style
"
set background=dark

colorscheme Tomorrow-Night-Bright

" To have the same opacity as a terminal
" https://stackoverflow.com/questions/37712730/set-vim-background-transparent
hi Normal guibg=NONE ctermbg=NONE
" selection color
hi Visual term=reverse cterm=reverse guibg=Grey

function CurrentDir()
  return fnamemodify(getcwd(), ':t')
endfunction

"Status line
set laststatus=2 " keep statusline always visible
set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l,%v][%p%%]
set statusline+=%=
set statusline+=[%{CurrentDir()}]

" Change cursor shape in different modes(In OSX)
" http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
