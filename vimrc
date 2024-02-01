"
" Sang's Vim Configuration
"

lua << EOF
  -- Delete the module from the loaded table and reload it.
  function load(file)
    package.loaded[file] = nil
    require(file)
  end
EOF

source $HOME/.vim/rc/setoptions.vim
source $HOME/.vim/rc/statusline.vim
source $HOME/.vim/rc/utility.vim
source $HOME/.vim/rc/autocmd.vim
source $HOME/.vim/rc/functions.vim
source $HOME/.vim/rc/mappings.vim
source $HOME/.vim/rc/plug.vim
source $HOME/.vim/rc/colorscheme.vim " This has to come after plug.vim.

" Edit vimrc
nnoremap <silent> <Leader>vp :tabnew<CR>:e ~/.vim/rc/plugins.vim<CR>
nnoremap <silent> <Leader>vd :tabnew<CR>:e ~/.vim/rc/devplugins.vim<CR>
nnoremap <silent> <Leader>vm :tabnew<CR>:e ~/.vim/rc/mappings.vim<CR>
nnoremap <silent> <Leader>vl :tabnew<CR>:e ~/.vim/rc/device_local.vim<CR>
nnoremap <Leader>vr :source ~/.vimrc<CR>

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
function! RunProjectLocalVimrc()
  let s:project_local_vimrc = '.project_local.vim'
  if filereadable(expand(s:project_local_vimrc))
    execute 'source ' .. s:project_local_vimrc
  endif
endfunction

call RunProjectLocalVimrc()
