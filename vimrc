"
" Sang's Vim Configuration
"
source $HOME/.vim/rc/set.vimrc
source $HOME/.vim/rc/utility.vimrc
source $HOME/.vim/rc/autocmd.vimrc
source $HOME/.vim/rc/functions.vimrc
source $HOME/.vim/rc/mappings.vimrc

let s:device_local_vimrc = '$HOME/.vim/rc/device_local.vimrc'
if filereadable(expand(s:device_local_vimrc))
  execute 'source ' .. s:device_local_vimrc
endif

source $HOME/.vim/rc/plug.vimrc

" This has to run after `plug#end()` for `coloescheme`.
" https://github.com/junegunn/vim-plug/issues/124
source $HOME/.vim/rc/style.vimrc

" Things that have to be executed after `plug#end()` and colorscheme.
" https://github.com/junegunn/vim-plug/issues/702#issuecomment-787503301
call TriggerPlugCallbacks()
