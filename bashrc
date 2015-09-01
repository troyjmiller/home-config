export CONFIG=$HOME/repos/home-config
export SKILSTAK=/usr/share/skilstak
export TERM=xterm-256color

if [ ! $TERM = 'screen' ]; then
  # bail if somehow non-interactive
  [ -z "$PS1" ] && return 2>/dev/null
fi

[ -z "$OS" ] && OS=`uname`
case "$OS" in
  *indows* )        PLATFORM=windows ;;
  Linux )           PLATFORM=linux ;;
  FreeBSD|Darwin )  PLATFORM=bsd ;;
esac
export PLATFORM OS

HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
shopt -s checkwinsize
HISTSIZE=1000
HISFILESIZE=2000
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
set -o notify
set -o noclobber
set -o ignoreeof
set bell-style none

#---------------------------------- Path ----------------------------------

repopaths() {
  local repopath=`find $HOME/repos -maxdepth 1 -type d -print0 2>/dev/null| tr '\0' ':'i`
  local repobinpath=`find $HOME/repos -maxdepth 2 -type d -name 'bin' -print0 2>/dev/null| tr '\0' ':'`
  echo "$repopath$repobinpath"
}

repath() {
  export GOPATH=$HOME/go
  export PATH=\
./:\
./bin:\
"$HOME/bin":\
"$CONFIG/bin":\
"$SKILSTAK/bin":\
"$GOPATH/bin":\
`repopaths`\
/usr/games:\
/usr/local/go/bin:\
/usr/local/bin:\
/usr/bin:\
/bin:\
/usr/local/sbin:\
/usr/sbin:\
/sbin
}
repath

alias path='echo -e ${PATH//:/\\n}'
alias config="cd $CONFIG"

if [ -x /usr/bin/dircolors ]; then
  if [ -r ~/.dircolors ]; then
    eval "$(dircolors -b ~/.dircolors)"
  elif [ -r /usr/share/skilstak/dircolors ]; then 
    eval "$(dircolors -b /usr/share/skilstak/dircolors)"
  else
    eval "$(dircolors -b)"
  fi
fi

if [ $PLATFORM != 'bsd' ]; then
	alias ls='ls -h --color=auto'
else
  export CLICOLOR=1
	export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
fi

alias more='less -r'
alias pytest='nosetests'
alias pyinstall='sudo pip3 install --upgrade .'
alias runallpy='for i in *.py;do python3 $i; done'
alias jsonpp='json_pp'
alias todo='note todo'

export PYTHONDONTWRITEBYTECODE=true
export PYTHONPATH=$HOME/lib/python:$CONFIG/lib/python:$SKILSTAK/lib/python

alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.
alias ll='ls -lv'
alias lm='ll |more'        #  Pipe through 'more'
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.

alias listens='netstat -tulpn'
alias ip="ifconfig | perl -ne '/^\s*inet (?:addr)?/ and print'"

alias repos='cd "$HOME/repos"'
alias root='sudo su -'

#------------------------------- Web Dev ----------------------------------

if [ `which jade.js` ]; then
    alias jade=jade.js
fi

#---------------------------- Solarized Prompt ----------------------------

export c_base03='\033[1;30m'
export c_base02='\033[0;30m'
export c_base01='\033[1;32m'
export c_base00='\033[1;33m'
export c_base0='\033[1;34m'
export c_base1='\033[1;36m'
export c_base2='\033[0;37m'
export c_base3='\033[1;37m'
export c_yellow='\033[0;33m'
export c_orange='\033[1;31m'
export c_red='\033[0;31m'
export c_magenta='\033[0;35m'
export c_violet='\033[1;35m'
export c_blue='\033[0;34m'
export c_cyan='\033[0;36m'
export c_green='\033[0;32m'
export c_reset='\033[0m'
export c_clear='\\\033[H\\\033[2J'

alias promptbig='export PS1="\n\[$c_red\]╔ \[$c_green\]\T \d \[${c_orange}\]\u@\h\[$base01\]:\[$c_blue\]\w$gitps1\n\[$c_red\]╚ \[$c_cyan\]\\$ \[$c_reset\]"'
alias promptmed='export PS1="\[${c_base1}\]\u\[$c_base01\]@\[$c_base00\]\h:\[$c_yellow\]\W\[$c_cyan\]\\$ \[$c_reset\]"'
alias promptpwd='export PS1="\[${c_base01}\]\W\[$c_cyan\]\\$ \[$c_reset\]"'
alias promptnone='export PS1="\[$c_cyan\]\\$ \[$c_reset\]"'

promptmed

#-------------------------------- Vim-ish ---------------------------------

set -o vi

if [ "`which vim 2>/dev/null`" ]; then
  export EDITOR=vim
  alias vi=vim
else
  export EDITOR=vi
fi

#---------------------------- personalization -----------------------------

# mostly for those that do now want to maintain their own bashrc but
# still want a repo-centric bash config

[ -e "$HOME/repos/personal/bashrc" ] && . "$HOME/repos/personal/bashrc" 
[ -e "$HOME/repos/private/bashrc" ] && . "$HOME/repos/private/bashrc" 

