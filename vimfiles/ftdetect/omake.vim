augroup filetypedetect
 au BufRead,BufNewFile *.om,OMakefile,OMakeroot setf omake " set filetype only once
 "au BufRead,BufNewFile *.om,OMakefile,OMakeroot setl filetype=omake " set filetype always
augroup END
