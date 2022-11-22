"
" Vim Plug
"
" Plug Commands:
"   PlugUpdate [name ...]
"   PlugInstall [name ...]
"   PlugClean[!]
"   PlugUpgrade
"   PlugStatus
"
" Keybindings:
"   D - PlugDiff
"   S - PlugStatus
"   R - Retry failed update or installation tasks
"   U - Update plugins in the selected range
"   q - Close the window
"   :PlugStatus => L - Load plugin
"   :PlugDiff => X - Revert the update

nnoremap <leader>ps :PlugStatus<cr>
nnoremap <leader>pu :PlugUpdate<cr>
nnoremap <leader>pi :PlugInstall<cr>
nnoremap <leader>pc :PlugClean<cr>

"
" Setup {{{1
"

" Callbacks for code locality.
" Lua `require` calls are added to this global variable.
lua << EOF
  plugin_callbacks = {}
EOF

function! s:triggerPlugCallbacks() abort
lua << EOF
  for _, func in ipairs(plugin_callbacks) do
    func()
  end
EOF
endfunction

" Edit vimrc
nnoremap <silent> <Leader>vp :tabnew<CR>:e ~/.vim/rc/plugins.vim<CR>
nnoremap <silent> <Leader>vd :tabnew<CR>:e ~/.vim/rc/devplugins.vim<CR>
nnoremap <silent> <Leader>vm :tabnew<CR>:e ~/.vim/rc/mappings.vim<CR>
nnoremap <silent> <Leader>vl :tabnew<CR>:e ~/.vim/rc/device_local.vim<CR>
nnoremap <Leader>vr :source ~/.vimrc<CR>

" Help
function! s:plug_doc()
  let name = matchstr(getline('.'), '^- \zs\S\+\ze:')
  if has_key(g:plugs, name)
    for doc in split(globpath(g:plugs[name].dir, 'doc/*.txt'), '\n')
      execute 'tabe' doc
    endfor
  endif
endfunction

augroup PlugHelp
  autocmd!
  autocmd FileType vim-plug nnoremap <buffer> <silent> H :call <sid>plug_doc()<cr>
augroup END

"}}}

"
" Loading {{{1
"
call plug#begin('~/.vim/plugged')

source $HOME/.vim/rc/plugins.vim

if has("mac")
  " things not needed in servers
  source $HOME/.vim/rc/devplugins.vim
endif

call plug#end()

"}}}

"
" After {{{1
"

" Automatically install missing plugins on startup
let g:plugs_missing = filter(values(g:plugs), '!isdirectory(v:val.dir)')
if len(g:plugs_missing) > 0
  PlugInstall --sync | q
endif

" Things that have to be executed after `plug#end()`.
" The idea is from https://github.com/junegunn/vim-plug/issues/702#issuecomment-787503301
call s:triggerPlugCallbacks()

"}}}
