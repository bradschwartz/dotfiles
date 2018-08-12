# System Variables
export PS1='[\W]\$ '
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT='%d/%m/%y %T '

export EDITOR=emacs;
export VIEWER=emacs;

export PYTHONSTARTUP=$HOME/.pythonrc.py
export PIP_CONFIG_FILE=$HOME/.pip.conf

export PATH=~/Library/Python/3.6/bin:/usr/local/opt/python/libexec/bin:$PATH

# Source necessary files
for f in $HOME/{.aliases,.brew_credentials,.twitter/credentials};do
    if [ -e $f ];then
       . $f
    fi
done

# Forward bash search
stty -ixon

# Auto-complete for google-cloud-sdk
# source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc'
# source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'
