"
" Plugins used for coding
"

"
" Vimspector {{{1
"
Plug 'puremourning/vimspector'

let g:vimspector_enable_mappings='HUMAN'

"}}}

"
" copilot {{{1
"
Plug 'github/copilot.vim'

nnoremap <leader>ce :Copilot enable<cr>
nnoremap <leader>cd :Copilot disable<cr>
nnoremap <leader>cs :Copilot status<cr>

"}}}

"https://hiring.api.synthesia.io
" nvim-treesitter {{{1
"
" :TSInstall <language_to_install>
" :TSUninstall <language_to_uninstall>
" :TSUpdate
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" This will generate error if it's executed before treesitter is installed.
" Restarting vim would fix the issue.
lua << EOF
  table.insert(plugin_callbacks, function()
    require'nvim-treesitter.configs'.setup {
      -- One of "all", "maintained" (parsers with maintainers), or a list of languages
      ensure_installed = "all",

      -- Install languages synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- markdown is slow and highlights are not great
      ignore_install = { "markdown" },

      highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- list of language that will be disabled
        disable = {},

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },
    }
  end)
EOF

" Dim
Plug 'neovim/nvim-lspconfig'
Plug 'narutoxy/dim.lua'

lua << EOF
  table.insert(plugin_callbacks, function()
    require('dim').setup({})
  end)
EOF

"}}}

"
" Clojure: Conjure, parinfer {{{1
"
" Conjure
"   Interactive evaluation for Neovim (Clojure, Fennel, Janet, Racket, Hy, MIT Scheme, Guile)
"
Plug 'Olical/conjure'
Plug 'Sangdol/vim-parinfer' " Forked to change mappings
Plug 'junegunn/rainbow_parentheses.vim'

let g:conjure#mapping#prefix = "<leader>z"
let g:conjure#filetypes = ["clojure", "racket", "scheme"]

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
nnoremap <silent> <leader>sz :call CocActionAsync('jumpDefinition', 'tab drop')<CR>

" Code actions (quickfix) e.g., import
nmap <leader>sc  <Plug>(coc-codeaction-line)

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

" coc-fzf
Plug 'antoinemadec/coc-fzf'

autocmd FileType python,lua,scala,javascript,clojure
      \| nnoremap <buffer><silent> <leader>sf :CocFzfList<CR>
      \| nnoremap <buffer><silent> <leader>so :CocFzfList outline<CR>
      \| nnoremap <buffer><silent> <leader>sa :CocFzfList diagnostics<CR>
      \| nnoremap <buffer><silent> <leader>ss :CocFzfList symbols<CR>

let g:coc_global_extensions = [
    \'coc-conjure',
    \'coc-json',
    \'coc-lua',
    \'coc-metals',
    \'coc-syntax',
    \'coc-ultisnips',
    \'coc-vimlsp',
    \'coc-word',
    \'coc-pyright',
    \'coc-emoji',
    \'coc-tsserver',
    \]

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

autocmd FileType python nnoremap <buffer> <leader>re yiw:Semshi rename<CR><C-r>+<C-f>

" All in one like IntelliJ F2
function! SemshiNext()
  execute('Semshi goto parameterUnused first')
  execute('Semshi goto unresolved first')
  execute('Semshi goto error')
endfunction

autocmd FileType python nnoremap <buffer> <leader>ee :call SemshiNext()<CR>

" Poet-v: Poetry and Pipenv integration
Plug 'petobens/poet-v', { 'for': 'python' }

" Black
Plug 'psf/black', { 'branch': 'stable' }

augroup black_on_save
  autocmd!
  autocmd BufWritePre *.py Black
augroup end

Plug 'nvie/vim-flake8'

augroup flake8_on_save
  autocmd!
  autocmd BufWritePost *.py call flake8#Flake8()
augroup end

Plug 'alfredodeza/pytest.vim'

nnoremap <silent> <leader>xt :Pytest file<CR>
nnoremap <silent> <leader>xs :Pytest session<CR>

Plug 'python-rope/ropevim', {'do': './install-rope.sh'}

"}}}
