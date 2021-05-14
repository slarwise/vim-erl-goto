if exists('g:loaded_erlgoto')
    finish
endif
let g:loaded_erlgoto = 1

let s:saved_cpoptions = &cpoptions
set cpoptions&vim

let g:erlgoto_no_mappings = get(g:, 'erlgoto_no_mappings', 0)
let g:ErlgotoFindFile = get(g:, 'ErlgotoFindFile', '')

nnoremap <Plug>erlgoto_edit
            \ :<C-U>call erlgoto#main({'action': 'edit',        'count': v:count1})<CR>
nnoremap <Plug>erlgoto_split
            \ :<C-U>call erlgoto#main({'action': 'split',       'count': v:count1})<CR>
nnoremap <Plug>erlgoto_vsplit
            \ :<C-U>call erlgoto#main({'action': 'vsplit',      'count': v:count1})<CR>
nnoremap <Plug>erlgoto_echo
            \ :<C-U>call erlgoto#main({'action': 'echo',        'count': v:count1})<CR>
nnoremap <Plug>erlgoto_float
            \ :<C-U>call erlgoto#main({'action': 'float',       'count': v:count1})<CR>
nnoremap <Plug>erlgoto_interactive
            \ :<C-U>call erlgoto#main({'action': 'interactive', 'count': v:count1})<CR>

let &cpoptions = s:saved_cpoptions
unlet s:saved_cpoptions
