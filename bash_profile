#!/usr/bin/env bash


# System Variables

stty -ixon # Forward bash search
export PS1='[\W]\$ '
#export PS1='[\W\e[0;32m$(__git_ps1)\e[m]\$ '
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT='%d/%m/%y %T '

export EDITOR=emacs;
export VIEWER=emacs;

export PYTHONSTARTUP=$HOME/.pythonrc.py
export PIP_CONFIG_FILE=$HOME/.pip.conf

PATH="/usr/local/sbin:/usr/local/opt/ruby/bin:$HOME/.gem/ruby/2.6.0/bin:$PATH"
export PATH

# Source necessary files
for f in $HOME/{.aliases,.brew_credentials,.twitter/credentials};do
    if [ -e "$f" ];then
       . "$f"
    fi
done



# Java settings
export JAVA_HOME=$(/usr/libexec/java_home)

# Bash
BREW_COMPLETE=/usr/local/etc/bash_completion.d
. $BREW_COMPLETE/git-completion.bash
. $BREW_COMPLETE/git-prompt.sh
complete -C  '/usr/local/bin/aws_completer' aws

# Homebrew
export HOMEBREW_AUTO_UPDATE_SECS=3600
export SPARK_SHELL=/usr/local/opt/apache-spark/libexec/
