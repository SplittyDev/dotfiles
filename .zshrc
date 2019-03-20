#
# Author: Marco Quinten <splittydev@gmail.com>
# Description: A simple zshrc to aid productivity
#

# download antigen if needed
if [[ ! -a $HOME/antigen.zsh ]]; then
    echo Antigen not found! Installing...
    curl -L git.io/antigen > $HOME/antigen.zsh
    echo Antigen ready!
fi

# source antigen
source $HOME/antigen.zsh

# use the oh-my-zsh framework
antigen use oh-my-zsh

# full git productivity suite
antigen bundle git

# node support
antigen bundle npm
antigen bundle npx
antigen bundle nvm

# python support
antigen bundle python
antigen bundle pip

# rust support
antigen bundle rust
antigen bundle cargo
source $HOME/.cargo/env

# vim ctrl-z auto-unsuspend
antigen bundle fancy-ctrl-z

# esc-esc auto-sudo
antigen bundle sudo

# command-not-found handler
antigen bundle command-not-found

# syntax highlighting
antigen bundle zsh-users/zsh-syntax-highlighting

# huge completion suite
antigen bundle zsh-users/zsh-completions

# fish-like autosuggestions
antigen bundle zsh-users/zsh-autosuggestions

# z.lua
export _ZL_MATCH_MODE=1
export _ZL_ROOT_MARKERS=".git,.svn,.hg,.root,package.json"
antigen bundle skywind3000/z.lua
alias zz='z -c' # restrict matches to subdirs of $PWD
alias zi='z -i' # cd with interactive selection
alias zb='z -b' # quickly cd to the parent directory

# the best theme ever, period
antigen theme half-life

# magic
antigen apply

# aliases
if type "bat" > /dev/null; then alias cat='bat'; fi
