"" メモ：
"" タブ・スペース表示
" :set list
"" キーワードに一致する最初の行にジャンプ
" [<Tab>
"" キーワードに一致する最初の行を表示
" [i
"" 位置マークとマークした位置までのヤンク
" mx -> y`x (xは任意のa-z)
"" bufferのリストを表示
" :ls " get the buffer number
"" 最後に閉じたタブを開く
" :tabnew +Nbuf " where N is the buffer number
" :tabnew #
"" ジャンプコマンドを実行した直前の位置に戻る
" C-' C-'
"" タグジャンプ
" C-]     カーソル位置の単語をタグとみなしてジャンプ。
" C-t     直前のタグに戻る。
" g C-]   複数候補がある場合に選択→ジャンプ。
" C-w }   カーソル位置の単語の定義を、プレビューウィンドウで開く。
" C-w C-z プレビューウィンドウを閉じる。(:pcと同じ)
"" 直前の選択範囲を再選択
" gv

if filereadable(expand("~/.vim/vundle.vim"))
  source ~/.vim/vundle.vim
endif

if filereadable(expand("~/.exrc"))
  source ~/.exrc
endif
if filereadable(expand("~/.vimrc_local"))
  source ~/.vimrc_local
endif
if filereadable(expand("~/.vim/autosession.vim"))
  source ~/.vim/autosession.vim
endif

syntax on
filetype on
filetype plugin on
hi Search ctermbg=14

" Behavior
set switchbuf=usetab

" Searching
set ignorecase
set smartcase
set hlsearch
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

" Indent
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
inoremap <C-f> <Right>

" Centering in searching
nnoremap n nzz
nnoremap N Nzz
nnoremap j gj
nnoremap k gk

"" Buffer Explorer plugin
"" '\be' (normal open)  or
"" '\bs' (force horizontal split open)  or
"" '\bv' (force vertical split open) 
nmap <C-l> <leader>be

" Normal Mode Keymap(Unmap with :nunmap <KeyMap>)
nnoremap ; :

" ignoring netwr files
let g:netrw_list_hide= '.*\.meta$,.*\.swp$,\.DS_Store'


" Looks
set number
set ruler
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
