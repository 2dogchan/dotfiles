# Third-party plugins. They are downloaded by chezmoi into $ZDOTDIR/plugins (see .chezmoiexternal.toml),
# so nothing is cloned at shell start-up. Missing plugins are silently skipped.

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'
ZSH_AUTOSUGGEST_USE_ASYNC=1

zsh_plugin() {
  local f="$ZDOTDIR/plugins/$1"
  [ -f "$f" ] && source "$f"
}

zsh_plugin zsh-autosuggestions/zsh-autosuggestions.zsh
zsh_plugin zsh-autopair/autopair.zsh
zsh_plugin alias-tips/alias-tips.plugin.zsh
zsh_plugin zsh-auto-notify/auto-notify.plugin.zsh
# syntax highlighting must be sourced last
zsh_plugin zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload zmv   # built-in batch rename
