# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions

PATH=$PATH:/sbin
PATH=/opt/local/bin:/opt/local/sbin/:$PATH
MANPATH=/opt/local/man:$MANPATH

export PS1="\[\e]0;\u@\h: \w\a\]\[\033[01;36m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
alias ls="ls -G"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias vim="vim --remote-tab"

# unset stty stop
stty stop undef

#alias ls='ls -p --color=auto'

