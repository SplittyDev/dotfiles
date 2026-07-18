# Splitty's Universal zsh config
# ----------------------------------------------------------------------------
#
# This is my personal zsh config. It's pretty generic over what you use.
# Most features switch themselves off if the required program isn't installed.
#
# ----------------------------------------------------------------------------
#
# GitHub: https://github.com/SplittyDev
#
# ----------------------------------------------------------------------------
#
# Configuration
#
# ----------------------------------------------------------------------------

# If you use the Android SDK, you might have to replace the path here.
# If the path doesn't exist on your machine, nothing will happen.
ANDROID_SDK_PATH="$HOME/Library/Android/sdk"

# If you use sdkman, you might have to replace the path here.
# If the path doesn't exist on your machine, nothing will happen.
#
# INSTALL: https://sdkman.io/
SDKMAN_INIT_SCRIPT="$HOME/.sdkman/bin/sdkman-init.sh"

# Whether to enable aliases for common Rust utilities.
#
# If you don't use Rust, or any of these tools, you can safely leave this as is.
# If you do use the tools but don't want the aliases, set it to `0`.
#
# Current aliases:
# - `cat`  -> `bat`
# - `ls`   -> `eza`
# - `tree` -> `erd`
ENABLE_RUST_UTIL_ALIASES=1

# Whether to enable aliases for common Cargo commands.
#
# If you don't use Rust, you can safely leave this as is.
# If you do use Rust but don't want the aliases, set it to `0`.
#
# Current aliases:
# - `fmt`   -> `cargo +nightly fmt`
# - `udeps` -> `cargo +nightly udeps`
ENABLE_CARGO_ALIASES=1

# Whether to enable aliases for common Git commands.
#
# If you don't use Git, you can safely leave this as is.
# If you do use Git but don't want the aliases, set it to `0`.
#
# Current aliases:
# - `ff`       -> `git pull --ff-only`
# - `gpf`      -> `git push --force-with-lease`
# - `gpf!`     -> `git push --force`
# - `redev`    -> `git fetch origin development && git rebase origin/development`
# - `remain`   -> `git fetch origin main && git rebase origin/main`
# - `remaster` -> `git fetch origin master && git rebase origin/master`
# - `gfa`      -> `git fetch --all`
# - `gfu`      -> `git fetch upstream`
# - `gcb`      -> `git checkout -b`
# - `gpub`     -> `git push -u origin <current branch>`
ENABLE_GIT_ALIASES=1

# Whether to enable sccache as a Rust compiler wrapper.
# Generally speeds up compilation times, at the expense of disk space.
# Does nothing if sccache isn't installed.
#
# INSTALL: `cargo install sccache`
ENABLE_SCCACHE=1
SCCACHE_CACHE_SIZE="50G" # adjust this to your liking

# Whether to enable aliases for docker compose.
#
# If you don't use Docker, you can safely leave this as is.
# If you do use Docker but don't want the aliases, set it to `0`.
#
# Current aliases:
# - `dc`      -> `docker compose`
ENABLE_DOCKER_COMPOSE_ALIASES=1

# ----------------------------------------------------------------------------
#
# Now comes the actual config. You shouldn't have to change anything below.
#
# ----------------------------------------------------------------------------

# nvim
if command -v nvim &>/dev/null; then
  alias vim="nvim"
  export EDITOR="nvim"
fi

# fnm (fast node manager)
if command -v fnm &>/dev/null; then
  FNM_ENABLED=true
  eval "$(fnm env --use-on-cd --version-file-strategy=recursive --corepack-enabled)"
fi

# enable nvm lazy loading if fnm isn't enabled
if [[ -z $FNM_ENABLED && -n "$(command -v nvm)" ]]; then
  export NVM_LAZY_LOAD=true
fi

# rbenv
command -v rbenv &>/dev/null && eval "$(rbenv init - zsh)"

# android home
if [ -d "$ANDROID_SDK_PATH" ] && export ANDROID_HOME="$ANDROID_SDK_PATH"

# Load sheldon plugins.
# HINT: Get sheldon here: https://github.com/rossmacarthur/sheldon
command -v sheldon &>/dev/null && eval "$(sheldon source)"

# Initialize starship prompt. Highly recommended!
# HINT: Get starship here: https://starship.rs/
command -v starship &>/dev/null && eval "$(starship init zsh)"

# Initialize zoxide fuzzy cd. Highly recommended!
# Allows you to use the `z` command to quickly jump to directories.
# HINT: Install using `cargo install zoxide`
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# deno
if command -v deno &>/dev/null; then
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

# Globally expose sublime text `subl` command
# HINT: Only runs on macOS and if Sublime Text is installed
if [[ "$(uname)" == "Darwin" && -d "/Applications/Sublime Text.app/Contents/SharedSupport/bin" ]]; then
  export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
fi

# rust util aliases
if [[ $ENABLE_RUST_UTIL_ALIASES -eq 1 ]]; then
  command -v bat &>/dev/null && alias cat="bat"
  command -v exa &>/dev/null && alias ls="exa" # deprecated, use `eza` instead
  command -v eza &>/dev/null && alias ls="eza"
  command -v erd &>/dev/null && alias tree="erd"
fi

# git aliases
if [[ $ENABLE_GIT_ALIASES -eq 1 ]] && command -v git &>/dev/null; then
  # Fast forward
  alias ff="git pull --ff-only"
  # Force push with lease
  alias gpf="git push --force-with-lease"
  # Force push
  alias gpf!="git push --force"
  # Rebase origin/development
  alias redev="git fetch origin development && git rebase origin/development"
  # Rebase origin/main
  alias remain="git fetch origin main && git rebase origin/main"
  # Rebase origin/master
  alias remaster="git fetch origin master && git rebase origin/master"
  # Fetch all
  alias gfa="git fetch --all"
  # Fetch upstream
  alias gfu="git fetch upstream"
  # Git checkout new branch
  alias gcb="git checkout -b"
  # Publish branch to origin
  function __gpub() {
    local branch=$(git branch --show-current)
    git push -u origin "$branch"
  }
  alias gpub="__gpub"
fi

# cargo aliases
if [[ $ENABLE_CARGO_ALIASES -eq 1 ]] && command -v cargo &>/dev/null; then
  alias fmt="cargo +nightly fmt"
  alias udeps="cargo +nightly udeps"
fi

# docker compose aliases
if [[ $ENABLE_DOCKER_COMPOSE_ALIASES -eq 1 ]] && command -v docker &>/dev>null; then
  alias dc="docker compose"
fi

# youtube download
if command -v yt-dlp &>/dev/null; then
  function __dl() {
    yt-dlp "$1" -f "bv*+ba/b" --no-video-multistreams --recode mp4
  }
  function __dlmp3() {
    yt-dlp "$1" -f "ba/b" --recode mp3
  }
  alias dl="__dl"
  alias dla="__dlmp3"
fi

# fuzzy finder
# HINT: If you use skim, you'll have to replace the paths here
[[ -s "$HOME/Developer/skim/shell/key-bindings.zsh" ]] && source "$HOME/Developer/skim/shell/key-bindings.zsh"

# sccache
if [[ $ENABLE_SCCACHE -eq 1 ]] && command -v sccache &>/dev/null; then
  export RUSTC_WRAPPER=sccache
  export SCCACHE_CACHE_SIZE=$SCCACHE_CACHE_SIZE
fi

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Created by `pipx` on 2024-11-11 10:56:45
command -v pipx &>/dev/null && export PATH="$PATH:$HOME/.local/bin"

# rvm
command -v rvm &>/dev/null && export PATH="$PATH:$HOME/.rvm/bin"

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$SDKMAN_INIT_SCRIPT" ]]; then
  export SDKMAN_DIR="$HOME/.sdkman"
  source "$SDKMAN_INIT_SCRIPT"
fi

# ----------------------------------------------------------------------------
#
# Now comes my personal configuration. You can remove this if you want.
# The contents of this block may or may not be useful to you.
#
# ----------------------------------------------------------------------------

# open-webui
function __open_webui() {
  DATA_DIR=~/.open-webui uvx --python 3.11 open-webui@latest serve
}
alias webui="__open_webui"

# ollama
alias ollama:start='sudo launchctl load /Library/LaunchDaemons/ollama.plist'
alias ollama:stop='sudo launchctl unload /Library/LaunchDaemons/ollama.plist'
alias ollama:restart='sudo launchctl kickstart -k system/ollama'

# bun
if [[ -d "$HOME/.bun/bin" ]]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$PATH:$BUN_INSTALL/bin"
  # bun completions
  [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
fi

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/splitty/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# invokeai
[[ -f "$HOME/invokeai/invoke.sh" ]] && alias invokeai="$HOME/invokeai/invoke.sh"

# Added by LM Studio CLI (lms)
[[ -d "$HOME/.lmstudio/bin" ]] && export PATH="$PATH:$HOME/.lmstudio/bin"
# End of LM Studio CLI section

# Darkbloom
[[ -d "$HOME/.darkbloom/bin" ]] && export PATH="$PATH:$HOME/.darkbloom/bin"
