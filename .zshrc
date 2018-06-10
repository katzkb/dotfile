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
alias dckm="docker exec -it kintai_mysql"
alias dckw="docker exec -it kintai_web"

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

eval "$(anyenv init - --no-rehash)"

export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"
export PATH="/usr/local/opt/bison/bin:$PATH"
export PATH="/usr/lib/:$PATH"

if [ $DOTFILES/.zshrc -nt ~/.zshrc.zwc ]; then
  zcompile ~/.zshrc
fi

echo -e "
   __    ____  ____    __       ___  _____  __  __  ____   __    _  _  _  _ 
  /__\  (  _ \(_  _)  /__\     / __)(  _  )(  \/  )(  _ \ /__\  ( \( )( \/ )
 /(__)\  )   / _)(_  /(__)\   ( (__  )(_)(  )    (  )___//(__)\  )  (  \  / 
(__)(__)(_)\_)(____)(__)(__)   \___)(_____)(_/\/\_)(__) (__)(__)(_)\_) (__) 

01000001 01010010 01001001 01000001  01000011 01001111 01001101 01010000 01000001 01001110 01011001 

"
