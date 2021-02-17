if exists('g:loaded_erlang_goto_definition')
    finish
endif
let g:loaded_erlang_goto_definition = 1

let g:erlang_no_mappings = get(g:, 'erlang_goto_definition_no_mappings', 0)
