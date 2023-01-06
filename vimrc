"
" Sang's Vim Configuration
"
source $HOME/.vim/rc/setoptions.vim
source $HOME/.vim/rc/statusline.vim
source $HOME/.vim/rc/utility.vim
source $HOME/.vim/rc/autocmd.vim
source $HOME/.vim/rc/functions.vim
source $HOME/.vim/rc/mappings.vim
source $HOME/.vim/rc/plug.vim
source $HOME/.vim/rc/colorscheme.vim " This has to come after plug.vim.

" To avoid python provider error on virtualenv
" https://neovim.io/doc/user/provider.html
if has("mac")
  let g:python3_host_prog = '/opt/homebrew/bin/python3'
endif

" For work environment configuration like a GitHub Enterprise URL, etc.
let s:device_local_vimrc = '$HOME/.vim/rc/device_local.vim'
if filereadable(expand(s:device_local_vimrc))
  execute 'source ' .. s:device_local_vimrc
endif

" Project local
let s:project_local_vimrc = '.project_local.vim'
if filereadable(expand(s:project_local_vimrc))
  execute 'source ' .. s:project_local_vimrc
endif
