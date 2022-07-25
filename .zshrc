#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# key setting
bindkey -e

# n command
export N_PREFIX="$HOME/scripts/n"
export PATH="$N_PREFIX/bin:$PATH"
# path設定
path=($HOME/bin(N-/) /usr/local/go/bin(N-/) $path)
# Export basic
export PATH="$PATH:/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"
# composer
export COMPOSER_PATH="$HOME/.composer/vendor/bin"
# origin commands dir
export MY_SCRIPT_PATH="$HOME/scripts"
# dotfiles
export DOTFILES="$HOME/dotfile"
# go
export GOROOT="/usr/local/opt/go/libexec"
export GOPATH="$HOME/go"
# nodebrew
export NODEBREW_PATH="$HOME/.nodebrew/current/bin"
# anyenv
export ANYENV_PATH="$HOME/.anyenv/bin"
# pyenvさんに~/.pyenvではなく、/usr/loca/var/pyenvを使うようにお願いする
export PYENV_ROOT="/usr/local/var/pyenv"
export PYENV_PATH="$PYENV_ROOT:/shims"
# rbenv
export RVENV_SHIMS="$HOME/.rbenv/shims"
export RVENV_PATH="$HOME/.rbenv/bin"
# heroku
export HEROKU_PATH="/usr/local/heroku/bin"
# Export additional item
export PATH="$PATH:$COMPOSER_PATH:$MY_SCRIPT_PATH:$DOTFILES:$NODEBREW_PATH:$RVENV_SHIMS:$RVENV_PATH:$PYENV_PATH:$HEROKU_PATH:$ANYENV_PATH"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
#export SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX12.3.sdk

# 文字コード設定
export LANG=ja_JP.UTF-8

# 便利alias
alias where="command -v"
alias j="jobs -l"
alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"
alias llat="ls -lat"
alias llan="ls -lan"
alias lt="ls -alTr"
alias du="sudo du -d 1 -h"
alias df="df -h"
alias su="su -l"
alias cl="clear"
alias less="less -sNiMR --tilde --max-forw-scroll=1 --window=1 --shift 1"
alias his="history -E 1"
# alias git='hub'
# alias dckm="docker exec -it kintai_mysql"
# alias dckw="docker exec -it kintai_web"
alias ys="yarn start"
alias ghc="git checkout develop"

# No beep
setopt nolistbeep

# Omit "cd" and "ls"
setopt auto_cd
function chpwd() { ls }

# Share command history at multiple windows
setopt extended_history

# function git(){hub "$@"}

# omit git commands as g*
if [[ -d $(git --exec-path) ]]; then
  foreach file ($(git --exec-path)/git-*)
    eval "alias g${file/*git-/}='git ${file/*git-/}'"
  end
fi

# eval "$(anyenv init - --no-rehash)"

export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"
export PATH="/usr/local/opt/bison/bin:$PATH"
export PATH="/usr/lib/:$PATH"

# PATH
export PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:${PATH}

# Terminal
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# enable color support of ls and also add handy aliases
test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
alias ls='ls --g --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
#export COURSIER_TTL=1s
 
# nvm
#export NVM_DIR="$(readlink -f $HOME)/.nvm"
#source $(brew --prefix nvm)/nvm.sh
#unalias mysql

# go
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME
export GOLOCAL=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$GOLOCAL/bin

if [ $DOTFILES/.zshrc -nt ~/.zshrc.zwc ]; then
  zcompile ~/.zshrc
fi

#source ~/.bin/tmuxinator.zsh

#cd /Volumes/dev/kidzna-connect/

#
#echo -e "
#   __    ____  ____    __       ___  _____  __  __  ____   __    _  _  _  _ 
#  /__\  (  _ \(_  _)  /__\     / __)(  _  )(  \/  )(  _ \ /__\  ( \( )( \/ )
# /(__)\  )   / _)(_  /(__)\   ( (__  )(_)(  )    (  )___//(__)\  )  (  \  / 
#(__)(__)(_)\_)(____)(__)(__)   \___)(_____)(_/\/\_)(__) (__)(__)(_)\_) (__) 
#
# 01000001 01010010 01001001 01000001  01000011 01001111 01001101 01010000 01000001 01001110 01011001 

# "
export PATH="${HOME}/.scalaenv/bin:${PATH}"
eval "$(scalaenv init -)"
export HOMEBREW_GITHUB_API_TOKEN=b83d8ab2f881b0799a3084d8a75a9daf3bba5967
export PATH="/usr/local/opt/avr-gcc@7/bin:$PATH"
export PATH="/usr/local/opt/avr-gcc@8/bin:$PATH"

alias sed='gsed'
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
eval $(thefuck --alias)
fpath+=${ZDOTDIR:-~}/.zsh_functions

###-tns-completion-start-###
if [ -f /Users/katsuya.kubo/.tnsrc ]; then 
    source /Users/katsuya.kubo/.tnsrc 
fi
###-tns-completion-end-###

# place this after nvm initialization!
#autoload -U add-zsh-hook
#load-nvmrc() {
#  local node_version="$(nvm version)"
#  local nvmrc_path="$(nvm_find_nvmrc)"
#  if [ -n "$nvmrc_path" ]; then
#    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
#    if [ "$nvmrc_node_version" = "N/A" ]; then
#      nvm install
#    elif [ "$nvmrc_node_version" != "$node_version" ]; then
#      nvm use
#    fi
#  elif [ "$node_version" != "$(nvm version default)" ]; then
#    echo "Reverting to nvm default version"
#    nvm use default
#  fi
#}
#add-zsh-hook chpwd load-nvmrc
#load-nvmrc

eval "$(fnm env --use-on-cd)"

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# Setting for angular project
export NODE_OPTIONS="--max-old-space-size=2048"

# Setting for kidsna-connect-wp local
export WORDPRESS_HOME="http://localhost/site"
export WORDPRESS_SITEURL="http://localhost/site"

# Angular 起動時のanalytics系質問を黙らせる
export NG_CLI_ANALYTICS=ci
# Alacrittyの通知バウンスを無効化
printf "\e[?1042l"
