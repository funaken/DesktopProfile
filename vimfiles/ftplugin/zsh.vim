"zsh.vim
"setlocal smarttab
"setl fileencoding=utf-8         " file encoding
setl autoindent                 " 自動インデント
"setl textwidth=80               " 文字数/行
"setl smartindent                " 高度なインデントを行う
"smartindent より cindent の処理の方が厳密 
setl smartindent cinwords=if,else,for,while,do,try,catch,finally,class,struct,enum,union
setl tabstop=2                  " タブ幅
setl expandtab                  " タブ入力時にスペースで置換する
setl shiftwidth=2               " インデントの各段階に使われる空白の数
setl softtabstop=2              " <Tab>, <BS>を使用して編集する際の<Tab>の対応する空白の数
setl nosmarttab                   " 行頭で<Tab>を押した時に shiftwidth に対応して空白を挿入する

