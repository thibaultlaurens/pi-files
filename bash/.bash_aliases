#!/bin/bash

# Autocorrect typos in path names when using `cd`.
shopt -s cdspell;

# Navigation.
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Shortcuts.
alias c="clear"
alias h="history"

# Default options.
alias cp="cp -iv"
alias rm="rm -Iv"
alias mkdir="mkdir -pv"
alias ll='ls -FGlahp --color=always'
alias ps="ps -ef"
alias less="less -FSRXc"
alias grep='grep --color=auto'
alias df="df -Th"
alias du="du -ach | sort -h"

# Reload the shell.
alias reload='exec $SHELL -l'

# Check temperature and voltage.
alias temp="sudo /opt/vc/bin/vcgencmd measure_temp"
alias volts="sudo /opt/vc/bin/vcgencmd measure_volts"

# Internal IP.
alias myip="ip -4 addr | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"

# Quickly check the ssh jail.
alias jail-sshd="sudo fail2ban-client status sshd"

# List enabled services.
alias systemctl-enabled="systemctl list-unit-files | grep enabled"

# Updater shortcut.
function apt-updater {
	  sudo apt update && \
	      sudo apt full-upgrade -Vy && \
	      sudo apt autoremove -y && \
	      sudo apt autoclean
}

# Always list directory contents upon 'cd'.
function cd() {
    builtin cd "$@" || exit
    ll
}

# Make vim the default editor.
export EDITOR="vim"

# Don’t clear the screen after quitting a manual page.
PAGER="less -FirSwX"
MANPAGER="$PAGER"
export PAGER MANPAGER

# Get colors in manual pages.
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Make new shells get the history lines from all previous
# shells instead of the default "last window closed" history.
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Run neofetch when bashrc is sourced.
if hash neofetch 2>/dev/null; then
    neofetch
fi
