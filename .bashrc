# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# update path lookup
export PATH=~/code/bioutils/scripts:${PATH}

# make the shell more informative (\h: host, \D: date, \A: time, \w: working directory):
export PS1="\h \D{%F}_\A \w> "

# User specific aliases and functions
source ~/.alias

# Keep all shell history (https://spin.atomicobject.com/2016/05/28/log-bash-history/)
export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%F.%T") $(pwd) $(history 1)" >> ~/my-bash-history.log; fi'

