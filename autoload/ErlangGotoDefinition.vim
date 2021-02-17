" Functionality:
"   - Go to include definition using edit, split and vsplit
"   - Echo include definition
"   - Go to variable definition using edit, split and vsplit
"   - Echo variable definition
"   - Go to external definition using edit, split and vsplit
"   - Echo external definition

function ErlangGotoDefinition#GotoDefinitionUnderCursor(action) abort
    let thing_under_cursor = ErlangGotoDefinition#get_thing_under_cursor()
    let scope = ErlangGotoDefinition#get_scope(thing_under_cursor)
    if scope ==# 'variable'
        let success = ErlangGotoDefinition#variable(thing_under_cursor, a:action)
    elseif scope ==# 'local'
        let success = ErlangGotoDefinition#local(a:action)
    elseif scope ==# 'external'
        let success = ErlangGotoDefinition#external(thing_under_cursor, a:action)
    else
        let success = 0
    endif
    if !success
        echohl WarningMsg | echo 'ErlangGotoDefinition: Failed' | echohl None
    endif
endfunction

function ErlangGotoDefinition#get_thing_under_cursor() abort
    let pattern = '[#?]\?\(\i\|:\)*\%' . col('.') . 'c[#?]\?\(\i\|:\)*[(/]\?'
    return matchstr(getline('.'), pattern)
endfunction

function ErlangGotoDefinition#get_scope(thing) abort
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

function ErlangGotoDefinition#variable(variable, action) abort
    let function_start_line_nr = search('^\l', 'bnW')
    let function_start_line_nr = max([1, function_start_line_nr])
    let lines = getline(function_start_line_nr, '.')
    let [_, index, col_start, _] = matchstrpos(lines, '\<' . a:variable . '\>')
    if index == -1
        return 0
    endif
    let line_nr = index + function_start_line_nr
    let col_nr = col_start + 1
    if a:action == 'edit'
        let pattern = '\%' . line_nr . 'l' . a:variable
        let result = search(pattern, 'bsW')
    elseif a:action == 'split'
        execute 'split +call\ cursor(' . line_nr . ',' . col_nr . ')'
    elseif a:action == 'vsplit'
        execute 'vsplit +call\ cursor(' . line_nr . ',' . col_nr . ')'
    elseif a:action == 'echo'
        echo getline(line_nr)
    endif
    return 1
endfunction

function ErlangGotoDefinition#local(action) abort
    try
        if a:action == 'edit'
            execute "normal! [\<C-D>"
        elseif a:action == 'split'
            execute "normal! \<C-W>d"
        elseif a:action == 'vsplit'
            execute "vertical normal! \<C-W>d"
        elseif a:action == 'echo'
            let dlist = execute('dlist ' . expand('<cword>'), 'silent')
            let dlist_lines = split(dlist, '\n')
            let filename = dlist_lines[0]
            let definition = dlist_lines[1]
            let line_nr = split(definition)[1]
            let file_contents = readfile(expand(filename))
            let file_contents = file_contents[line_nr-1:-1]
            let end_of_definition = match(file_contents, '^[^%]*\.\s*\(%.*\)\?$')
            echo join(file_contents[0:end_of_definition], "\n")
        endif
    catch /^Vim\%((\a\+)\)\=:E387/
        return 0
    catch /^Vim\%((\a\+)\)\=:E388/
        return 0
    endtry
    return 1
endfunction

function ErlangGotoDefinition#external(thing, action) abort
    let [module, symbol] = split(a:thing, ':')
    let module_path = s:FindFile(module . '.erl')
    if empty(module_path)
        return 0
    endif
    let pattern = '^\(\|-type(\|-opaque(\)\zs' . symbol
    let contents = readfile(module_path)
    let [_, index, col_start, _] = matchstrpos(contents, pattern)
    if index == 0
        return 0
    endif
    let [line_nr, col_nr] = [index + 1, col_start + 1]
    if a:action == 'edit'
        execute 'edit +call\ cursor(' . line_nr . ',' . col_nr . ') ' . module_path
    elseif a:action == 'split'
        execute 'split +call\ cursor(' . line_nr . ',' . col_nr . ') ' . module_path
    elseif a:action == 'vsplit'
        execute 'vsplit +call\ cursor(' . line_nr . ',' . col_nr . ') ' . module_path
    elseif a:action == 'echo'
        let file_contents = contents[line_nr-1:-1]
        let end_of_definition = match(file_contents, '^[^%]*\.\s*\(%.*\)\?$')
        echo join(file_contents[0:end_of_definition], "\n")
    endif
    return 1
endfunction

function! s:FindFile(fname) abort
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
