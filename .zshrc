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
# homebrew
export PATH=/opt/homebrew/bin:$PATH
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
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH" # x86_64
export PATH="/opt/homebrew/opt/mysql@5.7/bin:$PATH" # arm64
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH" # arm64

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
alias ys="yarn start"
alias ghc="git checkout develop"
alias nn="nnn -deHa -aP r"

alias gcleanup="$HOME/scripts/cleanup_branches.sh"

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

export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"
export PATH="/usr/local/opt/bison/bin:$PATH"
export PATH="/usr/lib/:$PATH"

# PATH
export PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:${PATH}
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# enable color support of ls and also add handy aliases
test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
alias ls='ls --g --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'

# go
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME
export GOLOCAL=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$GOLOCAL/bin

if [ $DOTFILES/.zshrc -nt ~/.zshrc.zwc ]; then
  zcompile ~/.zshrc
fi

export PATH="${HOME}/.scalaenv/bin:${PATH}"
eval "$(scalaenv init -)"
export PATH="/usr/local/opt/avr-gcc@7/bin:$PATH"
export PATH="/usr/local/opt/avr-gcc@8/bin:$PATH"

alias sed='gsed'
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
eval $(thefuck --alias)
fpath+=${ZDOTDIR:-~}/.zsh_functions

###-tns-completion-start-###
if [ -f /Users/katsuya.kubo/.tnsrc ]; then
    source "$HOME/.tnsrc"
fi
###-tns-completion-end-###

eval "$(fnm env --use-on-cd)"

#export PATH="$HOME/.jenv/bin:$PATH"
#eval "$(jenv init -)"

# Setting for angular project
export NODE_OPTIONS="--max-old-space-size=4096"

# Setting for kidsna-connect-wp local
export WORDPRESS_HOME="http://localhost/site"
export WORDPRESS_SITEURL="http://localhost/site"

# Angular 起動時のanalytics系質問を黙らせる
export NG_CLI_ANALYTICS=ci
# Alacrittyの通知バウンスを無効化
printf "\e[?1042l"

# Bun
## bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

## bun path
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(direnv hook zsh)"

eval "$(sheldon source)"

# NNN Settings
export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd" # always cd on quit

# NNN Plugins
export NNN_FIFO=/tmp/nnn.fifo
export NNN_PLUG='r:preview-tui'

export PATH="$PATH:$HOME/Library/Application Support/Coursier/bin"
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# additional prompt
export PROMPT="($(arch))$PROMPT"
export PATH="/opt/homebrew/sbin:$PATH"

# SDKMAN
#export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
#[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Android SDK
export PATH="$HOME/Library/Android/sdk:$PATH"


# Load Angular CLI autocompletion.
source <(ng completion script)

# for aqua cli https://aquaproj.github.io/docs/install/
export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH"

export GH_PAGER=cat 
