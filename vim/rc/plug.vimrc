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
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'MTDL9/vim-log-highlighting'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/gv.vim' " A git commit browser
Plug 'tpope/vim-surround'
Plug 'dag/vim-fish'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'vim-scripts/ReplaceWithRegister'

"}}}

"
" Symlink {{{1
"
Plug 'aymericbeaumet/vim-symlink'
Plug 'moll/vim-bbye' " optional dependency

"}}}

"
" Semantic Highlighting for Python in Neovim {{{1
" https://github.com/numirias/semshi
"

"  Do `pip3 install pynvim --upgrade`
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }

autocmd FileType python nnoremap <buffer> <leader>re :Semshi rename<CR>
autocmd FileType python nnoremap <buffer> <Tab> :Semshi goto name next<CR>
autocmd FileType python nnoremap <buffer> <S-Tab> :Semshi goto name prev<CR>

" All in one like IntelliJ F2
function! SemshiNext()
  execute('Semshi goto parameterUnused first')
  execute('Semshi goto unresolved first')
  execute('Semshi goto error')
endfunction

autocmd FileType python nnoremap <buffer> <leader>ee :call SemshiNext()<CR>

"}}}

"
" Kanggaroo {{{1
" jumpstack manager
" zp: push
" zP: pop
"
Plug 'tommcdo/vim-kangaroo'

"
" Abolish {{{1
"
" :Abolish
" :Subvert :S
"
" Coercion
"  [crs] some_long_identifier
"  [crm] SomeLongIdentifier
"  [crc] someLongIdentifier
"  [cru] SOME_LONG_IDENTIFIER
"  [cr-] some-long-identifier
"  [cr.] some.long.identifier
"  [cr ] some long identifier
"  [crt] Some Long Identifier
"
Plug 'tpope/vim-abolish'

"}}}

"
" COC (Conquer of Completion) {{{1
"
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=number

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gl <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

"}}}

"
" Repeat {{{1
"
" Tutorial: http://vimcasts.org/episodes/creating-repeatable-mappings-with-repeat-vim/
"
Plug 'tpope/vim-repeat'

"}}}

"
" Vader {{{1
" https://github.com/junegunn/vader.vim
"
Plug 'junegunn/vader.vim', {'on': 'Vader', 'for': 'vader'}

nnoremap <silent> <Leader>va :w \| Vader %<CR>
inoremap ;va <ESC>:w \| Vader %<CR>

"}}}

"
" Nerdtree {{{1
"
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

map <C-n> :NERDTreeToggle<CR>
nnoremap <leader>0 :NERDTreeFind<CR>

" auto open
autocmd VimEnter *.yaml,*.yml NERDTree | wincmd p

" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

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
" Clojure: Conjure, parinfer {{{1
"
" Conjure
"   Interactive evaluation for Neovim (Clojure, Fennel, Janet, Racket, Hy, MIT Scheme, Guile)
"
" parinfer-rust
"   A Rust port of parinfer.
"
if has("mac")
  Plug 'Olical/conjure'
  Plug 'Olical/AnsiEsc' " To show ANSI highlighting
  Plug 'eraserhd/parinfer-rust', {'do': 'cargo build --release'}

  function! ToggleAnsiEsc()
    let bufname = split(bufname(), '\.')[0] " ex) bufname: clojure-log-1.cljc
    let bufname = substitute(bufname, '-', '_', 'g')
    let flagname =  bufname .. '_ansi_esc_enabled'
    if !get(g:, flagname, 0)
      exe 'AnsiEsc'
      exe 'let g:' .. flagname .. ' = 1'
    endif
  endfunction

  " https://github.com/Olical/conjure/wiki/Displaying-ANSI-escape-code-colours-in-the-log-buffer
  " The code provided from the wiki doesn't work well
  " probably it toggles a state.
  " The ToggleAnsiEsc function mostly works well.
  " Not sure why it doesn't work sometimes.
  autocmd BufEnter conjure-log-* :call ToggleAnsiEsc()
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
nnoremap <leader>9 :cd %:p:h<CR> :pwd<CR>

" Go to the root
nnoremap <leader>8 :Rooter<CR>

" Added custom root (.rooter)
let g:rooter_patterns = ['.git', 'Makefile', 'package.json', '.rooter']

"}}}

"
" vim-markdown {{{1
" https://github.com/tpope/vim-markdown
"
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

nnoremap <leader>gc :tab Git commit -v<CR>
nnoremap <leader>gw :Gw<CR>
nnoremap <leader>ga :Git add .<CR>
nnoremap <leader>gg :Git add . \| :tab Git commit -v<CR>
nnoremap <leader>gk :Gw \| :tab Git commit -v<CR>
nnoremap <leader>gs :Git status<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gd :tab Git diff<CR>
nnoremap <leader>gid :tab Git diff --cached<CR>
nnoremap <leader>gq :Git commit --amend --reuse-message HEAD
nnoremap <leader>gz :Git stash save --include-untracked<CR>
nnoremap <leader>gx :Git stash pop<CR>
nnoremap <leader>gu :Git pull --rebase<CR>

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

" To avoid to load a file to a VOOM window
function! EscapeVoomAnd(cmd)
  if bufname() =~ 'VOOM'
    2wincmd w
  endif

  execute(a:cmd)
endfunction

nnoremap <C-L>      :call EscapeVoomAnd('Files')<CR>
nnoremap <leader>fl :call EscapeVoomAnd('Lines')<CR>
nnoremap <leader>fc :call EscapeVoomAnd('Commands')<CR>
nnoremap <leader>fi :call EscapeVoomAnd('History')<CR>
nnoremap <leader>f: :call EscapeVoomAnd('History'):<CR>
nnoremap <leader>f/ :call EscapeVoomAnd('History')/<CR>
nnoremap <leader>fh :call EscapeVoomAnd('Helptags')<CR>
nnoremap <leader>fm :call EscapeVoomAnd('Maps')<CR>

" fzf Rg to search words under the cursor
" https://news.ycombinator.com/item?id=26634419
nnoremap <silent> <leader>ff yiw:Rg <C-r>"<CR>
vnoremap <silent> <leader>ff y:Rg <C-r>"<CR>
noremap <silent> <C-Space> :Rg<CR>
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
    function! s:init()
      2wincmd w
    endfunction

    " wincmd command doesn't work when it's called
    " as vim started since vim is not completely ready.
    " Adding this to make it work.
    " The code is from the vim autocmd help page.
    if v:vim_did_enter
      call s:init()
    else
      au VimEnter * call s:init()
    endif
  endif
endfunction

autocmd BufWinEnter,VimEnter *.md if (winnr("$") == 1) | call VoomPandoc() | endif

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

"}}}

call plug#end()
