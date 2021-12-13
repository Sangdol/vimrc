"
" Mappings
"

" Copy file path to clipboard
" https://stackoverflow.com/a/954336/524588
" https://vi.stackexchange.com/a/1885/3225
" full path
noremap <silent> <F3> :let @+=expand("%:t")<CR>
" filename
noremap <silent> <F4> :let @+=expand("%:p")<CR>

"
" Moving {{{1
"
" Default mappings
"  % - move to matching bracket

" Emacs-like moving
inoremap <C-e> <Esc>A
inoremap <C-a> <Esc>I
inoremap <C-B> <C-C>bhi
inoremap <C-F> <C-C>ea

" Intellij-like Up / down
" https://vim.fandom.com/wiki/Moving_lines_up_or_down

" N.B. <C-i> conflicts with <Tab>
" - https://unix.stackexchange.com/questions/563469/conflict-ctrl-i-with-tab-in-normal-mode
nnoremap <C-i> :m .-2<CR>
nnoremap <C-u> :m .+1<CR>

"}}}

"
" Tab {{{1
"

" New Tab
nnoremap <C-t> :tabnew<CR>

" Next Tab
nnoremap <silent> <C-k> :tabnext<CR>

" Previous Tab
" N.B. <C-j> = <NL>
" - https://vi.stackexchange.com/questions/4246/what-is-the-difference-between-j-ctrl-j-nl-and-ctrl-n-in-normal-mode
nnoremap <silent> <C-j> :tabprevious<CR>

" New Tab
nnoremap <silent> <C-t> :tabnew<CR>

" Up and down are more logical with g..
nnoremap <silent> k gk
nnoremap <silent> j gj
vnoremap <silent> k gk
vnoremap <silent> j gj

nnoremap <silent> gk k
nnoremap <silent> gj j
vnoremap <silent> gk k
vnoremap <silent> gj j

inoremap <silent> <Up> <Esc>gka
inoremap <silent> <Down> <Esc>gja

" Scroll to put the searched word in the middle
map N Nzz
map n nzz

" Easy escape
inoremap jk <Esc>
inoremap jl <Esc>o
inoremap j; <Esc>O

"}}}

"
" Buffer and windows {{{1
"

" Horizontal resize mainly for nerdtree windows
nnoremap <C-a> 3<C-w><
nnoremap <C-s> 3<C-w>>

" Move between windows
let i = 1
while i <= 9
  execute 'nnoremap <Leader>' . i . ' :' . i . 'wincmd w<CR>'
  let i = i + 1
endwhile

" Close windows
let i = 1
while i <= 9
  execute 'nnoremap <Leader>c' . i . ' :' . i . 'wincmd w<CR>:q<CR>'
  let i = i + 1
endwhile

" Easy buffer switch
nnoremap <silent> <Leader>;; :b#<CR>

" Open new window
nnoremap <leader>wh :vnew<CR>
nnoremap <leader>wl :rightbelow vertical new<CR>
nnoremap <leader>wj :below new<CR>
nnoremap <leader>wk :topleft new<CR>

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

" Create Blank Newlines and stay in Normal mode
" http://superuser.com/a/607193/81915
nnoremap <silent> zj :call append(line('.'), '')<CR>
nnoremap <silent> zk :call append(line('.')-1, '')<CR>

nnoremap <silent> zh i<Space><Right><Esc>
nnoremap <silent> zl a<Space><Left><Esc>

" Save / quit
nnoremap <Leader>s :up<CR>
nnoremap <Leader>q :q<CR>

" copy without newline
" https://stackoverflow.com/questions/20165596/select-entire-line-in-vim-without-the-new-line-character
nnoremap <Leader>t yg_:echo "Copied"<CR>

"}}}

"
" Etc. {{{1
"

" Mistake proofing
cnoremap :W<CR> :w<CR>
cnoremap :Q<CR> :q<CR>
cnoremap :Q!<CR> :q!<CR>
command! Wq wq
command! Qq qa

" Diff shortcuts
nnoremap <silent> <Leader>dl :diffthis<CR> <C-w>l :diffthis<CR> <C-w>h
nnoremap <silent> <Leader>dh :diffthis<CR> <C-w>h :diffthis<CR> <C-w>l
nnoremap <silent> <leader>do :diffoff<CR>

" Edit vimrc
nnoremap <silent> <Leader>ev :tabnew<CR>:e ~/.vimrc<CR>

" Turn off highlight
nnoremap <silent> <Leader>n :noh<CR>

" Toggle invisibles
set lcs=tab:›\ ,trail:·,eol:¬,nbsp:_
set fcs=fold:-
nnoremap <silent> <leader>i :set nolist!<CR>

" Save with root permission inside Vim
cmap w!! w !sudo tee > /dev/null %

" Spell check
nnoremap <Leader><Leader>s :set spell!<CR>

"}}}
