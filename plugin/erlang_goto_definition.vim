if exists('g:loaded_erlang_goto_definition')
    finish
endif
let g:loaded_erlang_goto_definition = 1

let s:saved_cpoptions = &cpoptions
set cpoptions&vim

let g:erlang_goto_definition_no_mappings = get(
            \ g:, 'erlang_goto_definition_no_mappings', 0)

let &cpoptions = s:saved_cpoptions
unlet s:saved_cpoptions
