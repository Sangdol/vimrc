"
" Clojure: Conjure, parinfer {{{1
"
" Conjure
"   Interactive evaluation for Neovim (Clojure, Fennel, Janet, Racket, Hy, MIT Scheme, Guile)
"
Plug 'Olical/conjure'
Plug 'Sangdol/vim-parinfer' " Forked to change mappings
Plug 'junegunn/rainbow_parentheses.vim'

" turn on by default
augroup rainbow_lisp
  autocmd!
  autocmd FileType lisp,clojure,scheme,racket RainbowParentheses
augroup END

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
nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]g <Plug>(coc-diagnostic-next)

nnoremap <silent> [e <Plug>(coc-diagnostic-prev-error)
nnoremap <silent> ]e <Plug>(coc-diagnostic-next-error)

" GoTo code navigation.
nnoremap <silent> <leader>sd <Plug>(coc-definition)
nnoremap <silent> <leader>sy <Plug>(coc-type-definition)
nnoremap <silent> <leader>si <Plug>(coc-implementation)
nnoremap <silent> <leader>sr <Plug>(coc-references)
nnoremap <silent> <leader>so :CocList outline<CR>
nnoremap <silent> <leader>sa :CocList diagnostics<CR>

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
nnoremap <leader>re <Plug>(coc-rename)

"}}}

"
" Python {{{1
"

" Semantic Highlighting for Python in Neovim
" Do `pip3 install pynvim --upgrade`
" E117: Unknown function: SemshiBufWipeout #60 => :UpdateRemotePlugins
" https://github.com/numirias/semshi/issues/60
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }

autocmd FileType python nnoremap <buffer> <leader>re :Semshi rename<CR>

" All in one like IntelliJ F2
function! SemshiNext()
  execute('Semshi goto parameterUnused first')
  execute('Semshi goto unresolved first')
  execute('Semshi goto error')
endfunction

autocmd FileType python nnoremap <buffer> <leader>ee :call SemshiNext()<CR>

" Poet-v: Poetry and Pipenv integration
Plug 'petobens/poet-v'

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
