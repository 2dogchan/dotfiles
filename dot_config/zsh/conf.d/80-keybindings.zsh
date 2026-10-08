# Key bindings (fzf's Ctrl-R / Ctrl-T / Alt-C are set up in 40-tools.zsh)

export KEYTIMEOUT=1
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^O' autosuggest-accept
bindkey '^L' clear-screen
bindkey '^Z' fancy-ctrl-z
# bindkey "\e\e" sudo-command-line      # Esc Esc toggles sudo

# Edit the current command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
# bindkey -M vicmd vv edit-command-line
