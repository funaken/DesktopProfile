" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/vundle/
call vundle#rc()
" Vundle本体
Bundle 'gmarik/vundle'
Bundle 'Shougo/unite.vim'
"Bundle 'bundle/VimClojure'
"let vimclojure#WantNailgun = 1
"let vimclojure#NailgunClient = "ng"

filetype plugin indent on
