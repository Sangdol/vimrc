" Plug Commands:
"   PlugUpdate [name ...]
"   PlugInstall [name ...]
"   PlugClean[!]
"   PlugUpgrade
"   PlugStatus
"
" Keybindings:
"   D - PlugDiff
"   S - PlugStatus
"   R - Retry failed update or installation tasks
"   U - Update plugins in the selected range
"   q - Close the window
"   :PlugStatus => L - Load plugin
"   :PlugDiff => X - Revert the update

Plug 'danro/rename.vim'
Plug 'MTDL9/vim-log-highlighting'
Plug 'junegunn/vim-peekaboo'
Plug 'tpope/vim-surround'
Plug 'dag/vim-fish'

"}}}

"
" scrollview {{{1
"
Plug 'dstein64/nvim-scrollview'

function! s:scrollview_callback()
  highlight ScrollView ctermbg=159 guibg=LightCyan
endfunction

let g:plug_callbacks += [function('s:scrollview_callback')]

"}}}

"
" which-key {{{1
"
Plug 'folke/which-key.nvim'

" Lua modules have to be loaded after `plug#end()`
" since the `end()` function updates `&runtimepath`.
function! s:which_key_callback()
lua << EOF
  require("which-key").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF
endfunction

let g:plug_callbacks += [function('s:which_key_callback')]

"}}}

"
" vim-startuptime {{{1
"
" It seems conditionally loaded plugins are not counted
" e.g., Plug 'petobens/poet-v', { 'for': 'python' }
Plug 'dstein64/vim-startuptime'

"}}}

"
" Tabline {{{1
" (to add numbers to each tabline
"
Plug 'mkitt/tabline.vim'

"}}}

"
" Yaml Revealer {{{1
"
Plug 'Einenlum/yaml-revealer'

"}}}

"
" undotree {{{1
"
Plug 'mbbill/undotree'
nnoremap <Leader>eu :UndotreeToggle<CR>
if has("persistent_undo")
 let target_path = expand('~/.vim/undodir')

  call CreateDirIfNotExist(target_path)

  let &undodir=target_path
  set undofile
endif

"}}}

"
" ReplaceWithRegister {{{1
"
Plug 'vim-scripts/ReplaceWithRegister'

nmap <Leader>ro <Plug>ReplaceWithRegisterOperator
nmap <Leader>rl <Plug>ReplaceWithRegisterLine
xmap <Leader>rr <Plug>ReplaceWithRegisterVisual

"}}}

"
" incsearch {{{1
"

" is.vim (IncSearch)
Plug 'haya14busa/is.vim'
Plug 'osyo-manga/vim-anzu'

map n <Plug>(is-nohl)<Plug>(anzu-n-with-echo)
map N <Plug>(is-nohl)<Plug>(anzu-N-with-echo)

" incsearch.vim
" This one is outdated and has a copy and paste problem
" but it provides a fuzzy search feature.
"
"  - Post of the author: https://medium.com/@haya14busa/incsearch-vim-is-dead-long-live-incsearch-2b7070d55250
"  - Paste issue: https://github.com/haya14busa/incsearch.vim/issues/158
Plug 'haya14busa/incsearch.vim'
map g/ <Plug>(incsearch-stay)

" fuzzy incsearch + fuzzy spell incsearch
Plug 'haya14busa/incsearch-fuzzy.vim'

function! s:config_fuzzyall(...) abort
  return extend(copy({
  \   'converters': [
  \     incsearch#config#fuzzy#converter(),
  \     incsearch#config#fuzzyspell#converter()
  \   ],
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> z/ incsearch#go(<SID>config_fuzzyall())
noremap <silent><expr> z? incsearch#go(<SID>config_fuzzyall({'command': '?'}))
noremap <silent><expr> zg/ incsearch#go(<SID>config_fuzzyall({'is_stay': 1}))

"}}}

"
" Maximizer {{{1
"
Plug 'szw/vim-maximizer'
nnoremap <silent><c-w>m :MaximizerToggle<CR>
vnoremap <silent><c-w>m :MaximizerToggle<CR>gv

"}}}

"
" Symlink {{{1
"
Plug 'aymericbeaumet/vim-symlink'
Plug 'moll/vim-bbye' " optional dependency

"}}}
"

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
"
" To avoid "syntastic: enror: checker racket/racket: checks disabled for security reasons; set g:syntastic_enable_racket_racket_checker to 1 to override"
" - https://github.com/vim-syntastic/syntastic/blob/master/doc/syntastic-checkers.txt#L5372
Plug 'scrooloose/syntastic'
let g:syntastic_enable_racket_racket_checker=1

" Disable as it's too slow
" https://vi.stackexchange.com/questions/2954/how-do-i-disable-syntastic-for-python-files
let g:syntastic_mode_map = { 'passive_filetypes': ['python', 'scala'] }

"}}}

"
" Git {{{1
"

" vim-signify
Plug 'mhinz/vim-signify'

function! s:signify_callback()
  highlight SignifySignAdd    ctermfg=darkblue   guifg=#0000aa cterm=NONE gui=NONE
  highlight SignifySignDelete ctermfg=darkred    guifg=#aa0000 cterm=NONE gui=NONE
  highlight SignifySignChange ctermfg=darkyellow guifg=#aaaa00 cterm=NONE gui=NONE
endfunction

let g:plug_callbacks += [function('s:signify_callback')]

" GV
Plug 'junegunn/gv.vim'

function! s:gv_expand()
  let line = getline('.')
  GV --name-status
  call search('\V'.line, 'c')
  normal! zz
endfunction

autocmd! FileType GV nnoremap <buffer> <silent> + :call <sid>gv_expand()<cr>

nnoremap <leader>gv :GV<CR>
nnoremap <leader>g! :GV!<CR>

" Git messenger
Plug 'rhysd/git-messenger.vim'
nnoremap <leader>gm :GitMessenger<CR>

" Fugitive
Plug 'tpope/vim-fugitive'

nnoremap <leader>gc :tab Git commit -v<CR>
nnoremap <leader>gw :Gw<CR>
nnoremap <leader>ga :Git add .<CR>
nnoremap <leader>gg :Git add . \| :tab Git commit -v<CR>
nnoremap <leader>gk :Gw \| :tab Git commit -v<CR>
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gd :SignifyDiff<CR>
nnoremap <leader>gid :tab Git diff --cached<CR>
nnoremap <leader>gq :Git<CR>:Git commit --amend --reuse-message HEAD
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
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1 " US layout
nmap <Leader>j <Plug>(easymotion-j)
nmap <Leader>k <Plug>(easymotion-k)
nmap <Leader><Leader>w <Plug>(easymotion-w)
nmap <Leader><Leader>b <Plug>(easymotion-b)


"}}}

"
" fzf {{{1
"
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Move out of NERDTree, VOOM, etc. buffers.
" This doesn't work if the second buffer is not a normal buffer.
" Fix it if it bothers.
function! s:escape_abnormal_buf_and(cmd)
  if winnr('$') > 1 && !empty(&buftype)
    2wincmd w
  endif

  execute(a:cmd)
endfunction

nnoremap <leader>'  :call <SID>escape_abnormal_buf_and('Files')<CR>
nnoremap <leader>fl :call <SID>escape_abnormal_buf_and('Lines')<CR>
nnoremap <leader>fc :call <SID>escape_abnormal_buf_and('Commands')<CR>
nnoremap <leader>fr :call <SID>escape_abnormal_buf_and('Colors')<CR>
nnoremap <leader>fi :call <SID>escape_abnormal_buf_and('History')<CR>
nnoremap <leader>f: :call <SID>escape_abnormal_buf_and('History:')<CR>
nnoremap <leader>f/ :call <SID>escape_abnormal_buf_and('History/')<CR>
nnoremap <leader>fh :call <SID>escape_abnormal_buf_and('Helptags')<CR>
nnoremap <leader>fm :call <SID>escape_abnormal_buf_and('Maps')<CR>
nnoremap <leader>fb :call <SID>escape_abnormal_buf_and('Buffers')<CR>

" fzf Rg to search words under the cursor
" https://news.ycombinator.com/item?id=26634419
nnoremap <silent> <leader>ff yiw:Rg <C-r>"<CR>
vnoremap <silent> <leader>ff y:Rg <C-r>"<CR>

function! RgCurrentDir()
  let current_path = expand('%:p:h')
  execute 'lcd ' .. current_path
  execute 'Rg'
endfunction

nnoremap <silent> <leader>fd :call <SID>escape_abnormal_buf_and('call RgCurrentDir()')<CR>
nnoremap <silent> <C-Space> :call <SID>escape_abnormal_buf_and('Rg')<CR>

" https://github.com/junegunn/fzf.vim/issues/251#issuecomment-769787221
command! -bang -bar -nargs=? -complete=dir Cd
    \ call fzf#run(fzf#wrap(
    \ {'source': 'find '.( empty("<args>") ? ( <bang>0 ? "~" : "." ) : "<args>" ) .' -type d',
    \ 'sink': 'cd'}))

" Quick navigations
nnoremap <leader>fp :call <SID>escape_abnormal_buf_and('FZF ~/projects')<CR>
nnoremap <leader>f~ :call <SID>escape_abnormal_buf_and('FZF ~')<CR>
nnoremap <leader>fd :call <SID>escape_abnormal_buf_and('Cd!')<CR>

"}}}

"
" VOom {{{1
" https://www.vim.org/scripts/script.php?script_id=2657
"
" TODO - update Voom window when the main window changes
Plug 'vim-voom/VOoM' " :Voomhelp

let g:voom_tree_width = 45
let g:voom_tab_key = "<plug>"

autocmd FileType markdown nnoremap <silent> <Leader>m :Voom pandoc<CR>
autocmd FileType python nnoremap <silent> <Leader>m :Voom python<CR>
autocmd FileType vim nnoremap <silent> <Leader>m :Voom fmr<CR>

" Open
function VoomPandoc()
  let l:filepath = expand('%:p')

  if filepath !~ 'workbench\/notes'
    Voom pandoc
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

nmap <silent> <C-_> <plug>NERDCommenterToggle
vmap <silent> <C-_> <plug>NERDCommenterToggle

let g:NERDCreateDefaultMappings = 0

"}}}

"
" Colors {{{1
"
Plug 'srcery-colors/srcery-vim'
Plug 'junegunn/seoul256.vim'
Plug 'joshdick/onedark.vim'

" }}}
