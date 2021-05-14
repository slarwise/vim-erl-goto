function! erlgoto#def#init(path, start_line, end_line, start_col, lines) abort
    return {
                \ 'path': a:path,
                \ 'line': a:start_line+1,
                \ 'col': a:start_col+1,
                \ 'text': a:lines[a:start_line:a:end_line]
                \ }
endfunction

function! erlgoto#def#number_definitions(defs) abort
    let nr = 0
    for def in a:defs
        let nr = nr + 1
        let def.nr = nr
    endfor
    return a:defs
endfunction

function! erlgoto#def#pad_line_nrs(defs) abort
    let line_nrs = map(copy(a:defs), 'v:val.line')
    let line_nr_padding = max(map(line_nrs, 'len(v:val)'))
    for def in a:defs
        let pad = repeat(' ', line_nr_padding-strdisplaywidth(def.line))
        let def.line = pad . def.line
    endfor
    return a:defs
endfunction

function! erlgoto#def#path_output(def) abort
    return [{'hl': 'Function', 'text': a:def.path . "\n"}]
endfunction

function! erlgoto#def#preview_output(def) abort
    return [
                \ {'hl': 'None', 'text': '  ' . a:def.nr . ':  '},
                \ {'hl': 'Comment', 'text': a:def.line . ' '},
                \ {'hl': 'None', 'text': a:def.text[0] . "\n"}
                \ ]
endfunction

function! erlgoto#def#def_list_output(defs) abort
    let output = []
    let current_path = ''
    for def in a:defs
        if def.path !=# current_path
            call extend(output, erlgoto#def#path_output(def))
            let current_path = def.path
        endif
        call extend(output, erlgoto#def#preview_output(def))
    endfor
    return output
endfunction
