"
" Sang's Vim Configuration
"
source $HOME/.vim/rc/set.vimrc
source $HOME/.vim/rc/statusline.vimrc
source $HOME/.vim/rc/utility.vimrc
source $HOME/.vim/rc/autocmd.vimrc
source $HOME/.vim/rc/functions.vimrc
source $HOME/.vim/rc/mappings.vimrc
source $HOME/.vim/rc/plug.vimrc
source $HOME/.vim/rc/highlight.vimrc " This has to come after plug.vimrc.

let s:device_local_vimrc = '$HOME/.vim/rc/device_local.vimrc'
if filereadable(expand(s:device_local_vimrc))
  execute 'source ' .. s:device_local_vimrc
endif
