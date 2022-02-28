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

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]e <Plug>(coc-diagnostic-next-error)

" GoTo code navigation.
nmap <silent> <leader>sd <Plug>(coc-definition)
nmap <silent> <leader>sy <Plug>(coc-type-definition)
nmap <silent> <leader>si <Plug>(coc-implementation)
nmap <silent> <leader>sr <Plug>(coc-references)
nmap <silent> <leader>so :CocList outline<CR>
nmap <silent> <leader>sa :CocList diagnostics<CR>

" Code actions e.g., import
nmap <leader>sc  <Plug>(coc-codeaction-line)

" https://github.com/neoclide/coc.nvim/issues/318
nnoremap <leader>ss :call CocActionAsync('jumpDefinition', 'tab drop')<CR>

" Scroll
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" r to open an item
nmap <silent> <leader>st :<C-u>CocCommand metals.revealInTreeView metalsPackages<CR>

" Use K to show documentation in preview window.
nmap <silent> K :call <SID>show_documentation()<CR>

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
nmap <leader>re <Plug>(coc-rename)

"}}}

"
" Scala {{{1
"

" vim-scala
Plug 'derekwyatt/vim-scala'

let g:scala_scaladoc_indent = 1

" Metals
Plug 'scalameta/coc-metals', {'do': 'yarn install --frozen-lockfile'}

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
Plug 'petobens/poet-v', { 'for': 'python' }

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
