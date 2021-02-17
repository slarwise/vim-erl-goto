setlocal suffixesadd=.erl,.hrl

let &l:include = '^\s*-\%(include\|include_lib\)\s*("\zs\f*\ze")'
let &l:define  = '^\s*-\%(define\|record\|type\|opaque\)\|^\ze\l'

if !g:erlang_no_mappings
    nnoremap <buffer><silent> gd
                \ :<C-U>call ErlangGotoDefinition#GotoDefinitionUnderCursor('edit')<CR>
    nnoremap <buffer><silent> <C-W>d
                \ :<C-U>call ErlangGotoDefinition#GotoDefinitionUnderCursor('split')<CR>
    nnoremap <buffer><silent> <C-W><C-D>
                \ :<C-U>call ErlangGotoDefinition#GotoDefinitionUnderCursor('vsplit')<CR>
    nnoremap <buffer><silent> [d
                \ :<C-U>call ErlangGotoDefinition#GotoDefinitionUnderCursor('echo')<CR>
endif
