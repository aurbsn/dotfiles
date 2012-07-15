set nocompatible

set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftround
set nojoinspaces

syntax enable
filetype plugin indent on

set background=dark
colorscheme solarized

set ofu=syntaxcomplete#Complete

set textwidth=80 

set showmatch
set ruler
set incsearch

set history=10000

set visualbell

au BufEnter *.hs compiler ghc
let g:haddock_browser = "/usr/bin/firefox"
let g:ghc = "/usr/bin/ghc"
let g:haddock_docdir = "/usr/share/doc/ghc/html/"

function Kernel()
    set tabstop=8
    set shiftwidth=8
    set softtabstop=8
    set shiftwidth=8
    set noexpandtab
endfunction
