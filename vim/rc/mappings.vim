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
inoremap <C-f> <C-o>l

" Move to the end of the next/prev line
inoremap <M-n> <Esc>jA
inoremap <M-p> <Esc>kA

" Line left/right
" https://vim.fandom.com/wiki/Moving_lines_up_or_down
nnoremap <silent> <M-h> <<
nnoremap <silent> <M-l> >>
" Move and stay in visual mode
vnoremap <silent> <M-h> <gv
vnoremap <silent> <M-l> >gv

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

" Numbering with <C-n>
for i in range(1, 8)
  exec 'nnoremap <C-' .. i .. '> ' .. i .. 'gt'
endfor
nnoremap <C-9> :tablast<CR>

" Go to last active tab (from https://superuser.com/a/675119/81915)
" :tablast can't be used to go back and forth
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <M-t> :exe "tabn ".g:lasttab<cr>
tnoremap <M-t> <C-\><C-n>:exe "tabn ".g:lasttab<cr>

" Next / prev tab
nnoremap <silent> <C-j> :tabnext<CR>
inoremap <silent> <C-j> <ESC>:tabnext<CR>
nnoremap <silent> <C-h> :tabprevious<CR>
inoremap <silent> <C-h> <ESC>:tabprevious<CR>

" Move
nnoremap <leader>el :<C-u>execute 'tabmove +' . v:count1<CR>
nnoremap <leader>eh :<C-u>execute 'tabmove -' . v:count1<CR>

" New Tab
nnoremap <silent> <Leader>l :tabnew<CR>

"}}}

"
" Buffer and windows {{{1
"

" Window vertical resize
nnoremap <silent> <leader>w0 :resize<CR>
nnoremap <silent> <leader>w1 :exec 'resize ' float2nr(&lines * 0.9)<CR>
nnoremap <silent> <leader>w2 :exec 'resize ' (&lines / 2)<CR>
nnoremap <silent> <leader>w3 :exec 'resize ' (&lines / 3)<CR>
nnoremap <silent> <leader>w4 :exec 'resize ' (&lines / 4)<CR>

" Switch and close windows
for i in range(1, 6)
  execute 'nnoremap <silent> <leader>' . i . ' :' . i . 'wincmd w<CR>'
  execute 'nnoremap <silent> 'i . '<BS> :' . i . 'wincmd c<CR>'
endfor

" Use <M-1> to <M-6> to switch to the first to the sixth window
for i in range(1, 6)
  execute 'nnoremap <silent> <M-' . i . '> :' . i . 'wincmd w<CR>'
endfor

" Go to the last window
nnoremap <Leader><Leader> :execute FocusableWinCount() . 'wincmd w'<CR>

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
nnoremap <Leader>wdl :rightbelow vertical new \| :b#<cr>
nnoremap <Leader>wdh :leftabove vnew \| :b#<cr>
nnoremap <Leader>wdj :below new \| :b#<cr>
nnoremap <Leader>wdk :topleft new \| :b#<cr>
nnoremap <Leader>wdt :tabnew \| :b#<cr>

nnoremap <leader>u :update<CR>
nnoremap <leader>wa :wa<CR>
" Write and quit = ZZ
nnoremap <leader>we :x<CR>

" Mostly for git commit message windows
inoremap ;we <ESC>:x<CR>

function! s:prettify_term_bufname() abort
  if !exists('b:term_bufname')
    " Store the original buffer name to restore it when a session is saved.
    let b:term_bufname = bufname()
  endif

  if exists('b:term_title')
    " Need a randome number to avoid bufname conflicts
    let rand = rand() % 1000
    let original_filename = rand.." "..b:term_title
    " Escaping vertical bars so that `:file` can take it as a whole.
    let filename = substitute(original_filename, '|', '\\|', 'g')
    " Enclosing `filename` with `"` doesn't work since `:file` doesn't want to
    " change a filename with `"` in it.
    execute 'file '.. filename 
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
nnoremap <leader>wqq :exec 'Bdelete hidden' 
      \ \| call <SID>revert_term_bufname()
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
inoremap ;zt <ESC>zta
inoremap ;zz <ESC>zza
inoremap ;z- <ESC>z-a

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

" Overwrite the entire buffer with whatever is in the unnamed register
nnoremap cP gg"_dGP

" Delete all
nnoremap <silent> <Leader>dd ggdG

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

" To use undo in the terminal
tnoremap <[47;5u> <C-_>

" Korean input
tnoremap <C-ㅁ> <C-a>
tnoremap <C-ㅠ> <C-b>
tnoremap <C-ㅊ> <C-c>
tnoremap <C-ㅇ> <C-d>
tnoremap <C-ㄷ> <C-e>
tnoremap <C-ㄹ> <C-f>
tnoremap <C-ㅎ> <C-g>
tnoremap <C-ㅗ> <C-h>
tnoremap <C-ㅑ> <C-i>
tnoremap <C-ㅓ> <C-j>
tnoremap <C-ㅏ> <C-k>
tnoremap <C-ㅣ> <C-l>
tnoremap <C-ㅡ> <C-m>
tnoremap <C-ㅜ> <C-n>
tnoremap <C-ㅐ> <C-o>
tnoremap <C-ㅔ> <C-p>
tnoremap <C-ㅂ> <C-q>
tnoremap <C-ㄱ> <C-r>
tnoremap <C-ㄴ> <C-s>
tnoremap <C-ㅅ> <C-t>
tnoremap <C-ㅕ> <C-u>
tnoremap <C-ㅍ> <C-v>
tnoremap <C-ㅈ> <C-w>
tnoremap <C-ㅌ> <C-x>
tnoremap <C-ㅛ> <C-y>
tnoremap <C-ㅋ> <C-z>

" Excluding fzf floating windows 
autocmd TermOpen * if bufname() !~ '\.fzf'
      \| tnoremap <buffer> <C-j> <C-\><C-n>:tabnext<CR>
      \| tnoremap <buffer> <C-h> <C-\><C-n>:tabprevious<CR>
      \| tnoremap <buffer> ;; <C-\><C-n>
      \| tnoremap <buffer> <C-q> <C-\><C-n><C-w>p
      \| for i in range(1, 8) |
      \    execute 'tnoremap <buffer> <C-' . i . '> <C-\><C-n>' . i . 'gt' |
      \  endfor
      \| tnoremap <buffer> <C-9> <C-\><C-n>:tablast<CR>
      \| nnoremap <buffer> a :setlocal norelativenumber<CR>a
      \| endif

" Enable copying from register in the fzf terminal
" https://stackoverflow.com/a/41684444/524588
" https://github.com/junegunn/fzf.vim/issues/672 - another approach
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
vnoremap <leader>m* :call <SID>toggle_bullet()<CR>

" Add markdown elements
nnoremap <leader>m# m`^i### <esc>``4l
nnoremap <leader>m> m`^i> <esc>``2l
xnoremap <leader>m> :s/^/> /<CR>

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
" Yank {{{1
"

" Yank all
nnoremap <Leader>aa :%y<CR>

" Copy file path to clipboard
" https://vim.fandom.com/wiki/Get_the_name_of_the_current_file
" full path
nnoremap <Leader>a1 :call <SID>copy_path_to_clipboard("%:p")<CR>
" full directory
nnoremap <Leader>a2 :call <SID>copy_full_path_to_clipboard_with_line()<CR>
vnoremap <Leader>a2 :<C-U>call <SID>copy_full_path_to_clipboard_with_line(1)<CR>
" relative path https://stackoverflow.com/questions/4525261/getting-relative-paths-in-vim
nnoremap <Leader>a3 :call <SID>copy_relative_path_to_clipboard()<CR>
" filename
nnoremap <Leader>a4 :call <SID>copy_path_to_clipboard("%:t")<CR>

" not used atm
function! s:copy_relative_path_to_clipboard_with_line() abort
  let path = fnamemodify(expand("%"), ":~:.") . ':' . line('.')
  let @+ = path
  echom path . ' is copied to clipboard.'
endfunction

function! s:copy_relative_path_to_clipboard() abort
  let path = fnamemodify(expand("%"), ":~:.")
  let @+ = path
  echom path .. ' is copied to clipboard.'
endfunction

function! s:copy_full_path_to_clipboard_with_line(...) abort
  let path = expand('%:p')
  
  " Check if called from visual mode (parameter passed) or detect via visualmode()
  let from_visual = a:0 > 0 ? a:1 : 0
  
  if from_visual
    " Get visual selection marks
    let start_line = line("'<")
    let end_line = line("'>")
    
    if start_line == end_line
      let path = path . ':' . start_line
    else
      let path = path . ':' . start_line . '-' . end_line
    endif
  else
    " Normal mode - just use current line
    let path = path . ':' . line('.')
  endif
  
  let @+ = path
  echom path . ' is copied to clipboard.'
endfunction

function! s:copy_path_to_clipboard(modifiers) abort
  let path = expand(a:modifiers)
  let @+ = path
  echom path .. ' is copied to clipboard.'
endfunction

"}}}

"
" Task Management {{{1
"

" Create markdown-specific mappings
augroup MarkdownTaskManagement
  autocmd!
  " Move current markdown file to done, hold, ongoin subdirectory (markdown files only)
  autocmd FileType markdown nnoremap <buffer> <leader>zd :call <SID>MoveFileToSubdir('done')<CR>
  autocmd FileType markdown nnoremap <buffer> <leader>zh :call <SID>MoveFileToSubdir('hold')<CR>
  autocmd FileType markdown nnoremap <buffer> <leader>zo :call <SID>MoveFileToSubdir('ongoing')<CR>
augroup END

" Function to move file to a subdirectory
function! s:MoveFileToSubdir(subdir) abort
  let l:current_file = expand('%:p')
  if empty(l:current_file)
    echohl ErrorMsg | echo "No file in current buffer" | echohl None
    return
  endif
  
  let l:parent_dir = expand('%:p:h:h')  " Parent of current file's directory
  let l:target_dir = l:parent_dir . '/' . a:subdir
  let l:filename = expand('%:t')
  let l:target_file = l:target_dir . '/' . l:filename
  
  " Create target directory if it doesn't exist
  if !isdirectory(l:target_dir)
    call mkdir(l:target_dir, 'p')
  endif
  
  " Move the file
  let l:cmd = 'mv ' . shellescape(l:current_file) . ' ' . shellescape(l:target_file)
  let l:result = system(l:cmd)
  
  if v:shell_error
    echohl ErrorMsg | echo "Failed to move file: " . l:result | echohl None
    return
  endif
  
  " Update buffer - edit the file at new location
  execute 'edit ' . fnameescape(l:target_file)
  echo "Moved to " . l:target_file
endfunction

" }}}

"
" Etc. {{{1
"

" en dash
imap <M--> –
" em dash
imap <M-_> —

" Show line numbers
nnoremap <silent> <C-s> :set number!<CR>
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
nnoremap <silent> <leader>i :set nolist!<CR>

nnoremap <Leader>es :set spell!<CR>
nnoremap <Leader>eo :syntax on<CR>

" Run scripts in the file
"   - Visually selecting all lines instead of doing ':source %'
"     to provide visual queue
autocmd FileType vim
  \  nnoremap <silent><buffer> <C-CR> yy:@"<CR>
  \| nnoremap <silent><buffer> <S-CR> ggVGy:@"<CR>
  \| inoremap <silent><buffer> <C-CR> <C-O>yy:@"<CR>
  \| inoremap <silent><buffer> <S-CR> <C-O>ggVGy:@"<CR>
  \| vnoremap <silent><buffer> <C-CR> y:@"<CR>

"}}}
