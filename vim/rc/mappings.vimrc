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

" Line up/down
" https://vim.fandom.com/wiki/Moving_lines_up_or_down
nnoremap <DOWN> :m .+1<CR>==
nnoremap <UP> :m .-2<CR>==
vnoremap <DOWN> :m '>+1<CR>gv=gv
vnoremap <UP> :m '<-2<CR>gv=gv

"}}}

"
" Tab {{{1
"

" Next / prev tab
nnoremap <silent> <C-k> :tabnext<CR>
nnoremap <silent> <C-j> :tabprevious<CR>

" New Tab
nnoremap <silent> <Leader>l :tabnew<CR>

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
inoremap jl <Esc>
inoremap j; <Esc>O
inoremap j' <Esc>o

"}}}

"
" Buffer and windows {{{1
"

" Move between windows
let i = 1
while i <= 6
  execute 'nnoremap <Leader>' . i . ' :' . i . 'wincmd w<CR>'
  let i = i + 1
endwhile

" Close windows
let i = 1
while i <= 6
  execute 'nnoremap <Leader>c' . i . ' :' . i . 'wincmd w<CR>:q<CR>'
  let i = i + 1
endwhile

" Easy buffer switch
nnoremap <silent> <Leader>;; :b#<CR>

" Open new window
nnoremap <Leader>wh :leftabove vnew<CR>
nnoremap <Leader>wl :rightbelow vertical new<CR>
nnoremap <Leader>wj :below new<CR>
nnoremap <Leader>wk :topleft new<CR>

" Close (wq is hard to type)
nnoremap <leader>we :wq<CR>
nnoremap <leader>ww :wqa<CR>

" Mostly for git commit message windows
inoremap ;we <ESC>:wq<CR>

" Save
nnoremap <Leader>q :q<CR>

" Horizontal resize with Repeat
nmap <leader>w< <Plug>DecreaseWindowWidth
nmap <leader>w> <Plug>IncreaseWindowWidth
nnoremap <Plug>DecreaseWindowWidth 3<C-w><
  \ :call repeat#set("\<Plug>DecreaseWindowWidth")<CR>
nnoremap <Plug>IncreaseWindowWidth 3<C-w>>
  \ :call repeat#set("\<Plug>IncreaseWindowWidth")<CR>

" Insert mode scroll
inoremap ;zt <ESC>zti
inoremap ;zz <ESC>zzi
inoremap ;z- <ESC>z-i

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

"
" Terminal {{{1
"
" https://github.com/neovim/neovim/issues/3192
nnoremap <Leader>ti :terminal<CR>
nnoremap <Leader>th :leftabove vertical split \| terminal<CR>
nnoremap <Leader>tl :rightbelow vertical split \| terminal<CR>
nnoremap <Leader>tj :below split \| terminal<CR>
nnoremap <Leader>tk :topleft split \| terminal<CR>
nnoremap <Leader>tt :tabnew \| terminal<CR>
tnoremap jl <C-\><C-n>

"}}}

"
" Etc. {{{1
"

nnoremap <silent> <Leader>n :noh<CR>

" Help
command -narg=1 -complete=help Hv vert help <args>
command -narg=1 -complete=help Ht tab help <args>

" Mistake proofing
" https://stackoverflow.com/questions/10590165/is-there-a-way-in-vim-to-make-w-to-do-the-same-thing-as-w
command! -nargs=* W w <args>
command! -bang Q q<bang>
command! Wa wa
command! Wq wq
command! Qa qa
command! Wqa wqa

" Diff shortcuts
nnoremap <silent> <Leader>dl :diffthis<CR> <C-w>l :diffthis<CR> <C-w>h
nnoremap <silent> <Leader>dh :diffthis<CR> <C-w>h :diffthis<CR> <C-w>l
nnoremap <silent> <leader>do :diffoff<CR>

" Edit vimrc
nnoremap <silent> <Leader>vv :tabnew<CR>:e ~/.vimrc<CR>
nnoremap <silent> <Leader>vp :tabnew<CR>:e ~/.vim/rc/plug.vimrc<CR>
nnoremap <silent> <Leader>vm :tabnew<CR>:e ~/.vim/rc/mappings.vimrc<CR>
nnoremap <silent> <Leader>vf :tabnew<CR>:e ~/.vim/rc/functions.vimrc<CR>
nnoremap <silent> <Leader>vs :tabnew<CR>:e ~/.vim/rc/set.vimrc<CR>
nnoremap <Leader>vr :source ~/.vimrc<CR>

" To navigate the nvim runtime directory
nnoremap <silent> <Leader>vx :tabnew<CR>:e $VIMRUNTIME/filetype.vim<CR>

" Toggle invisibles
set lcs=tab:›\ ,trail:·,eol:¬,nbsp:_
set fcs=fold:-
nnoremap <silent> <leader>i :set nolist!<CR>

" Save with root permission inside Vim
cmap w!! w !sudo tee > /dev/null %

" Spell check
nnoremap <Leader><Leader>s :set spell!<CR>

" qq to record, Q to replay
nnoremap Q @q

"}}}
