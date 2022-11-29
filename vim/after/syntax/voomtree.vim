" syntax for normal texts
syntax match VoomHeaderCurrent /\v\=.+/
highlight link VoomHeaderCurrent Identifier

syntax match VoomHeaderH1 /\v  \|.+/
highlight VoomHeaderH1 guifg=#cc99cc

syntax match VoomHeaderH2 /\v  . \|.+/
highlight VoomHeaderH2 guifg=#f99157

syntax match VoomHeaderH3 /\v  . . \|.+/
highlight VoomHeaderH3 guifg=#999999
