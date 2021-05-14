setlocal suffixesadd=.erl,.hrl

let &l:include = '^\s*-\%(include\|include_lib\)\s*("\zs\f*\ze")'
let &l:define  = '^\ze\l\|^\s*-\%(define\|record\|type\|opaque\)'

if !g:erlgoto_no_mappings
    if !hasmapto('<Plug>erlgoto_edit')   && empty(mapcheck('gd'))
        nmap <unique><buffer><silent> gd         <Plug>erlgoto_edit
    endif
    if !hasmapto('<Plug>erlgoto_split')  && empty(mapcheck("\<C-W>d"))
        nmap <unique><buffer><silent> <C-W>d     <Plug>erlgoto_split
    endif
    if !hasmapto('<Plug>erlgoto_vsplit') && empty(mapcheck("\<C-W><C-D>"))
        nmap <unique><buffer><silent> <C-W><C-D> <Plug>erlgoto_vsplit
    endif
    if !hasmapto('<Plug>erlgoto_echo')   && empty(mapcheck('[d'))
        nmap <unique><buffer><silent> [d         <Plug>erlgoto_echo
    endif
    if !hasmapto('<Plug>erlgoto_interactive')   && empty(mapcheck('[D'))
        nmap <unique><buffer><silent> [D         <Plug>erlgoto_interactive
    endif
endif
