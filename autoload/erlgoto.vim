function! erlgoto#main(config) abort
    let definitions = []
    let line = getline('.')
    let col = col('.')

    let var_under_cursor = erlgoto#find#var_in(line, col)
    if !empty(var_under_cursor)
        let lines = getline(1, '.')
        let pos = erlgoto#find#var_def(var_under_cursor, lines)
        if !empty(pos)
            let def = erlgoto#def#init(expand('%'), pos.line, pos.line, pos.col, lines)
            call add(definitions, def)
        endif
    endif

    let external_under_cursor = erlgoto#find#external_in(line, col)
    if !empty(external_under_cursor)
        let [module, symbol] = external_under_cursor
        let module_path = erlgoto#find#path(module . '.erl')
        if !empty(module_path)
            let lines = readfile(module_path)
            let positions = erlgoto#find#external_defs(symbol, lines)
            for pos in positions
                let def = erlgoto#def#init(module_path, pos.start_line,
                            \ pos.end_line, pos.col, lines)
                call add(definitions, def)
            endfor
        endif
    endif

    let positions = erlgoto#find#include_defs(expand('<cword>'))
    for pos in positions
        let lines = readfile(pos.path)
        let def = erlgoto#def#init(pos.path, pos.start_line, pos.end_line,
                    \ pos.col, lines)
        call add(definitions, def)
    endfor

    if empty(definitions)
        return erlgoto#echo_warning('No definitions found')
    else
    endif

    let config = a:config
    if config.action ==# 'interactive'
        let config = erlgoto#choose(definitions)
        if empty(config)
            return
        endif
    endif

    let count_val_error = erlgoto#validate_count(config.count, definitions)
    if empty(count_val_error)
        let definition = definitions[config.count - 1]
    else
        return erlgoto#echo_warning(count_val_error)
    endif

    if config.action ==# 'edit'
        return erlgoto#edit(definition)
    elseif index(['split', 'vsplit'], config.action) != -1
        return erlgoto#split(config.action, definition)
    elseif config.action ==# 'echo'
        return erlgoto#echo(definition.text)
    elseif config.action ==# 'float'
        return erlgoto#float(definition.text)
    endif
endfunction

function! erlgoto#edit(def) abort
    let is_current_file = a:def.path ==# expand('%')
    if is_current_file
        mark '
        call cursor(a:def.line, a:def.col)
    else
        let command = 'edit +call\ cursor(' . a:def.line . ',' .
                    \ a:def.col . ') ' . a:def.path
        execute command
    endif
endfunction

function! erlgoto#split(split_type, def) abort
    let command = a:split_type . ' +call\ cursor(' . a:def.line . ',' .
                \ a:def.col . ') ' . a:def.path
    execute command
endfunction

function! erlgoto#echo(text) abort
    echo join(a:text, "\n")
endfunction

function! erlgoto#float(text) abort
    let border_win = erlgoto#float#create_border_win(a:text)
    redraw

    let [border_row, border_col] = nvim_win_get_position(border_win)
    let [text_row, text_col] = [border_row+1, border_col+1]

    let text_win = erlgoto#float#create_text_win(a:text, text_col, text_row)
    redraw

    call erlgoto#echohl('Type', 'Press any key to close')
    try
        call getchar()
    catch /^Vim:Interrupt$/
    finally
        execute "normal \<C-L>"
        call nvim_win_close(text_win, 1)
        call nvim_win_close(border_win, 1)
    endtry
endfunction

function! erlgoto#choose(definitions) abort
    let definitions = erlgoto#def#number_definitions(a:definitions)
    let definitions = erlgoto#def#pad_line_nrs(definitions)
    let def_output = erlgoto#def#def_list_output(definitions)
    for item in def_output
        call erlgoto#echohl(item.hl, item.text)
    endfor

    let instructions = 'Input <count><action>. <action>.'
                \ . '<action>: <g>oto, <s>plit, <v>split, <e>cho, <f>loat.'
                \ . "\nAnything else aborts."
    call erlgoto#echohl('WarningMsg', instructions)

    let count = nr2char(getchar())
    if count !~ '\d'
        redraw
        return
    endif

    let count_val_error = erlgoto#validate_count(count, a:definitions)
    if empty(count_val_error)
        let action_abbreviation = nr2char(getchar())
    else
        redraw
        call erlgoto#echo_warning(count_val_error)
        return {}
    endif

    if 'gsvef' !~# action_abbreviation
        redraw
        call erlgoto#echo_warning('Action must be one of g, s, v, e or f')
        return {}
    endif

    redraw
    let action = {'g': 'edit', 's': 'split', 'v': 'vsplit', 'e': 'echo',
                \ 'f': 'float'}[action_abbreviation]

    return {'count': count, 'action': action}
endfunction

function! erlgoto#validate_count(count, definitions) abort
    if a:count < 1
        return 'Count must be greater than 0'
    elseif a:count > len(a:definitions)
        return 'Count (' . a:count . ') higher than number of definitions ('
                    \ . len(a:definitions) . ')'
    else
        return ''
    endif
endfunction

function! erlgoto#echohl(highlight_group, text) abort
    execute 'echohl ' . a:highlight_group
    echon  a:text
    echohl None
endfunction

function! erlgoto#echo_warning(string) abort
    call erlgoto#echohl('WarningMsg', 'erlgoto: ' . a:string)
endfunction
