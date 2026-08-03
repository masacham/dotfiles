#
# ~/.bashrc
#

# ~/.zshrc または ~/.bashrc に追記
export EDITOR='nvim'
export VISUAL='nvim'

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
