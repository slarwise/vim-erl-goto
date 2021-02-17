setlocal suffixedadd=.erl,.hrl

let &l:include = '^\s*-\%(include\|include_lib\)\s*("\zs\f*\ze")'
let &l:define  = '^\s*-\%(define\|record\|type\|opaque\)\|^\ze\l'

if !g:erlang_no_mappings
    nnoremap <buffer> gd         :<C-U> call ErlangGotoDefinition#GotoDefinitionUnderCursor('edit')<CR>
    nnoremap <buffer> <C-W>d     :<C-U> call ErlangGotoDefinition#GotoDefinitionUnderCursor('split')<CR>
    nnoremap <buffer> <C-W><C-D> :<C-U> call ErlangGotoDefinition#GotoDefinitionUnderCursor('vsplit')<CR>
    nnoremap <buffer> [d         :<C-U> call ErlangGotoDefinition#GotoDefinitionUnderCursor('echo')<CR>
endif
