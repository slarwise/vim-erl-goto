setlocal suffixesadd=.erl,.hrl

let &l:include = '^\s*-\%(include\|include_lib\)\s*("\zs\f*\ze")'
let &l:define  = '^\ze\l\|^\s*-\%(define\|record\|type\|opaque\)'

nnoremap <Plug>ErlangGotoDefinitionEdit
            \ :<C-U>call ErlangGotoDefinition#GotoDefinitionUnderCursor('edit')<CR>
nnoremap <Plug>ErlangGotoDefinitionSplit
            \ :<C-U>call ErlangGotoDefinition#GotoDefinitionUnderCursor('split')<CR>
nnoremap <Plug>ErlangGotoDefinitionVsplit
            \ :<C-U>call ErlangGotoDefinition#GotoDefinitionUnderCursor('vsplit')<CR>
nnoremap <Plug>ErlangGotoDefinitionEcho
            \ :<C-U>call ErlangGotoDefinition#GotoDefinitionUnderCursor('echo')<CR>
nnoremap <Plug>ErlangGotoDefinitionFloat
            \ :<C-U>call ErlangGotoDefinition#GotoDefinitionUnderCursor('float')<CR>

if !g:erlang_goto_definition_no_mappings
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
endif
