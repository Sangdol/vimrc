"
" Functions and commands
"

" From https://vim.fandom.com/wiki/Append_output_of_an_external_command
" which is way better than the one from
" https://unix.stackexchange.com/questions/8101/how-to-insert-the-result-of-a-command-into-the-text-in-vim/8296#8296
"
" Usage:
"   :Tab tabnew ls
"   :Tab vnew mes vnew
"   :Tab tabnew echo 'hello'
function! Tab(...)
  " Where to put the result?
  " E.g., tabnew, vnew, new, etc.
  let wintype = get(a:, 1)

  " join from the second argument
  let cmd = join(a:000[1:], ' ')

  redir => message
  silent execute cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    execute wintype
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction

command! -nargs=+ -complete=command Tab call Tab(<f-args>)
command! -nargs=+ -complete=command Tabt call Tab('tabnew', <f-args>)
command! -nargs=+ -complete=command Tabl call Tab('vnew', <f-args>)

" message in new tab
nnoremap <Leader>emt :Tabt mes<CR>

" message in vertical split
nnoremap <Leader>eml :Tabl mes<CR>

" last command in new tab
nnoremap <Leader>emm :Tabt <C-R>:<CR>

"
" From https://vim.fandom.com/wiki/Delete_files_with_a_Vim_command#Comments
"
function! DeleteFile(...)
  if(exists('a:1'))
    let theFile=a:1
  elseif ( &ft == 'help' )
    echohl Error
    echo "Cannot delete a help buffer!"
    echohl None
    return -1
  else
    let theFile=expand('%:p')
  endif
  let delStatus=delete(theFile)
  if(delStatus == 0)
    echo "Deleted " . theFile
  else
    echohl WarningMsg
    echo "Failed to delete " . theFile
    echohl None
  endif
  return delStatus
endfunction
"delete the current file
com! Rm call DeleteFile()
"delete the file and quit the buffer (quits vim if this was the last file)
com! RM call DeleteFile() <Bar> q!

"
" Custom gx replacement
"
function! s:open_url(url)
  echom 'Opening "' .. a:url .. '"'
  if !empty(a:url)
    if has("mac")
      silent exec "!open '"..a:url.."'"
    elseif has("unix")
      silent exec "!google-chrome '"..a:url.."'"
    endif
  else
    echom "No URL found"
  endif
endfunction

" Open URL in browser
function! s:browser()
  let line = getline('.')
  let line = trim(line)
  let is_plug = StartsWith(line, 'Plug')
  if is_plug
    let path = substitute(line, '\vPlug [''"](.{-})[''"].*', '\1', '')
    let url = 'https://github.com/' .. path
    call s:open_url(url)
  else
    let line = matchstr(line, "http[^ `)]*")
    " Should escape to prevent replaced with registers. Refer to :h c_#, c_%
    " Why escaping ; and |?
    let url = escape(line, "#;|%")
    call s:open_url(url)
  endif
endfunction

nnoremap <Leader>b :call <SID>browser()<CR>

"
" Google it
" https://www.reddit.com/r/vim/comments/ebaoku/function_to_google_any_text_object/
"
function! GoogleText(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@

  if a:0  " Invoked from Visual mode, use '< and '> marks.
    silent exe "normal! `<" . a:type . "`>y"
  elseif a:type == 'line'
    silent exe "normal! '[V']y"
  elseif a:type == 'block'
    silent exe "normal! `[\<C-V>`]y"
  else
    silent exe "normal! `[v`]y"
  endif

  let search = substitute(trim(@@), ' \+', '+', 'g')
  let @+ = search
  silent exec '!open "http://google.com/search?q=' . search . '" &'

  let &selection = sel_save
  let @@ = reg_save
endfunction

nmap <silent> ga :set opfunc=GoogleText<CR>g@
vmap <silent> ga :<C-u>call GoogleText(visualmode(), 1)<Cr>

"
" Save with a timestamp
"
function! SaveToTempWithTimestamp(...) abort
  let path = a:1
  let ext = a:2
  let suffix = get(a:, 3, '')

  let timestamp = strftime("%Y%m%d_%H%M%S")
  let filename = timestamp .. '.' .. ext

  if !empty(suffix)
    let filename = timestamp .. '_' .. suffix .. '.' .. ext
  endif

  let target_path = expand(path)

  call CreateDirIfNotExist(target_path)

  if empty(bufname())
    exe 'w ' .. target_path .. filename
  else
    echo 'This file already has a filename.'
  endif
endfunction

" [w]rite [i]nside current window
nnoremap <Leader>wig :call SaveToTempWithTimestamp('~/workbench/gpt/', 'md')<CR>
nnoremap <Leader>wix :call SaveToTempWithTimestamp('~/workbench/vim-notes/', 'txt')<CR>
nnoremap <Leader>wim :call SaveToTempWithTimestamp('~/workbench/vim-notes/', 'md')<CR>
nnoremap <Leader>wip :call SaveToTempWithTimestamp('~/workbench/code/', 'py')<CR>
nnoremap <Leader>wij :call SaveToTempWithTimestamp('~/workbench/code/', 'js')<CR>
nnoremap <Leader>wit :call SaveToTempWithTimestamp('~/workbench/code/', 'ts')<CR>
nnoremap <Leader>wib :call SaveToTempWithTimestamp('~/workbench/code/', 'sh')<CR>
nnoremap <Leader>wif :call SaveToTempWithTimestamp('~/workbench/code/', 'fish')<CR>
nnoremap <Leader>wil :call SaveToTempWithTimestamp('~/workbench/code/', 'lua')<CR>
nnoremap <Leader>wiv :call SaveToTempWithTimestamp('~/workbench/code/', 'vim')<CR>
nnoremap <Leader>wih :call SaveToTempWithTimestamp('~/workbench/code/', 'html')<CR>
nnoremap <Leader>wio :call SaveToTempWithTimestamp('~/workbench/code/', 'js', 'mongo')<CR>

" [w]rite in a new [t]ab
nnoremap <Leader>wtx :tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/vim-notes/', 'txt')<CR>
nnoremap <Leader>wtm :tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/vim-notes/', 'md')<CR>
nnoremap <Leader>wtp :tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'py')<CR>
nnoremap <Leader>wtj :tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'js')<CR>
nnoremap <Leader>wtt :tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'ts')<CR>
nnoremap <Leader>wtb :tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'sh')<CR>
nnoremap <Leader>wtf :tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'fish')<CR>
nnoremap <Leader>wtl :tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'lua')<CR>
nnoremap <Leader>wtv :tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'vim')<CR>
nnoremap <Leader>wth :tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'html')<CR>
nnoremap <Leader>wto :tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'js', 'mongo')<CR>
nnoremap <Leader>wtg :tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/gpt/', 'md')<CR>

xnoremap <Leader>wtx y:tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/vim-notes/', 'txt')<CR>:put<CR>
xnoremap <Leader>wtm y:tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/vim-notes/', 'md')<CR>:put<CR>
xnoremap <Leader>wtp y:tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'py')<CR>:put<CR>
xnoremap <Leader>wtj y:tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'js')<CR>:put<CR>
xnoremap <Leader>wtt y:tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'ts')<CR>:put<CR>
xnoremap <Leader>wtb y:tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'sh')<CR>:put<CR>
xnoremap <Leader>wtf y:tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'fish')<CR>:put<CR>
xnoremap <Leader>wtl y:tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'lua')<CR>:put<CR>
xnoremap <Leader>wtv y:tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'vim')<CR>:put<CR>
xnoremap <Leader>wth y:tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'html')<CR>:put<CR>
xnoremap <Leader>wto y:tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'js', 'mongo')<CR>:put<CR>
xnoremap <Leader>wtg y:tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/gpt/', 'md')<CR>:put<CR>

" [w]rite in a new [v]ertical split
nnoremap <Leader>wvx :rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/vim-notes/', 'txt')<CR>
nnoremap <Leader>wvm :rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/vim-notes/', 'md')<CR>
nnoremap <Leader>wvp :rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'py')<CR>
nnoremap <Leader>wvj :rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'js')<CR>
nnoremap <Leader>wvt :rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'ts')<CR>
nnoremap <Leader>wvb :rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'sh')<CR>
nnoremap <Leader>wvf :rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'fish')<CR>
nnoremap <Leader>wvl :rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'lua')<CR>
nnoremap <Leader>wvv :rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'vim')<CR>
nnoremap <Leader>wvh :rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'html')<CR>
nnoremap <Leader>wvo :rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'js', 'mongo')<CR>
nnoremap <Leader>wvg :rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/gpt/', 'md')<CR>

xnoremap <Leader>wvx y:rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/vim-notes/', 'txt')<CR>:put<CR>
xnoremap <Leader>wvm y:rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/vim-notes/', 'md')<CR>:put<CR>
xnoremap <Leader>wvp y:rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'py')<CR>:put<CR>
xnoremap <Leader>wvj y:rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'js')<CR>:put<CR>
xnoremap <Leader>wvt y:rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'ts')<CR>:put<CR>
xnoremap <Leader>wvb y:rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'sh')<CR>:put<CR>
xnoremap <Leader>wvf y:rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'fish')<CR>:put<CR>
xnoremap <Leader>wvl y:rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'lua')<CR>:put<CR>
xnoremap <Leader>wvv y:rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'vim')<CR>:put<CR>
xnoremap <Leader>wvh y:rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'html')<CR>:put<CR>
xnoremap <Leader>wvo y:rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/code/', 'js', 'mongo')<CR>:put<CR>
xnoremap <Leader>wvg y:rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/gpt/', 'md')<CR>:put<CR>

" Add an easier mapping since it's used often.
nnoremap <Leader>cn :tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/gpt/', 'md')<CR>
nnoremap <Leader>cl :rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/gpt/', 'md')<CR>
xnoremap <Leader>cn y:tabnew<CR>:call SaveToTempWithTimestamp('~/workbench/gpt/', 'md')<CR>:put<CR>
xnoremap <Leader>cl y:rightbelow vertical new<CR>:call SaveToTempWithTimestamp('~/workbench/gpt/', 'md')<CR>:put<CR>

"
" Translate the keyboard middle line characters to numbers
" since numbers are too far from fingers.
"
" alphanumeric_line_number examples
" - 10
" - 10,20
" - aa    " => 11
" - aa,af " => 11,14
function! s:translate_linenumber(alphanumeric_line_number)
  if a:alphanumeric_line_number !~ '\d'
    let d = ZipMap('-+asdfghjkl;,', '-+1234567890,')
    let chars = StringToArray(a:alphanumeric_line_number)
    let line_number = join(map(chars, {idx, val -> d[val]}), '')

    return line_number
  else
    return a:alphanumeric_line_number
  endif
endfunction

" Copy nth line to the current line
function! s:copy_line_of(alphanumeric_line_number)
  let line_number = s:translate_linenumber(a:alphanumeric_line_number)
  exec line_number .. 't.'
endfunction

command! -nargs=1 C call <SID>copy_line_of(<q-args>)

" Delete line without jumping cursor
function! s:delete_line_of(alphanumeric_line_number)
  let line_number = s:translate_linenumber(a:alphanumeric_line_number)
  exec line_number .. 'd'
  exec "normal \<C-o>"
endfunction

command! -nargs=1 D call <SID>delete_line_of(<q-args>)

" Run macros over selected lines
" https://github.com/stoeffel/.dotfiles/blob/master/vim/visual-at.vim
xnoremap @ :<C-u>call <SID>execute_macro_over_visual_range()<CR>

function! s:execute_macro_over_visual_range()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

"
" Show the current syntax group
" https://stackoverflow.com/a/9464929/524588
"
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

command! -nargs=0 SynStack call SynStack()

"
" https://stackoverflow.com/a/6271254/524588
"
function! GetVisualSelection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

"
" https://superuser.com/questions/555011/vim-close-all-tabs-to-the-right
"
function! TabCloseRight(bang)
    let cur=tabpagenr()
    while cur < tabpagenr('$')
        exe 'tabclose' . a:bang . ' ' . (cur + 1)
    endwhile
endfunction

command! -bang Tabcloseright call TabCloseRight('<bang>')
nnoremap <Leader>tr :Tabcloseright<CR>

"
" Literal search
" https://vi.stackexchange.com/a/17474/3225
"
command! -nargs=1 Search :let @/='\V'.escape(<q-args>, '\\')| normal! n
