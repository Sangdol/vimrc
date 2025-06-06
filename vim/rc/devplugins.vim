"
" Plugins used for coding 
"

"
" lsp-lens {{{1
"
Plug 'VidocqH/lsp-lens.nvim'

lua require_config('lsp-lens-config')

"
" block.nvim {{{1
"
Plug 'HampusHauffman/block.nvim'

lua require_config('block-config')

"}}}

"
" copilot {{{1
"
Plug 'github/copilot.vim'

let g:copilot_enabled = 0
function! ToggleCopilot()
    if exists("g:copilot_enabled") && g:copilot_enabled
        Copilot disable
        let g:copilot_enabled = 0
        echo "Copilot disabled"
    else
        Copilot enable
        let g:copilot_enabled = 1
        echo "Copilot enabled"
    endif
endfunction

nnoremap <leader>co :call ToggleCopilot()<CR>
nnoremap <leader>ece :Copilot enable<cr>
nnoremap <leader>ecd :Copilot disable<cr>
nnoremap <leader>ecs :Copilot status<cr>
nnoremap <leader>ecr :Copilot restart<cr>

"}}}

"
" aerial {{{1
"
" requires LSP
"
Plug 'stevearc/aerial.nvim'

lua require_config('aerial-config')

"}}}

"
" nvim-treesitter {{{1
"
" :TSInstall <language_to_install>
" :TSUninstall <language_to_uninstall>
" :TSUpdate
" :TSUpdate <target>
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-treesitter/playground'

lua require_config('treesitter-config')

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
" Why 's'? It's easy to type. [s]peed coc.
nmap <silent> <leader>sd <Plug>(coc-definition)
nmap <silent> <leader>sz <Plug>(coc-type-definition)
nmap <silent> <leader>si <Plug>(coc-implementation)
nmap <silent> <leader>sr <Plug>(coc-references)
nmap <silent> <leader>sj <Plug>(coc-float-jump)

" Copy error message to the buffer and comment it
nmap <silent> <leader>se <Plug>(coc-float-jump):%y<CR>:q<CR>P<plug>NERDCommenterToggle

" fzf help: tab drop (from telescope)
nnoremap <silent> <leader>st :call CocActionAsync('jumpDefinition', 'tab drop')<CR>
nnoremap <silent> <leader>sv :call CocActionAsync('jumpDefinition', 'vnew')<CR>

" Code actions (quickfix) e.g., import
nmap <leader>sa  <Plug>(coc-codeaction-line)

" Scroll
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Use K to show documentation in preview window.
nmap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0 || expand('%') =~# 'vim')
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute "Man " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>re <Plug>(coc-rename)

" coc-fzf
Plug 'antoinemadec/coc-fzf'

nnoremap <leader>s! :CocRestart<CR>

autocmd FileType typescript,typescriptreact,python,lua,javascript,clojure,vim
      \ nnoremap <buffer><silent> <leader>so :CocFzfList outline<CR>
      \| nnoremap <buffer><silent> <leader>vo :CocFzfList outline<CR>
      \| nnoremap <buffer><silent> <leader>sg :CocFzfList diagnostics<CR>
      \| nnoremap <buffer><silent> <leader>ss :CocFzfList symbols<CR>
      \| nnoremap <buffer><silent> <leader>sf :CocFzfList symbols --kind Class<CR>
      \| nnoremap <buffer><silent> <leader>su :CocCommand document.showIncomingCalls<CR>
      \| nnoremap <buffer><silent> gO :CocOutline<CR>

" coc-fish is only for completion
" https://github.com/oncomouse/coc-fish
"
" Excluded
" - 'coc-vimlsp' takes up more than 1 GB memory
let g:coc_global_extensions = [
    \'coc-conjure',
    \'coc-json',
    \'coc-lua',
    \'coc-syntax',
    \'coc-snippets',
    \'coc-word',
    \'coc-pyright',
    \'coc-emoji',
    \'coc-tsserver',
    \'coc-highlight',
    \'coc-calc',
    \'coc-fish',
    \'coc-prettier',
    \'coc-symbol-line'
    \]

" COC Formatter 
let g:coc_format_enabled = 1

augroup coc_format_on_save
  autocmd!
  autocmd BufWritePre *.py,*.ts if g:coc_format_enabled|call CocActionAsync('format')|endif
augroup end

nnoremap <leader>sx
      \ :let g:coc_format_enabled = !g:coc_format_enabled<CR>
      \ :echo 'coc-formatter is ' . (g:coc_format_enabled ? 'enabled' : 'disabled')<CR>

" for coc-symbol-line
lua require_config('winbar-config')

"}}}

"
" neotest {{{1
"

"   Plug 'nvim-lua/plenary.nvim'
"   Plug 'antoinemadec/FixCursorHold.nvim'
"   Plug 'nvim-neotest/neotest'
"   Plug 'nvim-neotest/neotest-python'
"   Plug 'nvim-neotest/neotest-plenary'
"
"   " For Mocha, etc.
"   " NeoTestRun != TestNearest for Mocha. TestNearest is correct.
"   Plug 'vim-test/vim-test'
"   Plug 'nvim-neotest/neotest-vim-test'
"
"   let g:test#javascript#mocha#file_pattern = '\v(spec|test)\.(ts|js)$'
"
"   lua require_config('neotest-config')
"
"   command!  -nargs=0  NeotestRun          lua  require("neotest").run.run()
"   command!  -nargs=0  NeotestRunFile      lua  require("neotest").run.run(vim.fn.expand("%"))
"   command!  -nargs=0  NeotestOutputPanel  lua  require("neotest").output_panel.open()
"   command!  -nargs=0  NeotestSummary      lua  require("neotest").summary.toggle()
"   command!  -nargs=0  NeoTestOutput       lua  require("neotest").output.open()
"
"   nnoremap <silent> <leader>xx :NeotestRun<CR>
"   nnoremap <silent> <leader>xf :NeotestRunFile<CR>
"   nnoremap <silent> <leader>xo :NeotestOutputPanel<CR>
"   nnoremap <silent> <leader>xs :NeotestSummary<CR>
"   nnoremap <silent> <leader>xp :NeoTestOutput<CR>

"}}}

"
" iron.nvim - REPL for Neovim {{{1
"
Plug 'hkupty/iron.nvim'

lua require_config('iron-config')

function! s:newline_if_line_end() abort
  " If the cursor is at the end of the line
  if col('.') + 1 == col('$')
    normal o
    startinsert
  endif
endfunction

autocmd FileType python,javascript,lua,fish,sh,zsh,typescript
      \  nnoremap <silent><buffer> <leader>zi :IronRepl<CR>
      \| nnoremap <silent><buffer> <leader>zr :IronRestart<CR>:IronRepl<CR>
      \| nnoremap <silent><buffer> <C-CR> :lua require("iron.core").send_line()<CR><CR>
      \| nnoremap <silent><buffer> <S-CR> :lua require("iron.core").send_file()<CR>
      \| inoremap <silent><buffer> <C-CR> <ESC>:lua require("iron.core").send_line()<CR>:call <SID>newline_if_line_end()<CR>
      \| inoremap <silent><buffer> <S-CR> <C-O>:lua require("iron.core").send_file()<CR>
      \| vnoremap <silent><buffer> <C-CR> y:lua require("iron.core").send(nil, vim.fn.getreg('"'))<CR>

"}}}

"
" Python {{{1
"

" Poet-v: Poetry and Pipenv integration
"
" :PoetvActivate
" :PoetvDeactivate
Plug 'petobens/poet-v', { 'on': 'PoetvActivate' }

" This requires `pip install doq`
Plug 'heavenshell/vim-pydocstring', { 'do': 'make install', 'for': 'python' }

let g:pydocstring_formatter = 'google'

nmap <silent> <leader>xd <Plug>(pydocstring)
