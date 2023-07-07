#!/bin/zsh
#=============================================================================================================
#                           FUNCTIONS
#=============================================================================================================
function _fzf_has() {
  which "$@" > /dev/null 2>&1
}

# Don't step on user's defined variables. Export to potentially leverage them by other scripts.
fzf_default_opts+=(
  ${FZF_DEFAULT_OPTS}
  "--layout=reverse"
  "--info=inline"
  "--height=80%"
  "--multi"
  "--preview='([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2>/dev/null | head -n 200'"
#  "--preview='lessfilter-fzf {}'"
  "--preview-window=':hidden'"
  "--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'"
  "--prompt='∼ '"
#  "--pointer='▶'"
  "--marker='✓'"
  "--bind '?:toggle-preview'"
  "--bind 'ctrl-a:select-all'"
  "--bind 'ctrl-e:execute(nvim {+} >/dev/tty)'"
  "--bind 'ctrl-v:execute(code {+})'"
)
if _fzf_has pbcopy; then
  # On macOS, make ^Y yank the selection to the system clipboard. On Linux you can alias pbcopy to `xclip -selection clipboard` or corresponding tool.
  fzf_default_opts+=("--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'")
fi
export FZF_DEFAULT_OPTS=$(printf '%s\n' "${fzf_default_opts[@]}")

if _fzf_has tree; then
  function fzf-change-directory() {
    local directory=$(
      fd --type d | \
      fzf --query="$1" --no-multi --select-1 --exit-0 \
        --preview 'tree -C {} | head -100'
      )
    if [[ -n "$directory" ]]; then
      cd "$directory"
    fi
  }
  alias cdf=fzf-change-directory
fi

fzf-kill() {
  local pid_col
  local pids

  if [[ $(uname) = Linux ]]; then
    pid_col=2
    pids=$(
      ps -f -u "$USER" | sed 1d | fzf --multi | tr -s "[:blank:]" | cut -d' ' -f"$pid_col"
    )
  elif [[ $(uname) = Darwin ]]; then
    pid_col=3;
    pids=$(
      ps -f -u "$USER" | sed 1d | fzf --multi | tr -s "[:blank:]" | cut -d' ' -f"$pid_col"
    )
  elif [[ $(uname) = FreeBSD ]]; then
    pid_col=2
    pids=$(
      ps -axu -U "$USER" | sed 1d | fzf --multi | tr -s "[:blank:]" | cut -d' ' -f"$pid_col"
    )
  else
    echo 'Error: unknown platform'
    return
  fi

  if [[ -n "$pids" ]]; then
    echo "$pids" | xargs kill -9 "$@"
  fi
}
alias killf='fzf-kill'
