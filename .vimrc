" メモ：
" タブ・スペース表示
" :set list
" キーワードに一致する最初の行にジャンプ
" [<Tab>
" キーワードに一致する最初の行を表示
" [i
" 位置マークとマークした位置までのヤンク
" mx -> y`x (xは任意のa-z)
" 最後に閉じたタブを開く
" :ls " get the buffer number
" :tabnew +Nbuf " where N is the buffer number
" :tabnew #

syntax on
filetype on
filetype plugin on
hi Search ctermbg=14

" Looks
colorscheme railscasts
set number
set ruler
set transparency=20

set hlsearch
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set tabstop=4
" Auto change current directory
set autochdir
" Minimum Scroll when cursor moves out screen
set sj=3
" Scroll at <C-d> <C-u>
set scr=10

" Insert Mode Keymap(Unmap with :iunmap <KeyMap>)
inoremap <C-e> <End>
inoremap <C-d> <Del>
"inoremap <C-h> <Left>
inoremap <C-b> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap {} {}<LEFT>
inoremap [] []<LEFT>
inoremap () ()<LEFT>
inoremap "" ""<LEFT>
inoremap '' ''<LEFT>
inoremap <> <><LEFT>

" Normal Mode Keymap(Unmap with :nunmap <KeyMap>)
nnoremap ; :
nnoremap : ;

" Centering in searching
nnoremap n nzz
nnoremap N Nzz

if filereadable(expand("~/.exrc"))
  source ~/.exrc
endif
if filereadable(expand("~/.vimrc_local"))
  source ~/.vimrc_local
endif
