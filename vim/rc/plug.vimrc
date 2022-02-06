"
" Vim Plug {{{1
"
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

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

source $HOME/.vim/rc/plugins.vimrc

if has("mac")
  " things not needed in servers
  source $HOME/.vim/rc/devplugins.vimrc
endif

" Automatically install missing plugins on startup
let g:plugs_missing = filter(values(g:plugs), '!isdirectory(v:val.dir)')
if len(g:plugs_missing) > 0
  PlugInstall --sync | q
endif

call plug#end()
