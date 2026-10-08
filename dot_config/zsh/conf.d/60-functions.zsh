# Shell functions

# Which process listens on a port:  port 8080
port() { lsof -n -i ":$@" | grep LISTEN }

# git helpers used by the aliases
git_main_branch() {
  local branch
  for branch in main trunk; do
    if command git show-ref -q --verify "refs/heads/$branch"; then
      echo "$branch"; return
    fi
  done
  echo master
}
git_current_branch() { command git symbolic-ref --quiet --short HEAD 2>/dev/null }

# Diff against a branch while excluding one file:  gdmin develop package-lock.json
gdmin() {
  local branchname=${1:-develop}
  local ignore=${2:-package-lock.json}
  git diff "$branchname" -- ":(exclude)$ignore"
}

# Rename a branch locally and on origin:  grename old new
grename() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: grename old_branch new_branch"; return 1
  fi
  git branch -m "$1" "$2"
  if git push origin :"$1"; then
    git push --set-upstream origin "$2"
  fi
}

# Print the 256 terminal colours
colours() {
  for i in {0..255}; do
    printf "\x1b[38;5;${i}m colour${i}"
    (( i % 5 == 0 )) && printf "\n" || printf "\t"
  done
}

# Build Neovim from source into ~/neovim
build-nvim() {
  local neovim_dir="$PROJECTS_DIR/contributing/neovim"
  [ ! -d "$neovim_dir" ] && git clone git@github.com:neovim/neovim.git "$neovim_dir"
  pushd "$neovim_dir"
  git checkout master && git pull upstream master
  [ -d build ] && rm -r build
  make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"
  make install
  popd
}

# Ctrl-Z on an empty line brings the last job back to the foreground
fancy-ctrl-z() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"; zle accept-line
  else
    zle push-input; zle clear-screen
  fi
}
zle -N fancy-ctrl-z

# Toggle `sudo` in front of the current (or previous) command. Bind in 80-keybindings if wanted.
sudo-command-line() {
  [[ -z $BUFFER ]] && zle up-history
  if [[ $BUFFER == sudo\ * ]]; then
    LBUFFER="${LBUFFER#sudo }"
  elif [[ $BUFFER == $EDITOR\ * ]]; then
    LBUFFER="${LBUFFER#$EDITOR }"; LBUFFER="sudoedit $LBUFFER"
  elif [[ $BUFFER == sudoedit\ * ]]; then
    LBUFFER="${LBUFFER#sudoedit }"; LBUFFER="$EDITOR $LBUFFER"
  else
    LBUFFER="sudo $LBUFFER"
  fi
}
zle -N sudo-command-line
