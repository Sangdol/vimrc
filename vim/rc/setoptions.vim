"
" Settings
"

" set <Leader>
let mapleader="\<Space>"
let maplocalleader="\<Space>"

" Change cursor shape in different modes(In OSX)
" http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" Use vim settings, rather then vi settings
" This must be first, because it changes other options as a side effect.
set nocompatible

" Needed for Syntax Highlighting
filetype on
filetype plugin indent on

" Default tab settings
set smarttab
set shiftround
set shiftwidth=2
set softtabstop=2 " for backspace
set tabstop=2
set expandtab
set autoindent

autocmd FileType python setlocal shiftwidth=4 softtabstop=4 tabstop=4
autocmd FileType java setlocal shiftwidth=4 softtabstop=4 tabstop=4

" Command-line completion
set wildmenu
set wildmode=list:longest,full

" Show line numbers (trying diabling it)
"set number 

" Search settings
set ignorecase
set incsearch
set smartcase

" Backspace on EOL, start, indent
set backspace=eol,start,indent

set history=1000
set undolevels=1000

" You should make the directories
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/swap

" encoding and line ending settings
set encoding=utf8
set fileencoding=utf8
set fileencodings=utf8,cp949,latin1,utf-16le
set fileformat=unix
set fileformats=unix,dos

" Windows related
set splitright
set splitbelow
set scrolloff=5

" clipboard
" https://stackoverflow.com/questions/30691466/what-is-difference-between-vims-clipboard-unnamed-and-unnamedplus-settings
set clipboard^=unnamed,unnamedplus

" Disable mouse support in terminal
" https://vi.stackexchange.com/questions/13566/fully-disable-mouse-in-console-vim
set mouse=
set ttymouse=

" Inspired by vim-anyfold
function! MinimalFoldText() abort
  let fold_size_str = '[%s lines]'
  let fold_level_str = '+'

  let fs = v:foldstart
  while getline(fs) !~ '\w'
      let fs = nextnonblank(fs + 1)
  endwhile
  if fs > v:foldend
      let line = getline(v:foldstart)
  else
      let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
  endif

  let w = winwidth(0) - &foldcolumn - &number * &numberwidth
  let foldSize = 1 + v:foldend - v:foldstart
  let foldSizeStr = " " . substitute(fold_size_str, "%s", string(foldSize), "g") . " "
  let foldLevelStr = repeat(fold_level_str, v:foldlevel)
  let lineCount = line("$")
  let expansionString = repeat(" ", w - strwidth(foldSizeStr.line.foldLevelStr))
  return line . foldSizeStr . expansionString . foldLevelStr
endfunction

set foldmethod=indent
set foldtext=MinimalFoldText()

" neovim only. browser-like jump stack.
set jumpoptions+=stack

" For a quicker coc and vim-signify signs update.
" (default is 4000ms = 4s)
set updatetime=300

"
" Style
"
set listchars=tab:›\ ,trail:·,eol:¬,nbsp:_
set background=dark
set termguicolors

" Be wary of the trailing whitespace
set fillchars=vert:\│,eob:\ 

" Notes
" * `set cursorline` is needed to make the behavior consistent with terminal windows.
set cursorline

" Always show the signcolumn, otherwise it would shift the text each time
" coc diagnostics or vim-signify signs appear/become resolved.
set signcolumn=yes

" This is here instead of autocmd.vim since this is about options.
augroup settings
  autocmd!

  autocmd FileType tagbar,nerdtree,voomtree setlocal signcolumn=no

  " Terminal
  autocmd TermOpen * setlocal nonumber | setlocal norelativenumber | set signcolumn=number

  " The code below enables a line number toggle
  " but it clips texts due to an nvim issue:
  " https://github.com/neovim/neovim/issues/4997
  "autocmd TermOpen * setlocal nonumber | set signcolumn=number
  "autocmd TermLeave * setlocal number
  "autocmd TermEnter * setlocal nonumber

  " Spell check
  autocmd FileType gitcommit setlocal spell

  " Dictionary
  autocmd FileType markdown set complete+=k
augroup END
