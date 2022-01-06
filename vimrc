"
" Sang's Vim Configuration
"

source $HOME/.vim/rc/utility.vimrc
source $HOME/.vim/rc/set.vimrc
source $HOME/.vim/rc/autocmd.vimrc
source $HOME/.vim/rc/functions.vimrc
source $HOME/.vim/rc/mappings.vimrc
source $HOME/.vim/rc/style.vimrc


"
" Vim Plug {{{1
"
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

source $HOME/.vim/rc/plug.vimrc

call plug#end()
