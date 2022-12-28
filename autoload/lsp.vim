vim9script

import autoload 'lsp/lsp.vim'

var lsp_texlab = {
    filetype: ['tex'],
    path: '/usr/bin/texlab'
}

g:lsp_servers = [
    lsp_texlab
]

export def LspSetup()
    lsp.AddServer(g:lsp_servers)
enddef
