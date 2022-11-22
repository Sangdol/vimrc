" Refer to
" https://vi.stackexchange.com/questions/3250/showing-colors-in-vims-quickfix-window-from-dispatch-tasks

syntax  keyword  TestPass       PASSED
syntax  keyword  TestError      ERROR FAILED FAILURE
syntax  match    TestException  "\v.+Error"
syntax  match    TestException  "\v.+Exception"

hi  TestPass       guifg=green
hi  TestError      guifg=red
hi  TestException  guifg=red

