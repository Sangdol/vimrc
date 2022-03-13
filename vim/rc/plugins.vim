"
" Plugins
"

"
" dial {{{1
"
Plug 'monaqa/dial.nvim'

nmap <C-a> <Plug>(dial-increment)
nmap <C-x> <Plug>(dial-decrement)
vmap <C-a> <Plug>(dial-increment)
vmap <C-x> <Plug>(dial-decrement)
vmap g<C-a> <Plug>(dial-increment-additional)
vmap g<C-x> <Plug>(dial-decrement-additional)

"}}}

"
" close-buffers {{{1
"
Plug 'Asheq/close-buffers.vim'

nnoremap <leader>ed :Bdelete hidden<cr>

"}}}

"
" vim-surround {{{1
"
Plug 'tpope/vim-surround'

"}}}

"
" rename {{{1
"
Plug 'danro/rename.vim'

" Rename in the command line window
nnoremap <leader>er :let @+=expand("%:t")<CR> \| :Rename <C-r>+<C-f>

"}}}

"
" ultisnips {{{1
"
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

let g:UltiSnipsExpandTrigger="<C-l>"
let g:UltiSnipsJumpForwardTrigger="<C-l>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = '~/.vim/UltiSnips'

nnoremap <leader>ee :UltiSnipsEdit<cr>
nnoremap <leader>ef :call UltiSnips#RefreshSnippets()<cr>

"}}}

"
" vim-qf {{{1
"
" Keep, Reject, Retore
Plug 'romainl/vim-qf'

"}}}

"
" scrollview {{{1
"

" A scrollbar is counted as a window so the autoclose autocmd using winnr('$') doesn't work
" (check out FocusableWinCount() in utility.vim).
Plug 'dstein64/nvim-scrollview'

let g:scrollview_current_only = 1

function! s:scrollview_highlights()
  highlight ScrollView ctermbg=159 guibg=LightCyan
endfunction

augroup ScrollViewColors
  autocmd!
  autocmd ColorScheme * call s:scrollview_highlights()
augroup END

"}}}

"
" which-key {{{1
"
Plug 'folke/which-key.nvim'

" Popup delay
set timeoutlen=200

" Lua modules have to be loaded after `plug#end()`
" since the `end()` function updates `&runtimepath`.
lua << EOF
  table.insert(plugin_callbacks, function()
    require("which-key").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  end)
EOF

"}}}

"
" vim-startuptime {{{1
"
" It seems conditionally loaded plugins are not counted
" e.g., Plug 'petobens/poet-v', { 'for': 'python' }
Plug 'dstein64/vim-startuptime'

"}}}

"
" Mintabline {{{1
"
Plug 'Sangdol/mintabline.vim', { 'branch': 'nvim-web-devicons' }
Plug 'ryanoasis/vim-devicons'

let g:DevIconsEnableFolderPatternMatching = 0

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
" to auto-remove hlsearch
"

" Forked https://github.com/junegunn/vim-slash
Plug 'Sangdol/vim-slash'
Plug 'osyo-manga/vim-anzu'

map n <Plug>(anzu-n-with-echo)zt
map N <Plug>(anzu-N-with-echo)zt

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

" Using it to avoid 'autocommand nesting too deep' issue
" https://github.com/aymericbeaumet/vim-symlink/issues/6
"
" Forked it from https://github.com/moll/vim-bbye
" to remove :Bdelete in favor of close-buffers.vim
Plug 'Sangdol/vim-bbye'

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
" nvim tree {{{1
"
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

" vimrc
let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
let g:nvim_tree_icon_padding = ' ' "one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
let g:nvim_tree_symlink_arrow = ' >> ' " defaults to ' ➛ '. used as a separator between symlinks' source and target.
let g:nvim_tree_respect_buf_cwd = 1 "0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
let g:nvim_tree_create_in_closed_folder = 1 "0 by default, When creating files, sets the path of a file when cursor is on a closed folder to the parent folder when 0, and inside the folder when 1.
let g:nvim_tree_special_files = {} " List of filenames that gets highlighted with NvimTreeSpecialFile
let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 1,
    \ 'files': 1,
    \ 'folder_arrows': 0,
    \ }
"1 by default, notice that if 'files' is 1, it will only display
"if nvim-web-devicons is installed and on your runtimepath.
"if folder is 1, you can also tell folder_arrows 1 to show small arrows next to the folder icons.
"but this will not work when you set indent_markers (because of UI conflict)

" default will show icon by default if no icon is provided
" default shows no icon by default
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'arrow_open': "",
    \   'arrow_closed': "",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   }
    \ }

nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>7 :NvimTreeRefresh<CR>
nnoremap <leader>0 :NvimTreeFindFile<CR>

augroup NvimTreeColors
  " a list of groups can be found at `:help nvim_tree_highlight`
  highlight NvimTreeFolderIcon guibg=blue
augroup END

lua << EOF
  table.insert(plugin_callbacks, function()
    require'nvim-tree'.setup {
      view = {
        mappings = {
          list = {
            { key = "!", action = "run_file_command" },
            { key = ".", action = "" }
          }
        }
      }
    }
  end)
EOF

" Auto-refresh
autocmd BufEnter * if &filetype == 'NvimTree' | execute 'NvimTreeRefresh' | endif

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
let g:rooter_cd_cmd = 'lcd'

"}}}

"
" vim-markdown {{{1
" https://github.com/tpope/vim-markdown
"
"let g:markdown_folding = 1 " This make things slow https://github.com/gabrielelana/vim-markdown/issues/58
set nofoldenable " to not fold when opening a file https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
set conceallevel=2 " to conceal _, * used for italic or bold

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

function! s:signify_highlights()
  highlight SignifySignAdd    ctermfg=darkblue   guifg=#0000aa cterm=NONE gui=NONE
  highlight SignifySignDelete ctermfg=darkred    guifg=#aa0000 cterm=NONE gui=NONE
  highlight SignifySignChange ctermfg=darkyellow guifg=#aaaa00 cterm=NONE gui=NONE
endfunction

augroup SignifyColors
  autocmd!
  autocmd ColorScheme * call s:signify_highlights()
augroup END

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
"
" q	Close the popup window
" o	older. Back to older commit at the line
" O	Opposite to o. Forward to newer commit at the line
" d	Toggle unified diff hunks only in current file of the commit
" D	Toggle all unified diff hunks of the commit
" r	Toggle word diff hunks only in current file of the commit
" R	Toggle all word diff hunks of current commit
" ?	Show mappings help
Plug 'rhysd/git-messenger.vim'
nnoremap <leader>gm :GitMessenger<CR>

" Fugitive
"
"  Diff:   d?
"  Commit: c?
"  Stash:  cz?
"  Rebase: r?
Plug 'tpope/vim-fugitive'

nnoremap <leader>gw :Gw<CR>
nnoremap <leader>ga :Git add .<CR>
nnoremap <leader>gg :Git add . \| :tab Git commit -v<CR>
nnoremap <leader>gk :Gw \| :tab Git commit -v<CR>
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gd :tab Gdiffsplit<CR>
nnoremap <leader>gf :tab Git diff<CR>
nnoremap <leader>gid :tab Git diff --cached<CR>
nnoremap <leader>gma :Git checkout master \| :Git pull --rebase<CR>
nnoremap <leader>g- :Git switch -<CR>
nnoremap <leader>gcb :Git checkout -b<space>
nnoremap <leader>gpp :Git push \| :call ClearPushedCount()<CR>
nnoremap <leader>gpo :Git push -u origin HEAD<CR>
nnoremap <leader>gpu :Git pull --rebase \| :call ClearPulledCount()<CR>

" GitHub extension for fugitive
Plug 'tpope/vim-rhubarb'

nnoremap <leader>gb :GBrowse<CR>
nnoremap <leader>ge :GBrowse .<CR>

" Extra
nnoremap <leader>gh :!gh pr checkout<space>

" fzf-checkout
Plug 'stsewd/fzf-checkout.vim'
nnoremap <leader>gco :GBranches checkout --locals<CR>

" gitbranch to show branch name instead of [Git(master)] of fugitive
Plug 'itchyny/vim-gitbranch'

"}}}

"
" easymotion {{{1
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
" VOom {{{1
"
" :Voomhelp
"
" Forked from 'vim-voom/VOoM' to customize mappings.
Plug 'sangdol/VOoM', {'branch': 'sang-voom'}

let g:voom_tree_width = 45
let g:voom_tab_key = "<plug>"

function! s:voom() abort
  let voomcmd = get({'python': 'python', 'markdown': 'pandoc'}, &filetype, 'fmr')
  execute('Voom ' .. voomcmd)
endfunction

" only for the first window
function! s:toggle_voom() abort
  let win1name = bufname(winbufnr(1))
  if (win1name =~ "VOOM") > 0
    Voomquit
  else
    call s:voom()
  endif
endfunction

nnoremap <silent> <Leader>m :call <sid>toggle_voom()<cr>

" Open
function! VoomPandoc() abort
  let l:filepath = expand('%:p')

  if filepath !~ 'workbench\/notes'
    Voom pandoc
  endif
endfunction

autocmd BufWinEnter,VimEnter *.md if (FocusableWinCount() == 1) | call VoomPandoc() | endif

" Auto close
autocmd BufEnter * if (FocusableWinCount() == 1 && expand("%:e") =~ "VOOM") | q | endif

" Update
function! VoomUpdate() abort
  let l:win1name = bufname(winbufnr(1))
  let l:filename = bufname(winbufnr(2))
  if (win1name =~ "VOOM") > 0 && (win1name =~ filename) == 0
    "" excute these only if the current VOOM tree window is not for the current file

    " close the existing Voom tree window
    1wincmd w
    Voomquit

    call s:voom()
    2wincmd w
  endif
endfunction

" Known bug: if it applies to `*` it'll open two voom windows for some reason
"           while it doesn't generate messages on `echom` inside VoomUpdate().
autocmd BufWinEnter *.md,*.vimrc,*.vim,*.py if (FocusableWinCount() == 2) | call VoomUpdate() | endif

"}}}

"
" fzf {{{1
"
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Move out of NERDTree, Voomtree, etc. buffers.
" This doesn't work if the second buffer is not a normal buffer.
" Fix it if it bothers.
function! s:escape_abnormal_buf_and(cmd)
  if FocusableWinCount() > 1 && !empty(&buftype)
    2wincmd w
  endif

  execute a:cmd
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
nnoremap <leader>ft :call <SID>escape_abnormal_buf_and('Filetypes')<CR>
nnoremap <leader>fs :call <SID>escape_abnormal_buf_and('Snippets')<CR>

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
nnoremap <leader>f~ :call <SID>escape_abnormal_buf_and('Cd!')<CR>
nnoremap <leader>fg :call <SID>escape_abnormal_buf_and('FZF ~/.vim/plugged')<CR>

" From https://github.com/junegunn/fzf/blob/master/README-VIM.md
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.9, 'relative': v:false } }

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
" Syntax highlight {{{1
"

Plug 'MTDL9/vim-log-highlighting'
Plug 'GEverding/vim-hocon'
Plug 'dag/vim-fish'

"}}}
