function OpenWin() abort
    let buf = nvim_create_buf(v:false, v:true)
    let contents = [
                \ '╭──────────────────────────────╮',
                \ '│-module(math).                │',
                \ '│-type integer() :: integer()  │',
                \ '│                              │',
                \ '│add(X, Y) ->                  │',
                \ '│   X + Y,                     │',
                \ '│   ok.                        │',
                \ '╰──────────────────────────────╯',
                \ ]
    let width = max(map(deepcopy(contents), 'strdisplaywidth(v:val)'))
    let height = len(contents)
    call nvim_buf_set_lines(buf, 0, -1, v:true, contents)
    call nvim_buf_set_option(buf, 'filetype', 'erlang')
    let opts = {'relative': 'cursor', 'width': width, 'height': height,
                \ 'col': 0, 'row': 1, 'anchor': 'NW'}
    return nvim_open_win(buf, 0, opts)
endfunction

let g:win = OpenWin()

function CloseOnInput(timer_id)
    echohl Type | echo 'Press any key to close' | echohl None
    call getchar()
    echo ''
    call nvim_win_close(g:win, 1)
endfunction

call timer_start(0, 'CloseOnInput')
