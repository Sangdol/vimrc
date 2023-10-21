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
