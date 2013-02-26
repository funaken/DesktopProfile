let s:session_path = expand("~/.session.vim")

"save and close all files and save global session
nnoremap <leader>q :mksession! s:session_path<CR>:wqa<CR>
"close all files without saving and save global session
nnoremap <leader>www :mksession! s:session_path<CR>:qa!<CR>

function! SaveSession()
  execute ':mksession! ' . s:session_path
endfunction

function! RestoreSession()
  if argc() == 0 "vim called without arguments
    if filereadable(s:session_path)
      execute 'source ' s:session_path
    endif
  endif
endfunction

autocmd VimLeavePre * call SaveSession()
autocmd VimEnter * call RestoreSession()

