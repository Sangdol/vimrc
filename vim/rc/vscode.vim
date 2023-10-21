"
" Hello, VSCode!
"

nmap <silent> <leader>sd <Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>
nmap <silent> <leader>sv <Cmd>call VSCodeNotify('editor.action.revealDefinitionAside')<CR>
nmap <silent> <leader>sr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
nmap <silent> <leader>ss <Cmd>call VSCodeNotify('editor.action.peekDefinition')<CR>

nmap <silent> ]e <Cmd>call VSCodeNotify('editor.action.marker.next')<CR>
nmap <silent> [e <Cmd>call VSCodeNotify('editor.action.marker.prev')<CR>

nmap <C-q> <C-w>w
imap <C-q> <ESC><C-w>w

"
" Git
"
" WIP

"
" Folding
" https://github.com/vscode-neovim/vscode-neovim/issues/58
"
nnoremap zM :call VSCodeNotify('editor.foldAll')<CR>
nnoremap zR :call VSCodeNotify('editor.unfoldAll')<CR>
nnoremap zc :call VSCodeNotify('editor.fold')<CR>
nnoremap zC :call VSCodeNotify('editor.foldRecursively')<CR>
nnoremap zo :call VSCodeNotify('editor.unfold')<CR>
nnoremap zO :call VSCodeNotify('editor.unfoldRecursively')<CR>
nnoremap za :call VSCodeNotify('editor.toggleFold')<CR>

function! MoveCursor(direction) abort
    if(reg_recording() == '' && reg_executing() == '')
        return 'g'.a:direction
    else
        return a:direction
    endif
endfunction

nmap <expr> j MoveCursor('j')
nmap <expr> k MoveCursor('k')

"
" These doesn't work (why?)
"

"nmap <C-_> <Cmd>call VSCodeNotify('editor.action.commentLine')<CR>
"nmap <C-/> <Cmd>call VSCodeNotify('editor.action.commentLine')<CR>

"nmap <C-w>= <Cmd>call VSCodeNotify('workbench.action.increaseViewSize')<CR>
"nmap <C-w>- <Cmd>call VSCodeNotify('workbench.action.decreaseViewSize')<CR>
