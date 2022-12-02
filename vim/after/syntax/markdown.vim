"
" Check out markdown.vim file e.g., /usr/local/Cellar/vim/8.1.0150/share/vim/vim81/syntax/markdown.vim
"

"
" Custom colors
"
hi link markdownH1 SangH1
hi link markdownH2 SangH2
hi link markdownH3 SangH3
hi markdownHeadingRule guifg=#8094b4

"
" To disable errors caused by '_' overriding `syn match markdownError "\w\@<=_\w\@="`
" https://stackoverflow.com/questions/19137601/turn-off-highlighting-a-certain-pattern-in-vim/34448277#34448277
"
syn match markdownError "\w\@<=\w\@="

" Disable syntax for LaTex math
" related issue https://github.com/tpope/vim-markdown/issues/60
"syn region markdownCode matchgroup=markdownCodeDelimiter start="\$" end="\$" keepend contains=markdownLineStart
"syn region markdownCode matchgroup=markdownCodeDelimiter start="\$\$" end="\$\$" keepend contains=markdownLineStart

"
" To highlight URLs - from plasticboy/vim-markdown
" - https://github.com/plasticboy/vim-markdown
" - https://github.com/plasticboy/vim-markdown/blob/master/syntax/markdown.vim#L66
"
" Autolink without angle brackets.
" mkd  inline links:      protocol     optional  user:pass@  sub/domain                    .com, .co.uk, etc         optional port   path/querystring/hash fragment
"                         ------------ _____________________ ----------------------------- _________________________ ----------------- __
syn match   mkdInlineURL /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*/

" Autolink with parenthesis.
syn region  mkdInlineURL matchgroup=mkdDelimiter start="(\(https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*)\)\@=" end=")"

" Autolink with angle brackets.
syn region mkdInlineURL matchgroup=mkdDelimiter start="\\\@<!<\ze[a-z][a-z0-9,.-]\{1,22}:\/\/[^> ]*>" end=">"

hi def link mkdInlineURL              htmlLink

"
" Inline code highlighting
"
syn match mkdInlineCode /\v`[^`]+`/
hi def link mkdInlineCode              Comment

" Deep list highlight
syn match markdownListMarker "\%(\t\| \{0,12\}\)[-*+]\%(\s\+\S\)\@=" contained

"
" Diabling hiding code block fences
" Code copied from $NVIM_RUNTIME/syntax/markdown.vim
"
let s:concealends = ''

let s:done_include = {}
for s:type in g:markdown_fenced_languages
  if has_key(s:done_include, matchstr(s:type,'[^.]*'))
    continue
  endif
  exe 'syn region markdownHighlight'.substitute(matchstr(s:type,'[^=]*$'),'\..*','','').' matchgroup=markdownCodeDelimiter start="^\s*````*\s*\%({.\{-}\.\)\='.matchstr(s:type,'[^=]*').'}\=\S\@!.*$" end="^\s*````*\ze\s*$" keepend contains=@markdownHighlight'.substitute(matchstr(s:type,'[^=]*$'),'\.','','g') . s:concealends
  let s:done_include[matchstr(s:type,'[^.]*')] = 1
endfor
unlet! s:type
unlet! s:done_include
