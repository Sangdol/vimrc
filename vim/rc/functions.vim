"
" Functions and commands
"

" From https://vim.fandom.com/wiki/Append_output_of_an_external_command
" which is way better than the one from
" https://unix.stackexchange.com/questions/8101/how-to-insert-the-result-of-a-command-into-the-text-in-vim/8296#8296
"
" Usage:
"   :Tab ls
"   :Tab echo g:
function! Tab(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction

command! -nargs=+ -complete=command Tab call Tab(<q-args>)

" https://vim.fandom.com/wiki/Delete_files_with_a_Vim_command#Comments
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

function! s:open_url(url)
  echom 'Opening "' .. a:url .. '"'
  if !empty(a:url)
    if has("mac")
      exec "!open '"..a:url.."'"
    elseif has("unix")
      exec "!google-chrome '"..a:url.."'"
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

" (Remove the last <CR> to debug)
nnoremap <Leader>b :call <SID>browser()<CR><CR>

" Google it
" https://vi.stackexchange.com/a/9002/3225
function! s:google_search()
    let searchterm = getreg("g")
    let escapedTerm = substitute(searchterm, ' ', '+', "g")
    let escapedTerm = substitute(escapedTerm, '\n', '+', "g")
    let escapedTerm = substitute(escapedTerm, '*', '', "g")
    exec '!open "http://google.com/search?q=' . escapedTerm . '" &'
endfunction
vnoremap <Leader>g "gy<Esc>:call <SID>google_search()<CR><CR>

" Save to the notes dir
function! s:save_to_temp_with_timestamp() abort
  let timestamp = strftime("%Y-%m-%d_%H%M%S")
  let filename = 'vim_' .. timestamp .. '.md'
  let target_path = expand('~/workbench/vim-notes/')

  call CreateDirIfNotExist(target_path)

  if empty(bufname())
    exe 'w ' .. target_path .. filename
  else
    echo 'This is already has a filename.'
  endif
endfunction

noremap <Leader>wt :call <SID>save_to_temp_with_timestamp()<CR>

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
