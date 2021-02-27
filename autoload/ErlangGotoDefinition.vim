" TODO: Prioritize the found matches
"       Create commands for listing all matches
"       Maybe commands for all functionality

function ErlangGotoDefinition#Do(action, count) abort
    let thing_under_cursor = s:get_thing_under_cursor()
    let scope = s:get_scope(thing_under_cursor)
    try
        let matches = s:get_matches(scope, thing_under_cursor)
    catch /^Vim\%((\a\+)\)\=:E38[78]/
        let matches = []
    endtry

    if empty(matches)
        return s:echo_warning('No definitions found')
    elseif a:count > len(matches)
        return s:echo_warning('Count higher than number of matches')
    endif

    let context = s:get_context()

    let [filename, line_nr, col_nr] = matches[a:count-1]
    if index(['edit', 'split', 'vsplit'], a:action) != -1
        return s:do_edit_action(a:action, filename, line_nr, col_nr)
    elseif index(['echo', 'float'], a:action) != -1
        return s:do_echo_action(a:action, filename, line_nr, scope)
    endif

endfunction

function s:get_thing_under_cursor() abort
    let pattern = '[#?]\?\(\i\|:\)*\%' . col('.') . 'c[#?]\?\(\i\|:\)*[(/]\?'
    return matchstr(getline('.'), pattern)
endfunction

function s:get_scope(thing) abort
    if empty(a:thing)
        return ''
    elseif a:thing =~# ':'
        return 'external'
    elseif a:thing[0] =~# '\u'
        return 'variable'
    else
        return 'local'
    endif
endfunction

function s:get_matches(scope, thing_under_cursor)
    if a:scope ==# 'variable'
        return s:variable_search(a:thing_under_cursor)
    elseif a:scope ==# 'local'
        return s:define_search()
    elseif a:scope ==# 'external'
        return s:external_search(a:thing_under_cursor)
    endif
endfunction

function! s:echo_warning(message) abort
    echohl WarningMsg
    echo 'ErlangGotoDefinition: ' . a:message
    echohl None
endfunction

function s:get_context() abort
    return 'function'
endfunction

function s:variable_search(variable) abort
    let function_start_line_nr = search('^\l', 'bnW')
    let function_start_line_nr = max([1, function_start_line_nr])
    let lines = getline(function_start_line_nr, '.')
    let [_, index, col, _] = matchstrpos(lines, '\<' . a:variable . '\>')
    if index == -1
        return []
    endif
    let line_nr = index + function_start_line_nr
    let col_nr = col + 1
    return [[expand('%'), line_nr, col_nr]]
endfunction

function s:define_search() abort
    let current_word = expand('<cword>')
    let dlist = split(execute('dlist ' . current_word), '\n')
    let matches = []
    for line in dlist
        if line[0] =~# '\s'
            let definition_info = split(line)
            let line_nr = str2nr(definition_info[1])
            let definition = join(definition_info[2:])
            let col = match(definition, current_word)
            call add(matches, [filename, line_nr, col+1])
        else
            let filename = line
        endif
    endfor
    return matches
endfunction

function s:external_search(thing) abort
    let [module, thing] = split(a:thing, ':')
    let filename = s:find_file(module . '.erl')
    if empty(filename)
        return []
    endif
    let pattern = '^\(\|-type\s*\|-opaque\s*\)\zs' . thing
    let contents = readfile(filename)
    let start = 0
    let matches = []
    while 1
        let [matched_string, index, col, _] = matchstrpos(contents, pattern, start)
        if index == -1
            break
        endif
        call add(matches, [filename, index+1, col+1])
        let start = index + 1
    endwhile
    return matches
endfunction

function! s:find_file(fname) abort
    let path = findfile(a:fname)
    if !empty(path)
        return path
    endif
    " Taken from https://github.com/tpope/vim-fugitive/blob/master/autoload/fugitive.vim
    if &includeexpr =~# '\<v:fname\>'
        sandbox let fname = eval(substitute(&includeexpr, '\C\<v:fname\>', '\=string(a:fname)', 'g'))
        let path = findfile(fname)
    endif
    return path
endfunction

function! s:do_edit_action(action, filename, line_nr, col_nr) abort
    if expand('%') ==# a:filename && a:action ==# 'edit'
        mark '
        call cursor(a:line_nr, a:col_nr)
    else
        let command = a:action . ' +call\ cursor(' . a:line_nr . ',' .
                    \ a:col_nr . ') ' . a:filename
        execute command
    endif
endfunction

function! s:do_echo_action(action, filename, line_nr, scope) abort
    if a:scope ==# 'variable'
        let contents = getline(a:line_nr, a:line_nr)
    else
        let file_contents = readfile(a:filename)[a:line_nr-1:]
        let end_of_definition = match(file_contents, '^[^%]*\.\s*\(%.*\)\?$')
        let contents = file_contents[0:end_of_definition]
    endif
    if a:action ==# 'echo'
        echo join(contents, "\n")
    else
        call s:display_in_float(contents)
    endif
endfunction

function! s:display_in_float(contents) abort
    let width = max(map(deepcopy(a:contents), 'strdisplaywidth(v:val)'))
    let height = len(a:contents)

    let border_contents = s:create_border_float_contents(width, height)
    let border_buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(border_buf, 0, -1, v:true, border_contents)
    let opts = {'relative': 'cursor', 'width': width+2, 'height': height+2,
                \ 'col': 0, 'row': 1, 'anchor': 'NW', 'style': 'minimal'}
    let border_win = nvim_open_win(border_buf, v:false, opts)
    call nvim_win_set_option(border_win, 'winhl', 'Normal:Normal')

    redraw

    let [border_row, border_col] = nvim_win_get_position(border_win)
    let [text_row, text_col] = [border_row+1, border_col+1]

    let text_buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(text_buf, 0, -1, v:true, a:contents)
    call nvim_buf_set_option(text_buf, 'filetype', 'erlang')
    let opts = {'relative': 'editor', 'width': width, 'height': height,
                \ 'col': text_col, 'row': text_row, 'anchor': 'NW', 'style': 'minimal'}
    let text_win = nvim_open_win(text_buf, v:true, opts)
    call nvim_win_set_option(text_win, 'winhl', 'Normal:Normal')

    redraw

    echohl Type | echo 'Press any key to close' | echohl None
    try
        call getchar()
    catch /^Vim:Interrupt$/
    finally
        execute "normal \<C-L>"
        call nvim_win_close(text_win, 1)
        call nvim_win_close(border_win, 1)
    endtry
endfunction

function! s:create_border_float_contents(width, height) abort
    let top    = '╭' . repeat('─', a:width) . '╮'
    let bottom = '╰' . repeat('─', a:width) . '╯'
    return [top] + map(range(a:height), '"│" . repeat(" ", a:width) . "│"') + [bottom]
endfunction
