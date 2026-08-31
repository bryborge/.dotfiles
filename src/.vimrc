set nocompatible

syntax on
colorscheme monokai

set ruler      " Show the current row and column at the bottom right of screen.
set showmode   " Show current mode at the bottom of screen.
set number     " Show line numbers.
set visualbell " No sounds!

set tabstop=4     " Number of spaces a <Tab> counts for.
set shiftwidth=4  " Number of spaces to use for each step of (auto)indent.
set softtabstop=4 " Number of spaces a <Tab> counts for while editing.

" Highlight text that goes over the 80 column limit
au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
