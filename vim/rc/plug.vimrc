"
" Vim Plug {{{1
"
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Plug Commands
" - PlugInstall [name ...]
" - PlugUpdate [name ...]
" - PlugClean[!]
" - PlugUpgrade
" - PlugStatus
Plug 'danro/rename.vim'
Plug 'inside/vim-search-pulse'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'MTDL9/vim-log-highlighting'
Plug 'junegunn/vim-peekaboo'

" A git commit browser
" https://github.com/junegunn/gv.vim
Plug 'junegunn/gv.vim'

"}}}

"
" Nerdtree {{{1
"
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

map <C-n> :NERDTreeToggle<CR>
nnoremap <localleader>1 :NERDTreeFind<CR>

" auto open
autocmd VimEnter *.yaml,*.yml NERDTree | wincmd p

" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"}}}

"
" Semantic Highlighting for Python in Neovim {{{1
" https://github.com/numirias/semshi
"
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' } "  `pip3 install pynvim --upgrade`

nmap <silent> <leader>rr :Semshi rename<CR>
nmap <silent> <Tab> :Semshi goto name next<CR>
nmap <silent> <S-Tab> :Semshi goto name prev<CR>

" All in one like IntelliJ F2
function SemshiNext()
  execute('Semshi goto parameterUnused first')
  execute('Semshi goto unresolved first')
  execute('Semshi goto error')
endfunction

nmap <leader>ee :call SemshiNext()<CR>

"}}}

"
" markdown-preview {{{1
" https://github.com/iamcco/markdown-preview.nvim
"

" Need to manually install for some reason - :call mkdp#util#install()
" https://github.com/iamcco/markdown-preview.nvim/issues/41
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': 'markdown' }
let g:mkdp_auto_close = 0

"}}}

"
" vim-anyfold {{{1
" https://github.com/pseewald/vim-anyfold
"
Plug 'pseewald/vim-anyfold'
autocmd Filetype yaml,javascript,scala,typescript,java,json AnyFoldActivate

"}}}

"
" Ack {{{1
" https://github.com/mileszs/ack.vim#can-i-use-ag-the-silver-searcher-with-this
"
Plug 'mileszs/ack.vim'  " :h ack

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

"}}}

"
" Conjure {{{1
"   Interactive evaluation for Neovim (Clojure, Fennel, Janet, Racket, Hy, MIT Scheme, Guile)
" parinfer-rust: A Rust port of parinfer.
"
if has("mac")
  Plug 'Olical/conjure', {'tag': 'v3.0.0'}
  Plug 'eraserhd/parinfer-rust', {'do': 'cargo build --release'}
endif

" turn on by default
augroup rainbow_lisp
  autocmd!
  autocmd FileType lisp,clojure,scheme,racket RainbowParentheses
augroup END

"}}}

"
" vim-illuminate {{{1
"
Plug 'RRethy/vim-illuminate' " https://github.com/RRethy/vim-illuminate
let g:Illuminate_ftblacklist = ['nerdtree', 'markdown']

"}}}

"
" vim-rooter {{{1
" https://github.com/airblade/vim-rooter
"
Plug 'airblade/vim-rooter' " Changes Vim working directory to project root.

" Go to the current dir
" https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
nnoremap <localleader>2 :cd %:p:h<CR> :pwd<CR>

" Go to the root
nnoremap <localleader>3 :Rooter<CR>

"}}}

"
" vim-markdown {{{1
"let g:markdown_folding = 1 " This make things slow https://github.com/gabrielelana/vim-markdown/issues/58
set nofoldenable " to not fold when opening a file https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
set conceallevel=2 " to conceal _, * used for italic or bold

" https://coderwall.com/p/ftqcla/markdown-with-fenced-code-blocks-in-vim
" https://github.com/github/linguist/blob/master/lib/linguist/languages.yml
" delete most of them as it slows down file loading - ['coffee', 'css', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sql', 'xml', 'java', 'python', 'sh', 'html', 'clojure', 'yaml', 'applescript', 'go', 'vim', 'awk', 'groovy']
let g:markdown_fenced_languages = ['javascript', 'js=javascript', 'json=javascript', 'bash', 'sh', 'python', 'clojure', 'scala', 'log', 'vim']

"}}}

"
" Syntastic {{{1
"
" To avoid "syntastic: error: checker racket/racket: checks disabled for security reasons; set g:syntastic_enable_racket_racket_checker to 1 to override"
" - https://github.com/vim-syntastic/syntastic/blob/master/doc/syntastic-checkers.txt#L5372
"
Plug 'scrooloose/syntastic'
let g:syntastic_enable_racket_racket_checker=1

" disable for python as it's too slow
" https://vi.stackexchange.com/questions/2954/how-do-i-disable-syntastic-for-python-files
let g:syntastic_mode_map = { 'passive_filetypes': ['python'] }

"}}}

"
" Fugitive {{{1
" https://github.com/tpope/vim-fugitive
"
" Commands:
"   :Git (commit|status|diff|blame)
"   :Grep
"   :Gwrite " add
"   :Gdiffsplit
"   :Gvdiffsplit
Plug 'tpope/vim-fugitive'

"}}}

"
" easymotion {{{1
" <Leader><Leader>w - word motion
" <Leader><Leader>j/k - down/up
" <Leader><Leader>f + <character> - jump to the character
"
Plug 'Lokaltog/vim-easymotion'  " :h easymotion.txt
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1 " US layout
nmap <Leader>j <Leader><Leader>j
nmap <Leader>k <Leader><Leader>k

"}}}

"
" fzf {{{1
"
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

nmap <C-l> :Files<Enter>
nmap <localleader>af :Files<Enter>
nmap <localleader>ab :Buffers<Enter>
nmap <localleader>aa :Ack<Space>
nmap <localleader>al :Lines<Space>
nmap <localleader>ac :Commits<Enter>
" BCommits: commits for the current buffer
nmap <localleader>av :BCommits<Enter>
nmap <localleader>az :Commands<Enter>
nmap <localleader>a: :History:<Enter>
nmap <localleader>a/ :History/<Enter>

" fzf Rg to search words under the cursor
" https://news.ycombinator.com/item?id=26634419
nnoremap <silent> <C-Space> yiw:Rg <C-r>"<CR>
vnoremap <silent> <C-Space> y:Rg <C-r>"<CR>

"}}}

"
" VOom {{{1
" https://www.vim.org/scripts/script.php?script_id=2657
"
" TODO - update Voom window when the main window changes
Plug 'vim-voom/VOoM' " :Voomhelp

let g:voom_tree_width = 45

autocmd FileType markdown nnoremap <silent> <Leader>m :Voom pandoc<CR>
autocmd FileType python nnoremap <silent> <Leader>m :Voom python<CR>
autocmd FileType vim nnoremap <silent> <Leader>m :Voom fmr<CR>

" Open
function VoomPandoc()
  let l:filepath = expand('%:p')

  if filepath !~ 'workbench\/notes'
    Voom pandoc

    " why doesn't it work when vim is started?
    2wincmd w
  endif
endfunction

autocmd BufWinEnter *.md if (winnr("$") == 1) | call VoomPandoc() | endif

" Close
autocmd BufEnter * if (winnr("$") == 1 && expand("%:e") =~ "VOOM") | q | endif

" Update
" bug - window disappears when changing tabs
function VoomUpdate()
  let l:win1name = bufname(winbufnr(1))
  let l:filename = bufname(winbufnr(2))
  "" multiple conditions: https://vi.stackexchange.com/a/8241/3225
  "" =~ comparison: https://vi.stackexchange.com/a/31086/3225
  if (win1name =~ "VOOM") > 0 && (win1name =~ filename) == 0
    "" excute these only if the current VOOM tree window is not for the current file

    " close the existing Voom tree window
    1wincmd w
    Voomquit

    " why does it get unstable when calling VoomPandoc()?
    Voom pandoc
    2wincmd w
  endif
endfunction

autocmd BufWinEnter *.md if (winnr("$") == 2) | call VoomUpdate() | endif
"}}}

"
" NerdCommenter {{{1
"
Plug 'scrooloose/nerdcommenter'

nmap <silent> <C-_> <Leader>c<Space>
vmap <silent> <C-_> <Leader>c<Space>

call plug#end()

"}}}
