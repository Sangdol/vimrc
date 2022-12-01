"
" Mappings
"

"
" Moving {{{1
"
" Default mappings
"  % - move to matching bracket

" Emacs-like moving / editing
inoremap <C-e> <Esc>A
inoremap <C-a> <Esc>I
inoremap <C-b> <C-o>h
inoremap <C-f> <C-o>l
inoremap <C-d> <C-o>x

" Line up/down/left/right
" https://vim.fandom.com/wiki/Moving_lines_up_or_down
nnoremap <silent> <C-j> :m .+1<CR>==
nnoremap <silent> <C-k> :m .-2<CR>==
vnoremap <silent> <C-j> :m '>+1<CR>gv=gv
vnoremap <silent> <C-k> :m '<-2<CR>gv=gv
nnoremap <silent> <C-h> <<
nnoremap <silent> <C-l> >>

" No indentation
autocmd FileType markdown
      \ nnoremap <silent> <buffer> <C-j> :m .+1<CR>
      \| nnoremap <silent> <buffer> <C-k> :m .-2<CR>
      \| vnoremap <silent> <buffer> <C-j> :m '>+1<CR>
      \| vnoremap <silent> <buffer> <C-k> :m '<-2<CR>

" Cursor in the middle at the bottom
nnoremap G Gzz

" Up and down are more logical with g..
nnoremap <silent> k gk
nnoremap <silent> j gj
vnoremap <silent> k gk
vnoremap <silent> j gj

nnoremap <silent> gk k
nnoremap <silent> gj j
vnoremap <silent> gk k
vnoremap <silent> gj j

" Easy escape
inoremap jk <Esc>
inoremap jl <Esc>O
inoremap j; <Esc>o
inoremap j' <Esc>o

"}}}

"
" Quickfix, location list {{{!
"

nnoremap ]q :cnext<cr>zz
nnoremap [q :cprev<cr>zz
nnoremap ]l :lnext<cr>zz
nnoremap [l :lprev<cr>zz

autocmd FileType qf 20wincmd_
autocmd FileType qf nnoremap <silent> <buffer> <leader>w0 :resize 20<CR>

function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

nnoremap <silent> <leader>wf :call ToggleQuickFix()<cr>

"}}}

"
" Tab {{{1
"

" Numbering
for i in range(1, 8)
  exec 'nnoremap ' .. i .. ', ' .. i .. 'gt'
endfor

" Go to last active tab (from https://superuser.com/a/675119/81915)
" :tablast can't be used to go back and forth
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <M-t> :exe "tabn ".g:lasttab<cr>
tnoremap <M-t> <C-\><C-n>:exe "tabn ".g:lasttab<cr>

" Next / prev tab
nnoremap <silent> <UP> :tabnext<CR>
nnoremap <silent> <DOWN> :tabprevious<CR>
inoremap <silent> <UP> <ESC>:tabnext<CR>
inoremap <silent> <DOWN> <ESC>:tabprevious<CR>

" Move
nnoremap <M-l> :tabmove +1<CR>
nnoremap <M-h> :tabmove -1<CR>

" New Tab
nnoremap <silent> <Leader>l :tabnew<CR>

"}}}

"
" Buffer and windows {{{1
"

" Window horizontal resize
nnoremap <silent> <leader>w0 :resize<CR>
nnoremap <silent> <leader>w1 :exec 'resize ' float2nr(&lines * 0.9)<CR>
nnoremap <silent> <leader>w2 :exec 'resize ' (&lines / 2)<CR>
nnoremap <silent> <leader>w3 :exec 'resize ' (&lines / 3)<CR>
nnoremap <silent> <leader>w4 :exec 'resize ' (&lines / 4)<CR>

" Switch and close windows
for i in range(1, 6)
  execute 'nnoremap <silent> <leader>' . i . ' :' . i . 'wincmd w<CR>'
  execute 'nnoremap <silent> ' . i . '<Leader> :' . i . 'wincmd w<CR>'
  execute 'nnoremap <silent> 'i . '<BS> :' . i . 'wincmd c<CR>'
endfor

" Go to last window
nnoremap <Leader><Leader> :wincmd l<CR>

function! s:close_last_window()
  execute FocusableWinCount() .. 'wincmd c'
endfunction
nnoremap <Leader><BS> :call <SID>close_last_window()<CR>

function! CloseVisibleWindows()
  for i in range(1, FocusableWinCount())
    " Keep closing the first windows
    " This shouldn't go backward since Nerdtree or Voom windows
    " could be closed automatically which cause it to try to close
    " other buffers.
    1wincmd q
  endfor
endfunction

nnoremap <silent> <Leader>wc :call CloseVisibleWindows()<CR>

" Easy buffer switch
nnoremap <silent> <Leader>;; :b#<CR>

" Open new window
nnoremap <Leader>wh :leftabove vnew<CR>
nnoremap <Leader>wl :rightbelow vertical new<CR>
nnoremap <Leader>wj :below new<CR>
nnoremap <Leader>wk :topleft new<CR>

" Duplicate windows
nnoremap <Leader>wdl :call <SID>close_abnormal_buf_and(':rightbelow vertical new \| :b#')<cr>
nnoremap <Leader>wdh :call <SID>close_abnormal_buf_and(':leftabove vnew \| :b#')<cr>
nnoremap <Leader>wdj :call <SID>close_abnormal_buf_and(':below new \| :b#')<cr>
nnoremap <Leader>wdk :call <SID>close_abnormal_buf_and(':topleft new \| :b#')<cr>
nnoremap <Leader>wdt :call <SID>close_abnormal_buf_and(':tabnew \| :b#')<cr>

" Close abnormal window first to make more space
function! s:close_abnormal_buf_and(cmd)
  if FocusableWinCount() > 1 && !empty(getwinvar(1, '&buftype'))
    1wincmd c
  endif

  execute(a:cmd)
endfunction

nnoremap <leader>u :update<CR>
nnoremap <leader>wa :wa<CR>
nnoremap <leader>ww :w<CR>
" Write and quit = ZZ
nnoremap <leader>we :x<CR>

" Mostly for git commit message windows
inoremap ;we <ESC>:x<CR>

function! s:prettify_term_bufname() abort
  if !exists('b:term_bufname')
    let b:term_bufname = bufname()
  endif

  if exists('b:term_title')
    " Need a randome number to avoid bufname conflicts
    let rand = rand() % 1000
    execute 'file '..rand..' '..b:term_title
  endif
endfunction

function! s:revert_term_bufname() abort
  let buffers = nvim_list_bufs()

  for buf in buffers
    if nvim_buf_is_loaded(buf) && nvim_buf_get_option(buf, 'buftype') == 'terminal'
      try
        let name = nvim_buf_get_var(buf, 'term_bufname')
        let current_buf = bufnr('%')
        execute buf..'bufdo! file '..name
        execute 'b' current_buf
      catch
        echom 'buf'..buf.. ' has no term_bufname.'
      endtry
    endif
  endfor
endfunction

autocmd TermLeave * call s:prettify_term_bufname()

" ScrollViewDisable is needed due to the scrollview and nvim bug
" Always store the session in the directory where the vim is started.
nnoremap <leader>wqq :call <SID>revert_term_bufname()
      \ \| ScrollViewDisable
      \ \| exec 'mksession! ' .. $PWD .. '/' .. '.vimsession'
      \ \| wa
      \ \| qa<cr>

" Quick (`close` doesn't work well with floating windows)
" https://github.com/dstein64/nvim-scrollview/issues/10
nnoremap <silent> <Leader>q :q<CR>

" Horizontal resize with Repeat
nmap <C-w>< <Plug>DecreaseWindowWidth
nmap <C-w>> <Plug>IncreaseWindowWidth
nnoremap <Plug>DecreaseWindowWidth 3<C-w><
  \ :call repeat#set("\<Plug>DecreaseWindowWidth")<CR>
nnoremap <Plug>IncreaseWindowWidth 3<C-w>>
  \ :call repeat#set("\<Plug>IncreaseWindowWidth")<CR>

" Insert mode scroll
inoremap ;zt <ESC>zti
inoremap ;zz <ESC>zzi
inoremap ;z- <ESC>z-i

" Mistake proofing
command! -nargs=* W w <args>
command! -bang Q q<bang>
command! Wa wa
command! Wq wq
command! Qa qa
command! Wqa wqa

" Go to next window
"nnoremap <C-q> <C-w>w
"inoremap <C-q> <ESC><C-w>w

" Go to previous window
function! s:go_to_previous_window()
  let current_win = winnr()

  wincmd p

  if current_win == winnr()
    wincmd w
  endif
endfunction

nnoremap <silent> <C-q> :call <SID>go_to_previous_window()<CR>
inoremap <silent> <C-q> <ESC>:call <SID>go_to_previous_window()<CR>

" Open a file in vertical split
nnoremap <c-w>F <c-w>vgf
" Open a tag in vertical split
nnoremap <c-w>] <c-w>v<c-]>
" Open a tag in new tab
nnoremap <c-w>[ <C-w><C-]><C-w>T

"}}}

"
" Edit {{{1
"
" Default
" = - indent

" Delete all
nnoremap <silent> <Leader>dd ggdG

" Yank all
nnoremap <Leader>a :%y<CR>

" Paste in a new line
nnoremap <silent> <Leader>pp o<Esc>p

" Create Blank Newlines and stay in Normal mode
" http://superuser.com/a/607193/81915
nnoremap <silent> zj :call append(line('.'), '')<CR>
nnoremap <silent> zk :call append(line('.')-1, '')<CR>


inoremap <silent> ;zj <esc>:call append(line('.'), '')<CR>a
inoremap <silent> ;zk <esc>:call append(line('.')-1, '')<CR>a

nnoremap <silent> zh i<Space><Right><Esc>
nnoremap <silent> zl a<Space><Left><Esc>

"
" Terminal {{{1
"

" `:vertical terminal` issue https://github.com/neovim/neovim/issues/3192
nnoremap <Leader>ti :terminal<CR>
nnoremap <Leader>th :leftabove vertical split \| terminal<CR>
nnoremap <Leader>tl :rightbelow vertical split \| terminal<CR>
nnoremap <Leader>tj :below split \| terminal<CR>
nnoremap <Leader>tk :topleft split \| terminal<CR>
nnoremap <Leader>tt :tabnew \| terminal<CR>

" Avoid adding gibberish: [32;2u
tnoremap <S-Space> <Space>

" Excluding fzf floating windows
autocmd TermOpen * if bufname() !~ '\.fzf'
      \| tnoremap <buffer> <UP> <C-\><C-n>:tabnext<CR>
      \| tnoremap <buffer> <DOWN> <C-\><C-n>:tabprevious<CR>
      \| tnoremap <buffer> ;; <C-\><C-n>
      \| nnoremap <buffer> a :setlocal norelativenumber<CR>a
      \| tnoremap <buffer> <C-q> <C-\><C-n><C-w>p
      \| endif

" Enable copying from register in the fzf terminal
" https://stackoverflow.com/a/41684444/524588
autocmd! FileType fzf tnoremap <buffer> <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

"}}}

"
" Markdown {{{1
"

function! s:toggle_bullet()
  if StartsWith(trim(getline('.')), '*')
    call SubstituteLine('\v\s*\*\s', '', '')
  else
    call SubstituteLine('\v^(\s*)', '\1* ', '')
  endif
endfunction

nnoremap <leader>m* :call <SID>toggle_bullet()<CR>

" Add markdown elements
nnoremap <leader>m# m`^i### <esc>``4l
nnoremap <leader>m> m`^i> <esc>``2l

" line: * todo
" mark: v
" out:  * v todo
function! s:toggle_markdown_bullet_tick(mark)
  let l:line = getline('.')

  if l:line ==# ''
    return
  endif

  let l:bullet = trim(l:line)[0] == '*' ? '\*' : '-'

  " This got too messy with the regexes.
  if trim(getline('.')) =~ '\v^' .. l:bullet .. ' ' .. a:mark .. ' '
    " remove
    call SubstituteLine('\v(\s*' .. l:bullet .. ')\s' .. a:mark, '\1', '')
  else
    " add
    call SubstituteLine('\v(\s*' .. l:bullet .. '\s)', '\1' .. a:mark .. ' ', '')
  endif
endfunction

nnoremap <leader>mv :call <SID>toggle_markdown_bullet_tick('v')<CR>
nnoremap <leader>mx :call <SID>toggle_markdown_bullet_tick('x')<CR>

" Paste without autoindent in markdown
autocmd FileType markdown inoremap <buffer> <C-R> <C-R><C-O>

"}}}

"
" Etc. {{{1
"

nnoremap <silent> <Leader>n :noh<CR>

" star without moving cursor
" https://vi.stackexchange.com/questions/22886/how-to-highlight-all-occurrences-of-a-search-without-moving-the-cursor
nnoremap <Space>* <Cmd>let @/='\<'.expand('<cword>').'\>'<bar>set hlsearch<CR>

" For easier use of registers
nnoremap , "
vnoremap , "

" Help
command! -narg=1 -complete=help Hv vert help <args>
command! -narg=1 -complete=help Ht tab help <args>
command! -narg=1 -complete=help H tab help <args>

" Diff shortcuts
nnoremap <silent> <Leader>dl :diffthis<CR> <C-w>l :diffthis<CR> <C-w>h
nnoremap <silent> <Leader>dh :diffthis<CR> <C-w>h :diffthis<CR> <C-w>l
nnoremap <silent> <leader>do :diffoff<CR>

" To navigate the nvim runtime directory
nnoremap <silent> <Leader>vx :tabnew<CR>:e $VIMRUNTIME/filetype.vim<CR>

" Toggle invisibles
set lcs=tab:›\ ,trail:·,eol:¬,nbsp:_
set fcs=fold:-
nnoremap <silent> <leader>i :set nolist!<CR>

" Copy file path to clipboard
" https://vim.fandom.com/wiki/Get_the_name_of_the_current_file
" full path
nnoremap <Leader>e1 :call <SID>copy_path_to_clipboard("%:p")<CR>
" full directory
nnoremap <Leader>e2 :call <SID>copy_path_to_clipboard("%:p:h")<CR>
" relative path https://stackoverflow.com/questions/4525261/getting-relative-paths-in-vim
nnoremap <Leader>e3 :call <SID>copy_relative_path_to_clipboard()<CR>
" filename
nnoremap <Leader>e4 :call <SID>copy_path_to_clipboard("%:t")<CR>

function! s:copy_relative_path_to_clipboard() abort
  let path = fnamemodify(expand("%"), ":~:.")
  let @+ = path
  echom path .. ' is copied to clipboard.'
endfunction

function! s:copy_path_to_clipboard(modifiers) abort
  let path = expand(a:modifiers)
  let @+ = path
  echom path .. ' is copied to clipboard.'
endfunction

nnoremap <Leader>es :set spell!<CR>
nnoremap <Leader>et :Tab mes<CR>

" vim source
nnoremap <leader>vs :source %<CR>

"}}}
