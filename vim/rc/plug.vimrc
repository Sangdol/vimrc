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

" This has to come after `plug#end()` to be able to use colorscheme installed
" by Plug.
colorscheme Tomorrow-Night-Bright

" Things that have to be executed after `plug#end()` and colorscheme.
" https://github.com/junegunn/vim-plug/issues/702#issuecomment-787503301
call TriggerPlugCallbacks()

"}}}
