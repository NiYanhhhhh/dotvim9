function markdown#view(url)
    call jobstart(['firefox', '--new-window', a:url])
endfunction
