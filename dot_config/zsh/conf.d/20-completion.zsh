# Completion system. Extra completions must be on fpath BEFORE compinit runs.

exists brew && fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
[ -d "$ZDOTDIR/plugins/zsh-completions/src" ] && fpath=("$ZDOTDIR/plugins/zsh-completions/src" $fpath)

autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/zcompdump"
zmodload zsh/complist
_comp_options+=(globdots)       # include hidden files

setopt ALWAYS_TO_END
setopt AUTO_MENU
setopt LIST_PACKED

# Menu navigation with vi keys
zstyle ':completion:*' menu select
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

zstyle ':completion:*' list-colors ''
zstyle ':completion:*' rehash true                  # pick up new executables without restarting
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' format "%F{yellow}%B%U%d%b%u%f"
zstyle ':completion:*' expand suffix
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' list-suffixes true
# exact match first, then case-insensitive, then abbreviations (f.b → foo.bar), then substring
zstyle ':completion:*' matcher-list '' \
  '+m:{[:lower:]}={[:upper:]}' \
  '+m:{[:upper:]}={[:lower:]}' \
  '+m:{_-}={-_}' \
  'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR/zcompcache"

# cdr: recent directories, per terminal window
zstyle ':completion:*:*:cdr:*:*' menu selection
zstyle ':chpwd:*' recent-dirs-file "$ZSH_CACHE_DIR/.chpwd-recent-dirs-${WINDOWID##*/}" +
zstyle ':completion:*' recent-dirs-insert always
zstyle ':chpwd:*' recent-dirs-default yes
