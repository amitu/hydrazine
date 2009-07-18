if exists("loaded_gitdiff") || &compatible
    finish
endif
let loaded_gitdiff = 1

command! -nargs=? GITDiff :call s:GitDiff(<f-args>)

function! s:GitDiff(...)
    if a:0 == 1
        let rev = a:1
    else
        let rev = 'HEAD'
    endif

    let ftype = &filetype

    let prefix = system("git rev-parse --show-prefix")
    let gitfile = substitute(prefix,'\n$','','') . expand("%")

    " Check out the revision to a temp file
    let tmpfile = tempname()
    let cmd = "git show  " . rev . ":" . gitfile . " > " . tmpfile
    let cmd_output = system(cmd)
    if v:shell_error && cmd_output != ""
        echohl WarningMsg | echon cmd_output
        return
    endif

    " Begin diff
    exe "vert diffsplit" . tmpfile
    exe "set filetype=" . ftype
    set foldmethod=diff
    wincmd l

endfunction

