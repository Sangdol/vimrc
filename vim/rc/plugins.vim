"
" Plugins
"

"
" vim-yoink {{{1
"
" Yank History manager
"
" :Yanks
" :ClearYanks
"
Plug 'svermeulen/vim-yoink'

nmap <c-n> <plug>(YoinkPostPasteSwapBack)
nmap <c-p> <plug>(YoinkPostPasteSwapForward)

nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)

nmap gp <plug>(YoinkPaste_gp)
nmap gP <plug>(YoinkPaste_gP)

nmap [y <plug>(YoinkRotateBack)
nmap ]y <plug>(YoinkRotateForward)

nmap <c-=> <plug>(YoinkPostPasteToggleFormat)

" To make it work with auto-save
" https://github.com/svermeulen/vim-yoink/issues/12
let g:yoinkChangeTickThreshold  = 1

"}}}

"
" vim-markdown-toc {{{1
"
" Markdown table of contents generator
"
Plug 'mzlogin/vim-markdown-toc'

"}}}

"
" markdown-preview {{{1
" https://github.com/iamcco/markdown-preview.nvim
"

" Need to manually install for some reason - :call mkdp#util#install()
" https://github.com/iamcco/markdown-preview.nvim/issues/41
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': 'markdown' }

let g:mkdp_auto_close = 0

nnoremap <leader>em :MarkdownPreview<CR>

"}}}

"
" tagbar {{{1
"
Plug 'majutsushi/tagbar'
Plug 'lvht/tagbar-markdown'

nnoremap <silent> <leader>mt :TagbarToggle<cr>

"}}}

"
" Better digraphs {{{1
"
Plug 'nvim-telescope/telescope.nvim'
Plug 'protex/better-digraphs.nvim'

inoremap <C-k><C-k> <Cmd>lua require'betterdigraphs'.digraphs("i")<CR>
nnoremap r<C-k><C-k> <Cmd>lua require'betterdigraphs'.digraphs("r")<CR>
vnoremap r<C-k><C-k> <ESC><Cmd>lua require'betterdigraphs'.digraphs("gvr")<CR>

"}}}

"
" numbertoggle (relative line number) {{{1
"
Plug 'jeffkreeftmeijer/vim-numbertoggle'

"}}}

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

" :mksession doesn't work due to floating windows
" https://github.com/dstein64/nvim-scrollview/issues/71
command -bang -nargs=? MkSession
      \ silent! ScrollViewDisable
      \ | mksession<bang> <args>
      \ | silent! ScrollViewEnable

"}}}

"
" which-key {{{1
"
Plug 'folke/which-key.nvim'

" Popup delay
set timeoutlen=200

function! s:whichkey_highlights() abort
  highlight WhichKeyFloat guibg=gray10
endfunction

augroup WhichKeyColors
  autocmd!
  autocmd ColorScheme * call s:whichkey_highlights()
augroup END

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
Plug 'Sangdol/mintabline.vim'

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

nnoremap <leader>9 :NvimTreeToggle<CR>
nnoremap <leader>0 :NvimTreeFindFile<CR>

augroup NvimTreeColors
  " a list of groups can be found at `:help nvim_tree_highlight`
  highlight NvimTreeFolderIcon guibg=blue
augroup END

lua << EOF
  table.insert(plugin_callbacks, function()
    require'nvim-tree'.setup {
      renderer = {
        highlight_git = true,
        indent_markers = {
          enable = true
        },
        icons = {
          glyphs = {
            default = "???",
            symlink = "???",
            git = {
              unstaged = "???",
              staged = "???",
              unmerged = "???",
              renamed = "???",
              untracked = "???",
              deleted = "???",
              ignored = "???"
            },
            folder = {
              arrow_open = "???",
              arrow_closed = "???",
              default = "???",
              open = "???",
              empty = "???",
              empty_open = "???",
              symlink = "???",
              symlink_open = "???",
            }
          }
        }
      },
      view = {
        mappings = {
          list = {
            { key = "!", action = "run_file_command" },
            { key = ".", action = "" }
          }
        }
      },
      actions = {
        open_file = {
          resize_window = true
        }
      }
    }
  end)
EOF

"}}}

"
" vim-anyfold {{{1
"
Plug 'pseewald/vim-anyfold'
autocmd Filetype yaml,javascript,scala,typescript,java,json AnyFoldActivate

"}}}

"
" Ack {{{1
"
Plug 'mileszs/ack.vim'  " :h ack

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

"}}}

"
" vim-illuminate {{{1
"
Plug 'RRethy/vim-illuminate'
let g:Illuminate_ftblacklist = ['nerdtree', 'markdown']

"}}}

"
" vim-rooter {{{1
"
Plug 'airblade/vim-rooter' " Changes Vim working directory to project root.

" Go to the current dir
nnoremap <leader>7 :cd %:p:h<CR> :pwd<CR>

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

let g:signify_priority = 5 " Less than vimspector

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
nnoremap <leader>gg :wa \| :Git add . \| :tab Git commit -v<CR>
nnoremap <leader>gk :w \| :Gw \| :tab Git commit -v<CR>
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

" Open in Browser
" o: open (current)
" .: root
nnoremap <leader>gbo :GBrowse<CR>
nnoremap <leader>gb. :GBrowse .<CR>

" gcp: [g]it [c]heckout [p]r
nnoremap <leader>gch :!gh pr checkout<space>

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

nnoremap <silent> <Leader>mm :call <sid>toggle_voom()<cr>

" Open
function! VoomPandoc() abort
  Voom pandoc
endfunction

autocmd BufWinEnter *.md if (FocusableWinCount() == 1 && v:this_session == '') | call VoomPandoc() | endif

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

let g:fzf_preview_window = ['down:50%', 'ctrl-/']

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

" git
nnoremap <leader>fgs :call <SID>escape_abnormal_buf_and('GFiles?')<CR>
nnoremap <leader>fgc :call <SID>escape_abnormal_buf_and('Commits')<CR>
nnoremap <leader>fgb :call <SID>escape_abnormal_buf_and('BCommits')<CR>


" fzf Rg to search words under the cursor
" https://news.ycombinator.com/item?id=26634419
nnoremap <silent> <leader>ff yiw:Rg <C-r>"<CR>
vnoremap <silent> <leader>ff y:Rg <C-r>"<CR>

" Advanced ripgrep integration https://github.com/junegunn/fzf.vim#example-advanced-ripgrep-integration
" and shortening long paths https://github.com/junegunn/fzf.vim/issues/1171
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

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
nnoremap <leader>f~ :call <SID>escape_abnormal_buf_and('Cd!')<CR>
nnoremap <leader>fpr :call <SID>escape_abnormal_buf_and('FZF ~/projects')<CR>
nnoremap <leader>fpl :call <SID>escape_abnormal_buf_and('FZF ~/.vim/plugged')<CR>

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

"
" fzf TOC
"

" Forked https://github.com/preservim/vim-markdown
" and left only functions and commands for :Toc.
Plug 'Sangdol/vim-markdown'

" selected: ["<line number>: header"]
function! s:fzf_toc_handler(selected) abort
  let line_number = split(a:selected[0], ':')[0]

  " This doesn't work when moving upward.
  " Why?
  "execute line_number

  execute 'normal' line_number .. 'G'
endfunction

function! s:fzf_md_toc() abort
  try
    :Toc
  catch /^Vim\%((\a\+)\)\=:E492/
    " No :Toc command
    return
  endtry
  wincmd p

  let loclist = getloclist(0)
  :lclose

  let lines = map(loclist, 'printf("%s:\t%s", v:val["lnum"], v:val["text"])')

  call fzf#run({
  \ 'source':  lines,
  \ 'sink*': function('s:fzf_toc_handler')
  \})
endfunction

function! s:fzf_marker_toc() abort
  :vimgrep /\s{{{1/j %
  wincmd p

  let list = getqflist()
  :cclose

  let lines = map(list, 'printf("%s:\t%s", v:val["lnum"], v:val["text"])')

  call fzf#run({
  \ 'source':  lines,
  \ 'sink*': function('s:fzf_toc_handler')
  \})
endfunction

function! s:fzf_toc(...) abort
  if &filetype == 'markdown'
    call s:fzf_md_toc()
  elseif &filetype == 'vim'
    call s:fzf_marker_toc()
  else
    echom 'No TOC for the current filetype.'
  endif
endfunction

nnoremap <leader>so :call <SID>escape_abnormal_buf_and('call <sid>fzf_toc()')<CR>

" Can't I open Toc with a fix size?
nnoremap <leader>sn :Toc<CR>:resize 1<cr>j<cr>:lclose<cr>
nnoremap <leader>sp :Toc<CR>:resize 1<cr>k<cr>:lclose<cr>

"}}}

"
" NerdCommenter {{{1
"
Plug 'scrooloose/nerdcommenter'

nmap <silent> <C-_> <plug>NERDCommenterToggle
vmap <silent> <C-_> <plug>NERDCommenterToggle

" C-/ is needed for nvim 0.7.0+
nmap <silent> <C-/> <plug>NERDCommenterToggle
vmap <silent> <C-/> <plug>NERDCommenterToggle

let g:NERDCreateDefaultMappings = 0

"}}}

"
" Syntax highlight {{{1
"

Plug 'MTDL9/vim-log-highlighting'
Plug 'GEverding/vim-hocon'
Plug 'dag/vim-fish'

"}}}
