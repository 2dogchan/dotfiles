# Aliases. Tool-specific ones are only defined when the tool exists.

# ─── Files ─────────────────────────────────────────────────────────────────────
if exists eza; then
  alias ls="eza"
  alias l="eza --long --icons --all --git --color=always --group-directories-first"
  alias ll=l
else
  alias ls="ls --color=auto"
  alias l='ls -lFh'
fi
exists bat && alias cat='bat'
alias grep='grep --color'
alias md="mkdir -p"
alias del="rm -rf"
alias ...="cd ../../.."
alias ....="cd ../../../.."
alias d='dirs -v'                       # directory stack, jump with 1..9
for index ({1..9}) alias "$index"="cd +${index}"; unset index
alias -s {js,ts,html,css,md}=nvim       # `file.md` opens it in nvim

# ─── Shell / dotfiles ──────────────────────────────────────────────────────────
alias x="exit"
alias cl='clear'
alias src="exec $SHELL"
alias ez="${=EDITOR} ${ZDOTDIR}/.zshrc"
alias dots='cd ~/.local/share/chezmoi'
alias brewfile='brew bundle dump --force --file ~/.local/share/chezmoi/Brewfile'

# ─── Editor ────────────────────────────────────────────────────────────────────
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# ─── Apps ──────────────────────────────────────────────────────────────────────
exists lazygit && alias lg='lazygit'
exists npm  && alias ns="clear && npm start" && alias nt="clear && npm test"
exists yarn && alias ys="clear && yarn start" && alias yt="clear && yarn test"

# ─── Network ───────────────────────────────────────────────────────────────────
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
[[ "$(uname)" == 'Linux' ]] && alias open='xdg-open'

# ─── Git (subset of oh-my-zsh's git plugin; single quotes keep $(…) lazy) ───────
alias g="git"
alias gs="git status"
alias gss="git status -s"
alias gst="git status"
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gd='git diff'
alias gco="git checkout"
alias gcb='git checkout -b'
alias gcm='git checkout $(git_main_branch)'
alias gcd="git checkout development"
alias gb='git branch'
alias gbD='git branch -D'
alias gbl='git blame -b -w'
alias gbr='git branch --remote'
alias gbda='git branch --no-color --merged | command grep -vE "^(\+|\*|\s*($(git_main_branch)|development|develop|devel|dev)\s*$)" | command xargs -n 1 git branch -d'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'
alias gl='git pull'
alias glum='git pull upstream $(git_main_branch)'
alias glog="git log"
alias gm='git merge'
alias gma='git merge --abort'
alias gmom='git merge origin/$(git_main_branch)'
alias gp='git push'
alias grbi='git rebase -i'
alias grbm='git rebase $(git_main_branch)'
alias grhh='git reset --hard'
alias groh='git reset origin/$(git_current_branch) --hard'
alias gpristine='git reset --hard && git clean -dffx'
alias gcl='git clone --recurse-submodules'
alias gstp="git stash pop"
alias gsts="git stash show -p"
