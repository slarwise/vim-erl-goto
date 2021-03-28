if exists('g:loaded_erlang_goto_definition')
    finish
endif
let g:loaded_erlang_goto_definition = 1

let s:saved_cpoptions = &cpoptions
set cpoptions&vim

let g:ErlangGotoDefinitionNoMappings = get(
            \ g:, 'ErlangGotoDefinitionNoMappings', 0)
let g:ErlangGotoDefinitionFindfile = get(
            \ g:, 'ErlangGotoDefinitionFindFile', '')

nnoremap <Plug>ErlangGotoDefinitionEdit
            \ :<C-U>call ErlangGotoDefinition#Do('edit',   v:count1)<CR>
nnoremap <Plug>ErlangGotoDefinitionSplit
            \ :<C-U>call ErlangGotoDefinition#Do('split',  v:count1)<CR>
nnoremap <Plug>ErlangGotoDefinitionVsplit
            \ :<C-U>call ErlangGotoDefinition#Do('vsplit', v:count1)<CR>
nnoremap <Plug>ErlangGotoDefinitionEcho
            \ :<C-U>call ErlangGotoDefinition#Do('echo',   v:count1)<CR>
nnoremap <Plug>ErlangGotoDefinitionFloat
            \ :<C-U>call ErlangGotoDefinition#Do('float',  v:count1)<CR>
nnoremap <Plug>ErlangGotoDefinitionList
            \ :<C-U>call ErlangGotoDefinition#Do('list',  v:count1)<CR>

let &cpoptions = s:saved_cpoptions
unlet s:saved_cpoptions
