"
" Vim Plug
"
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'

"
" Setup {{{1
"

" Callbacks for code locality
let g:plug_callbacks = []

function! AddToPlugCallbacks(func)
  let g:plug_callbacks += [a:func]
endfunction

function! TriggerPlugCallbacks()
  for Cb in g:plug_callbacks
    try
      call Cb()
    catch
      echom 'Encountered errors when executing ' . string(Cb)
    endtry
  endfor
endfunction

" Edit vimrc
nnoremap <silent> <Leader>vv :tabnew<CR>:e ~/.vimrc<CR>
nnoremap <silent> <Leader>vp :tabnew<CR>:e ~/.vim/rc/plugins.vimrc<CR>
nnoremap <silent> <Leader>vd :tabnew<CR>:e ~/.vim/rc/devplugins.vimrc<CR>
nnoremap <silent> <Leader>vm :tabnew<CR>:e ~/.vim/rc/mappings.vimrc<CR>
nnoremap <silent> <Leader>vf :tabnew<CR>:e ~/.vim/rc/functions.vimrc<CR>
nnoremap <silent> <Leader>vs :tabnew<CR>:e ~/.vim/rc/set.vimrc<CR>
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

source $HOME/.vim/rc/plugins.vimrc

if has("mac")
  " things not needed in servers
  source $HOME/.vim/rc/devplugins.vimrc
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

" Things that have to be executed after `plug#end()` and colorscheme.
" https://github.com/junegunn/vim-plug/issues/702#issuecomment-787503301
call TriggerPlugCallbacks()

"}}}
