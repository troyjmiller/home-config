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
/usr/local/go/bin:\
"$HOME/bin":\
"$HOME/repos/workspace/bin":\
"$GOPATH/bin":\
`repopaths`\
/usr/local/bin:\
/usr/games:\
/usr/bin:\
/bin:\
/usr/local/sbin:\
/usr/sbin:\
/sbin
}
repath

alias path='echo -e ${PATH//:/\\n}'

#---------------------------------- ssh ----------------------------------

start_ssh_agent() {
  SSHAGENT=/usr/bin/ssh-agent
  SSHAGENTARGS="-s"
  if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
    eval `$SSHAGENT $SSHAGENTARGS`
    trap "kill $SSH_AGENT_PID" 0
  fi
}

_ssh() {
  local list=`perl -ne 'print "$1 " if /\s*Host\s+(\S+)/' ~/.ssh/config`
  local typed=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$list" -- $typed))
}
complete -F _ssh ssh

# only enter a ssh password once, just enough to send the public key
# and yeah, I only use RSA (http://security.stackexchange.com/a/51194/39787)
pushsshkey() {
  local id=$1
  local host=$2
  cat ~/.ssh/${id}_rsa.pub | ssh $host '( [ ! -d "$HOME/.ssh" ] && mkdir "$HOME/.ssh"; cat >> "$HOME/.ssh/authorized_keys2" )'
}

# changes the default ssh IdentityFile, expects no leading whitespace
sshid() {
  local id=$1
  rm ~/.ssh/config.bak 2>/dev/null
  perl -p -i.bak -e "s/^IdentityFile.*$/IdentityFile ~\/.ssh\/${id}_rsa/i" ~/.ssh/config
  rm ~/.ssh/config.bak 2>/dev/null
  start_ssh_agent
  ssh-add ~/.ssh/${id}_rsa
}

#--------------------------- Utility Functions ----------------------------

has() {
  type "$1" > dev/null 2>&1
  return $?
}

pcwd() {
  ls -l /proc/$1 |grep cwd
}

preserve() {
    [ -e "$1" ] && mv "$1" "$1"_`date +%Y%m%d%H%M%S`
}

if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors \
    && eval "$(dircolors -b ~/.dircolors)" \
    || eval "$(dircolors -b)"
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
export PYTHONDONTWRITEBYTECODE=true

alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.
alias ll='ls -lv'
alias lm='ll |more'        #  Pipe through 'more'
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.

llastf() {
  # recursively lists all files in reverse chronological order of
  # when they were last modified
  top=$1
  [ "$1" = "" ] && top=.
  find $top -type f -printf '%TY-%Tm-%Td %TT %p\n' |sort -r
}

llastd() {
  # same but directories
  top=$1
  [ "$1" = "" ] && top=.
  find $top -type d -printf '%TY-%Tm-%Td %TT %p\n' |sort -r
}

lall() {
  find . -name "*$1*"
}

grepall() {
  find . \( ! -regex '.*/\..*' \) -type f -exec grep "$1" {} /dev/null \;
}

# why perl versions that could do with bash param sub? bourne compat
join() {
  perl -e '$d=shift; print(join($d,@ARGV))' "$@"
}

# no basename is not the same
chompsuf() {
  perl -e '@l=grep{s/\.[^\.]+$//}@ARGV;print"@l"' "$@"
}

resuf() {
  _from=$1
  _to=$2
  shift 2
  for _name in "$@"; do
    case $_name in
      *.$_from)
        _new=`chompsuf $_name`.$_to
        echo "$_name -> $_new"
        mv $_name $_new
        ;;
    esac
  done
  unset _from _to _name _new
}

#-------------------------------- PowerGit --------------------------------

export GITURLS=\
"$HOME/.giturls":\
"$HOME/config/giturls":\
"$HOME/repos/personal/giturls":\
"$HOME/repos/private/giturls"
alias gurlpath='echo -e ${GITURLS//:/\\n}'

repo() {
  if [ -z "$1" ]; then 
    /bin/ls -1 "$HOME/repos"
  else
    cd "$HOME/repos/$1"
  fi
}
alias gcd=repo
alias repos='cd "$HOME/repos"'

gget() {
  name=`basename $1`
  git clone git@github.com:$1 $HOME/repos/$name
  repath
}

save() {
  comment=save
  [ ! -z "$*" ] && comment="$*"
  git pull
  git add -A .
  git commit -a -m "$comment"
  git push
}

_repo() {
  local list=`repo`
  local typed=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$list" -- $typed))
}
complete -F _repo repo

#------------------------------- Web Dev ----------------------------------

if [ `which jade.js` ]; then
    alias jade=jade.js
fi

#---------------------------- Solarized Prompt ----------------------------

# solarized ansicolors (exporting for grins)
export SOL_base03='\033[1;30m'
export SOL_base02='\033[0;30m'
export SOL_base01='\033[1;32m'
export SOL_base00='\033[1;33m'
export SOL_base0='\033[1;34m'
export SOL_base1='\033[1;36m'
export SOL_base2='\033[0;37m'
export SOL_base3='\033[1;37m'
export SOL_yellow='\033[0;33m'
export SOL_orange='\033[1;31m'
export SOL_red='\033[0;31m'
export SOL_magenta='\033[0;35m'
export SOL_violet='\033[1;35m'
export SOL_blue='\033[0;34m'
export SOL_cyan='\033[0;36m'
export SOL_green='\033[0;32m'
export SOL_reset='\033[0m'

sol() {
  local color_var=\$"SOL_"$1
  eval local color=$color_var
  while read line
  do
    echo -e "$color$line$SOL_reset"
  done
}

alias promptbig='export PS1="\n\[$SOL_red\]╔ \[$SOL_green\]\T \d \[${SOL_orange}\]\u@\h\[$base01\]:\[$SOL_blue\]\w$gitps1\n\[$SOL_red\]╚ \[$SOL_cyan\]\\$ \[$SOL_reset\]"'
alias promptmed='export PS1="\[${SOL_base1}\]\u\[$SOL_base01\]@\[$SOL_base00\]\h:\[$SOL_yellow\]\W\[$SOL_cyan\]\\$ \[$SOL_reset\]"'
alias promptpwd='export PS1="\[${SOL_base01}\]\W\[$SOL_cyan\]\\$ \[$SOL_reset\]"'
alias promptnone='export PS1="\[$SOL_cyan\]\\$ \[$SOL_reset\]"'

# default
#export PS1="\[${SOL_base0}\]\u\[$SOL_base01\]@\[$SOL_base00\]\h:\W\[$SOL_cyan\]\\$ \[$SOL_reset\]"
promptmed

alias listens='netstat -tulpn'
alias ip="ifconfig | perl -ne '/^\s*inet addr/ and print'"

#-------------------------------- Vim-ish ---------------------------------

set -o vi
if [ "`which vim 2>/dev/null`" ]; then
  export EDITOR=vim
  alias vi=vim
else
  export EDITOR=vi
fi

textfiles() {
  local list=`find . -name "*$**" ! -path '*images*' ! -type d`
  echo $list
}



#---------------------------- personalization -----------------------------

# mostly for those that do now want to maintain their own bashrc but
# still want a repo-centric bash config

[ -e "$HOME/repos/personal/bashrc" ] && . "$HOME/repos/personal/bashrc" 
[ -e "$HOME/repos/private/bashrc" ] && . "$HOME/repos/private/bashrc" 

export TERM=xterm-256color

alias root='sudo su -'
alias week="cd $HOME/repos/week"
 
export PYTHONPATH=$HOME/repos/python-0:$HOME/repos/python-1:$HOME/repos/python-2:$HOME/lib/python
export SOL_clear='\\\033[H\\\033[2J'
