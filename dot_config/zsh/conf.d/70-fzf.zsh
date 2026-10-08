# fzf options and helpers (key bindings themselves come from `fzf --zsh` in 40-tools.zsh)
exists fzf || return

# Search with ripgrep: hidden files included, .gitignore respected
export FZF_DEFAULT_COMMAND='rg --files --hidden'

local -a opts=(
  "--layout=reverse" "--info=inline" "--height=80%" "--border=sharp" "--cycle" "--multi"
  "--prompt='∷ '" "--marker='✓'"
  "--preview='([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2>/dev/null | head -n 200'"
  "--preview-window=':hidden'"
  "--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'"
  "--bind=esc:abort"
  "--bind '?:toggle-preview'"
  "--bind 'ctrl-a:select-all'"
  "--bind 'ctrl-e:execute(nvim {+} >/dev/tty)'"
  "--bind 'ctrl-v:execute(code {+})'"
)
exists pbcopy && opts+=("--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'")
export FZF_DEFAULT_OPTS="${(j: :)opts}"

# Ctrl-R: preview the full command with Ctrl-/, copy it with Ctrl-Y
export FZF_CTRL_R_OPTS="
--preview 'echo {}' --preview-window up:3:hidden:wrap
--bind 'ctrl-/:toggle-preview'
--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
--color header:italic
--header 'Press CTRL-Y to copy command into clipboard'"
export FZF_TMUX_OPTS='-p80%,60%'

# cdf: fuzzy cd into a directory (with tree preview)
if exists fd && exists tree; then
  fzf-change-directory() {
    local directory
    directory=$(fd --type d | fzf --query="$1" --no-multi --select-1 --exit-0 --preview 'tree -C {} | head -100')
    [[ -n "$directory" ]] && cd "$directory"
  }
  alias cdf=fzf-change-directory
fi

# killf: pick processes to kill -9
fzf-kill() {
  local pid_col=2
  [[ $(uname) == Darwin ]] && pid_col=3
  local pids
  pids=$(ps -f -u "$USER" | sed 1d | fzf --multi | tr -s "[:blank:]" | cut -d' ' -f"$pid_col")
  [[ -n "$pids" ]] && echo "$pids" | xargs kill -9 "$@"
}
alias killf='fzf-kill'
