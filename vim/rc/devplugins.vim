"
" Plugins used for coding
"

"
" copilot {{{1
"
Plug 'github/copilot.vim'

nnoremap <leader>ece :Copilot enable<cr>
nnoremap <leader>ecd :Copilot disable<cr>
nnoremap <leader>ecs :Copilot status<cr>

"}}}

"
" nvim-treesitter {{{1
"
" :TSInstall <language_to_install>
" :TSUninstall <language_to_uninstall>
" :TSUpdate
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'

" This will generate error if it's executed before treesitter is installed.
" Restarting vim would fix the issue.
lua << EOF
  table.insert(plugin_callbacks, function()
    require'nvim-treesitter.configs'.setup {
      -- One of "all", "maintained" (parsers with maintainers), or a list of languages
      ensure_installed = {'lua', 'python', 'javascript', 'ruby', 'bash', 'css', 'html', 'json', 'sql'},

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

      -- For textobjects
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ad"] = "@comment.outer",
            ["id"] = "@comment.inner",
          },

          include_surrounding_whitespace = true,
        },
      },
    }
  end)
EOF

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
" Why 's'? It's easy to type. [s]peed coc.
nmap <silent> <leader>sd <Plug>(coc-definition)
nmap <silent> <leader>sz <Plug>(coc-type-definition)
nmap <silent> <leader>si <Plug>(coc-implementation)
nmap <silent> <leader>sr <Plug>(coc-references)

" fzf help: tab drop (from telescope)
nnoremap <silent> <leader>st :call CocActionAsync('jumpDefinition', 'tab drop')<CR>
nnoremap <silent> <leader>sv :call CocActionAsync('jumpDefinition', 'vnew')<CR>

" Code actions (quickfix) e.g., import
nmap <leader>sa  <Plug>(coc-codeaction-line)

" Scroll
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Etc.
nnoremap <silent> <leader>sl :CocOutline<CR>

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

nnoremap <leader>sc :CocFzfList commands<CR>
nnoremap <leader>s! :CocRestart<CR>

autocmd FileType typescript,python,lua,javascript,clojure,vim
      \ nnoremap <buffer><silent> <leader>so :CocFzfList outline<CR>
      \| nnoremap <buffer><silent> <leader>sg :CocFzfList diagnostics<CR>
      \| nnoremap <buffer><silent> <leader>ss :CocList -I symbols<CR>
      \| nnoremap <buffer><silent> <leader>sf :CocFzfList symbols --kind Class<CR>
      \| nnoremap <buffer><silent> <leader>su :CocCommand document.showIncomingCalls<CR>

let g:coc_global_extensions = [
    \'coc-conjure',
    \'coc-json',
    \'coc-lua',
    \'coc-syntax',
    \'coc-snippets',
    \'coc-vimlsp',
    \'coc-word',
    \'coc-pyright',
    \'coc-emoji',
    \'coc-tsserver',
    \'coc-highlight',
    \'coc-calc',
    \]

"}}}

"
" vim-test {{{1
"
Plug 'tpope/vim-dispatch'
Plug 'vim-test/vim-test'

let test#strategy = "dispatch"
let test#python#runner = 'pytest'

nnoremap <silent> <leader>xt :TestNearest<CR>
nnoremap <silent> <leader>xf :TestFile<CR>
nnoremap <silent> <leader>xc :TestSuite<CR>
nnoremap <silent> <leader>xl :TestLast<CR>
" Open output in the quickfix window (Dispatch)
nnoremap <silent> <leader>xo :Copen<CR>

" }}}

"
" Python {{{1
"

" Poet-v: Poetry and Pipenv integration
"
" :PoetvActivate
" :PoetvDeactivate
Plug 'petobens/poet-v', { 'for': 'python' }

" Virtual Env
"
" TODO: customize it for me
"
" :h virtualenv
" :VirtualEnvDeactivate
" :VirtualEnvList
" :VirtualEnvActivate <name>
Plug 'jmcantrell/vim-virtualenv'

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

Plug 'python-rope/ropevim', {'do': './install-rope.sh'}

" This requires `pip install doq`
Plug 'heavenshell/vim-pydocstring', { 'do': 'make install', 'for': 'python' }

let g:pydocstring_formatter = 'google'

nmap <silent> <leader>xd <Plug>(pydocstring)
