"
" Sang's Vim Configuration
"
source $HOME/.vim/rc/setoptions.vimrc
source $HOME/.vim/rc/statusline.vimrc
source $HOME/.vim/rc/utility.vimrc
source $HOME/.vim/rc/autocmd.vimrc
source $HOME/.vim/rc/functions.vimrc
source $HOME/.vim/rc/mappings.vimrc
source $HOME/.vim/rc/plug.vimrc
source $HOME/.vim/rc/colorscheme.vimrc " This has to come after plug.vimrc.

" For work environment configuration like GitHub Enterprise URL, etc.
let s:device_local_vimrc = '$HOME/.vim/rc/device_local.vimrc'
if filereadable(expand(s:device_local_vimrc))
  execute 'source ' .. s:device_local_vimrc
endif
