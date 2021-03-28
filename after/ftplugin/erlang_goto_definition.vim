setlocal suffixesadd=.erl,.hrl

let &l:include = '^\s*-\%(include\|include_lib\)\s*("\zs\f*\ze")'
let &l:define  = '^\ze\l\|^\s*-\%(define\|record\|type\|opaque\)'

if !g:ErlangGotoDefinitionNoMappings
    if !hasmapto('<Plug>ErlangGotoDefinitionEdit')   && empty(mapcheck('gd'))
        nmap <unique><buffer><silent> gd         <Plug>ErlangGotoDefinitionEdit
    endif
    if !hasmapto('<Plug>ErlangGotoDefinitionSplit')  && empty(mapcheck("\<C-W>d"))
        nmap <unique><buffer><silent> <C-W>d     <Plug>ErlangGotoDefinitionSplit
    endif
    if !hasmapto('<Plug>ErlangGotoDefinitionVsplit') && empty(mapcheck("\<C-W><C-D>"))
        nmap <unique><buffer><silent> <C-W><C-D> <Plug>ErlangGotoDefinitionVsplit
    endif
    if !hasmapto('<Plug>ErlangGotoDefinitionEcho')   && empty(mapcheck('[d'))
        nmap <unique><buffer><silent> [d         <Plug>ErlangGotoDefinitionEcho
    endif
    if !hasmapto('<Plug>ErlangGotoDefinitionList')   && empty(mapcheck('[D'))
        nmap <unique><buffer><silent> [D         <Plug>ErlangGotoDefinitionList
    endif
endif
