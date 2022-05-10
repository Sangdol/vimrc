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
syntax enable

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

" Show line numbers
set number

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

" Enable mouse support in terminal
set mouse=a

"
" Marker
" triple '{' as a marker
" http://vim.wikia.com/wiki/Folding
"
" zo - open
" zc - close
" za - toggle
" zO / zC / zA - recursive
" zr - reduces folding by opening one level
" zR - open all
" zm - gives more folding by closing one level
" zM - close all
set foldmethod=marker

" neovim only. browser-like jump stack.
set jumpoptions+=stack

" For a quicker coc and vim-signify signs update.
" (default is 4000ms = 4s)
set updatetime=300

" Dictionary
if has('mac')
  set dictionary+=/usr/share/dict/words
endif

"
" Style
"
set background=dark
set termguicolors

" Notes
" * `set cursorline` is needed to make the behavior consistent with terminal windows.
set cursorline

" Always show the signcolumn, otherwise it would shift the text each time
" coc diagnostics or vim-signify signs appear/become resolved.
set signcolumn=yes
set signcolumn=auto:2

augroup settings
  autocmd!

  autocmd InsertEnter * set nocursorline
  autocmd InsertLeave * set cursorline

  autocmd FileType tagbar,nerdtree,voomtree setlocal signcolumn=no

  " Terminal
  autocmd TermOpen * setlocal nonumber | set signcolumn=number
  autocmd TermLeave * setlocal number
  autocmd TermEnter * setlocal nonumber

  " Spell check
  autocmd FileType gitcommit setlocal spell

  " Dictionary
  autocmd FileType markdown set complete+=k
augroup END
