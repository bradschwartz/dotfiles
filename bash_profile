#!/usr/bin/env bash

# System Variables
export PS1='[\W\e[0;32m$(__git_ps1)\e[m]\$ '
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT='%d/%m/%y %T '

export EDITOR=emacs;
export VIEWER=emacs;

export PYTHONSTARTUP=$HOME/.pythonrc.py
export PIP_CONFIG_FILE=$HOME/.pip.conf

export PATH=/Users/Brad/Library/Python/3.7/bin:~/Library/Python/3.6/bin:/usr/local/opt/python/libexec/bin:$PATH

# Source necessary files
for f in $HOME/{.aliases,.brew_credentials,.twitter/credentials};do
    if [ -e $f ];then
       . $f
    fi
done

# Forward bash search
stty -ixon

# Java settings
export JAVA_HOME=$(/usr/libexec/java_home)

# Bash
BREW_COMPLETE=/usr/local/etc/bash_completion.d
. $BREW_COMPLETE/git-completion.bash
. $BREW_COMPLETE/git-prompt.sh
complete -C  '/usr/local/bin/aws_completer' aws
