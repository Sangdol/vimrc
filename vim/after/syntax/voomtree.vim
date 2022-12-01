" syntax for normal texts
syntax match VoomHeaderCurrent /\v\=.+/
highlight link VoomHeaderCurrent Identifier

syntax match VoomHeaderH1 /\v  \|.+/
highlight link VoomHeaderH1 SangH1

syntax match VoomHeaderH2 /\v  . \|.+/
highlight link VoomHeaderH2 SangH2

syntax match VoomHeaderH3 /\v  . . \|.+/
highlight link VoomHeaderH3 SangH3
