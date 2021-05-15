function! erlgoto#find#prev_function(lines) abort
    let reversed_lines = reverse(copy(a:lines))
    let function_start_pattern = '^\l'
    let idx = match(reversed_lines, function_start_pattern)
    if idx == -1
        return 0
    else
        return len(a:lines) - idx - 1
    endif
endfunction

function! erlgoto#find#next_def_end(lines) abort
    let end_of_definition_pattern = '^[^%]*\.\s*\(%.*\)\?$'
    let idx = match(a:lines, end_of_definition_pattern)
    if idx == -1
        return len(a:lines) - 1
    else
        return idx
    endif
endfunction

" Could use matchstrpos and see if the start and end col encloses col
" Use the start argument to continue if end col is before col
" Same for external_in
function! erlgoto#find#var_in(line, col) abort
    let col_match = '\%' . a:col . 'c'
    let pattern = '[#?'']\?\i*' . col_match . '\i\+'
    let match = matchstr(a:line, pattern)
    if match =~# '^[A-Z_]'
        return match
    else
        return ''
    endif
endfunction

function! erlgoto#find#external_in(line, col) abort
    let char_under_cursor = a:line[a:col - 1]
    let col_match = '\%' . a:col . 'c'
    if char_under_cursor =~# '\i'
        let patterns = [
                    \ '\<\l\i*' . col_match . '\i\+:\l\i*',
                    \ '\<\l\i*:\l\i*' . col_match . '\i*',
                    \ ]
        if char_under_cursor =~# '\l'
            let patterns += [
                        \ '\<' . col_match . '\l\i*:\l\i*',
                        \ '\<\l\i*:' . col_match . '\l\i*'
                        \ ]
        endif
        let pattern = join(patterns, '\|')
        let match = matchstr(a:line, pattern)
        return split(match, ':')
    elseif char_under_cursor ==# ':'
        let pattern = '\<\l\i*' . col_match . ':\l\i*'
        let match = matchstr(a:line, pattern)
        return split(match, ':')
    else
        return []
    endif
endfunction

function! erlgoto#find#var_def(variable, lines) abort
    let idx_of_previous_function = erlgoto#find#prev_function(a:lines)
    let variable_pattern = '\<' . a:variable . '\>'
    let [_, idx, col, _] = matchstrpos(a:lines[idx_of_previous_function:], variable_pattern)
    if idx == -1
        return {}
    else
        return {'line': idx_of_previous_function + idx, 'col': col}
    endif
endfunction

function! erlgoto#find#external_defs(symbol, lines) abort
    let pattern = '^\(\|-type\s\+\|-opaque\s\+\)\zs' . a:symbol . '\s*('
    let positions = []
    let start = 0
    while 1
        let [_, start_line, col, _] = matchstrpos(a:lines, pattern, start)
        if start_line == -1
            break
        endif
        let end_line = erlgoto#find#next_def_end(a:lines[start_line:]) + start_line
        let position = {
                    \ 'start_line': start_line,
                    \ 'end_line': end_line,
                    \ 'col': col,
                    \ }
        call add(positions, position)
        let start = end_line + 1
    endwhile
    return positions
endfunction

function! erlgoto#find#include_defs(cword) abort
    try
        let dlist = split(execute('dlist ' . a:cword), '\n')
    catch /^Vim\%((\a\+)\)\=:E38[78]/
        return []
    endtry
    let positions = []
    for line in dlist
        if line[0] =~# '\s'
            let start_line = str2nr(split(line)[1]) - 1
            if path ==# expand('%')
                let lines = getline(start_line+1, '$')
            else
                let lines = readfile(path)[start_line:]
            endif
            let end_line = erlgoto#find#next_def_end(lines) + start_line
            let col_nr = match(lines[0], a:cword) + 1
            let position = {
                        \ 'path': path,
                        \ 'start_line': start_line,
                        \ 'end_line': end_line,
                        \ 'col': col_nr,
                        \ }
            call add(positions, position)
        else
            let path = line
        endif
    endfor
    return positions
endfunction

function! erlgoto#find#path(path) abort
    let path = findfile(a:path)
    if empty(path) && !empty(g:ErlgotoFindFile)
        let path = call(g:ErlgotoFindFile, [a:path])
        let path = findfile(path)
    endif
    return path
endfunction
