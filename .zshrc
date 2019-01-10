export LANG=ja_JP.UTF-8
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

local BLUE=$'%{\e[1;34m%}'

if [[ -f ~/.zsh_profile ]]; then
  source ~/.zsh_profile
fi

## key binding
#bindkey -v # vi
bindkey -e # emacs

## 補完機能の強化
autoload -U compinit

# Platform-specific
OS_NAME=`uname -s`
if [[ "${OS_NAME}" =~ ^(MINGW32_NT|CYGWIN_NT) ]]; then
  # Windows
  compinit -u
else
  compinit
  ## コアダンプサイズを制限
  limit coredumpsize 102400
fi

## プロンプトの設定
autoload colors
colors

# VCS settings
autoload -Uz vcs_info
zstyle ":vcs_info:git:*" formats "%c%u[%b]"
zstyle ":vcs_info:git:*" actionformats "%c%u<%a>[%b]"
precmd() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  psvar[1]=$vcs_info_msg_0_
}

case ${UID} in
0)
  PROMPT="%{%B%}%{${fg[cyan]}%}%n@%m%{${reset_color}%}%{%b%}:%{${fg[blue]}%}%/%{${reset_color}%}# "
  PROMPT2="%B%{${fg[blue]}%}%_#%{${reset_color}%}%b "
  SPROMPT="%B%{${fg[blue]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
  RPROMPT=""
  ;;
*)
  #PROMPT="[%n@%m] %{${fg[blue]}%}#%{${reset_color}%} "
  PROMPT="%{%B%}%{${fg[cyan]}%}%n@%m%{${reset_color}%}%{%b%}:%{${BLUE}%}%~%{${reset_color}%}%{${fg[red]}%}%1v%{${reset_color}%}$ "
  PROMPT2="%B%{${fg[blue]}%}%_#%{${reset_color}%}%b "
  SPROMPT="%B%{${fg[blue]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
  RPROMPT="%T"
  ;;
esac

## 出力の文字列末尾に改行コードが無い場合でも表示
unsetopt promptcr

## 色を使う
setopt prompt_subst

## ビープを鳴らさない
setopt nobeep

## 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs

## 補完候補一覧でファイルの種別をマーク表示
setopt list_types

## サスペンド中のプロセスと同じコマンド名を実行した場合はリジューム
setopt auto_resume

## 補完候補を一覧表示
setopt auto_list

## 補完候補を詰めて表示
setopt list_packed

## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups

## cd 時に自動で push
setopt autopushd

## 同じディレクトリを pushd しない
setopt pushd_ignore_dups

## ファイル名で #, ~, ^ の 3 文字を正規表現として扱う
setopt extended_glob

## TAB で順に補完候補を切り替える
setopt auto_menu

## zsh の開始, 終了時刻をヒストリファイルに書き込む
setopt extended_history

## =command を command のパス名に展開する
setopt equals

## --prefix=/usr などの = 以降も補完
setopt magic_equal_subst

## ヒストリを呼び出してから実行する間に一旦編集
setopt hist_verify

# ファイル名の展開で辞書順ではなく数値的にソート
setopt numeric_glob_sort

## 出力時8ビットを通す
setopt print_eight_bit

## ヒストリを共有
setopt share_history

## 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1

## 補完候補の色づけ
#eval `dircolors`
export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

## ディレクトリ名だけで cd
setopt auto_cd

## カッコの対応などを自動的に補完
setopt auto_param_keys

## ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

## スペルチェック
setopt correct

# ^S as history-incremental-search-forward
stty stop undef

## エイリアス
setopt complete_aliases

case "${OSTYPE}" in
  freebsd*|darwin*)
    alias ls="ls -G -w"
    ;;
  linux*)
    alias ls="ls --color"
    ;;
esac
alias la="ls -a"
alias lf="ls -F"
alias ll="ls -la"
alias du="du -h"
alias df="df -h"

alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

alias tree="pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/| /g'"

## 最後のスラッシュを自動的に削除しない
setopt noautoremoveslash

## 検索
export TEXT_BROWSER=w3m

function _space2p20
{
  echo $@ |sed -e "s/ /%20/g"
}

function _space2plus
{
  echo $@ | sed -e "s/ /+/g"
}

function google
{
  ${TEXT_BROWSER} "http://www.google.co.jp/search?q="`_space2plus $@`"&hl=ja"
}

function ydic
{
  ${TEXT_BROWSER} "http://dic.yahoo.co.jp/dsearch?enc=UTF-8&p="`_space2plus $@`"&stype=0&dtype=2"
}

function technorati
{
  ${TEXT_BROWSER} http://www.technorati.com/search/`_space2p20 $@`"?language=ja"
}

function wikipedia
{
  ${TEXT_BROWSER} http://ja.wikipedia.org/wiki/`_space2p20 $@`
}

# for golang
export GOPATH=$HOME/.go
export PATH="$GOPATH/bin:$PATH"

case ${OSTYPE} in
  darwin*)
    # For Mac settings
    if [[ -f ~/.zshrc.osx ]]; then
      source ~/.zshrc.osx
    fi
    ;;
esac

export GRAPHVIZ_DOT=/opt/local/bin/dot

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
