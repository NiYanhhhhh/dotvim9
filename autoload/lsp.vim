vim9script

import autoload "lsp/lsp.vim"

var lsp_texlab = {
    filetype: ['tex'],
    path: '/usr/bin/texlab'
}

var lsp_vimls = {
    filetype: ['vim'],
    path: '/usr/bin/vim-language-server',
    args: ['--stdio'],
    initializationOptions: {
        diagnostic: {
            enable: v:false
        },
        indexes: {
            runtimepath: true,
            gap: 100,
            count: 3,
            projectRootPatterns: [".git", ".root"]
        },
        suggest: {
            fromVimruntime: v:true,
            fromRuntimepath: v:false
        }
    }
}

g:lsp_servers = [
    lsp_texlab,
    lsp_vimls
]

export def LspSetup()
    var opts = {
        outlineOnRight: v:true,
        showSignature: v:false
    }
    lsp.AddServer(g:lsp_servers)
    call keymap#lsp()
enddef
