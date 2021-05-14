let s:default_opts = {'anchor': 'NW', 'style': 'minimal'}
function! erlgoto#float#width(text) abort
    return max(map(deepcopy(a:text), 'strdisplaywidth(v:val)'))
endfunction

function! erlgoto#float#height(text) abort
    return len(a:text)
endfunction

function! erlgoto#float#border_contents(width, height) abort
    let top    = '╭' . repeat('─', a:width) . '╮'
    let bottom = '╰' . repeat('─', a:width) . '╯'
    return [top] + map(range(a:height), '"│" . repeat(" ", a:width) . "│"') + [bottom]
endfunction

function! erlgoto#float#create_border_win(text) abort
    let width = erlgoto#float#width(a:text)
    let height = erlgoto#float#height(a:text)
    let border_contents = erlgoto#float#border_contents(width, height)
    let border_buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(border_buf, 0, -1, v:true, border_contents)
    let opts = {'relative': 'cursor', 'width': width+2, 'height': height+2,
                \ 'col': 0, 'row': 1}
    call extend(opts, s:default_opts)
    let border_win = nvim_open_win(border_buf, v:false, opts)
    call nvim_win_set_option(border_win, 'winhl', 'Normal:Normal')
    return border_win
endfunction

function! erlgoto#float#create_text_win(text, col, row) abort
    let width = erlgoto#float#width(a:text)
    let height = erlgoto#float#height(a:text)
    let text_buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(text_buf, 0, -1, v:true, a:text)
    call nvim_buf_set_option(text_buf, 'filetype', 'erlang')
    let opts = {'relative': 'editor', 'width': width, 'height': height,
                \ 'col': a:col, 'row': a:row}
    call extend(opts, s:default_opts)
    let text_win = nvim_open_win(text_buf, v:true, opts)
    call nvim_win_set_option(text_win, 'winhl', 'Normal:Normal')
endfunction
