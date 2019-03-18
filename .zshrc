#
# Author: Marco Quinten <splittydev@gmail.com>
# Description: A simple zshrc to aid productivity
#

# download antigen if needed
if [[ ! -a $HOME/antigen.zsh ]]; then
    curl -L git.io/antigen > $HOME/antigen.zsh
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

# the best theme ever, period
antigen theme half-life

# magic
antigen apply
