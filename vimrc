"
" Sang's Vim Configuration
"
source $HOME/.vim/rc/set.vimrc
source $HOME/.vim/rc/utility.vimrc
source $HOME/.vim/rc/autocmd.vimrc
source $HOME/.vim/rc/functions.vimrc
source $HOME/.vim/rc/mappings.vimrc

"
" Vim Plug {{{1
"
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

source $HOME/.vim/rc/plug.vimrc

if has("mac")
  " things not needed in servers
  source $HOME/.vim/rc/plugmac.vimrc
endif

" Automatically install missing plugins on startup
let g:plugs_missing = filter(values(g:plugs), '!isdirectory(v:val.dir)')
if len(g:plugs_missing) > 0
  PlugInstall --sync | q
endif

call plug#end()

" Lua modules have to be loaded after `plug#end()`
" since the `end()` function updates `&runtimepath`. 
call LoadWhichKey()

" This has to run after `plug#end()` for `coloescheme`.
" https://github.com/junegunn/vim-plug/issues/124
source $HOME/.vim/rc/style.vimrc

