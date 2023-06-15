" syntax for normal texts
syntax match VoomHeaderCurrent /\v\=.+/
highlight link VoomHeaderCurrent Folded

syntax match VoomHeaderH1 /\v  \|.+/
highlight link VoomHeaderH1 markdownH1

syntax match VoomHeaderH2 /\v  . \|.+/
highlight link VoomHeaderH2 markdownH2

syntax match VoomHeaderH3 /\v  . . \|.+/
highlight link VoomHeaderH3 markdownH3
