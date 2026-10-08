# Shell integrations for installed tools. Each one is skipped if the tool is missing.

exists zoxide   && eval "$(zoxide init zsh)"
exists starship && eval "$(starship init zsh)"
# fzf ≥ 0.48 ships its own key bindings (Ctrl-R/Ctrl-T/Alt-C) and completion
exists fzf      && source <(fzf --zsh)
# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
