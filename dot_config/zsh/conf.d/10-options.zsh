# Shell options and history

setopt AUTO_CD                  # `dir` instead of `cd dir`
setopt AUTO_PUSHD               # cd pushes onto the directory stack (see `d` alias)
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt CORRECT                  # command auto-correction
setopt COMPLETE_ALIASES
setopt RM_STAR_WAIT
setopt AUTO_PARAM_SLASH         # tab-completing a directory appends a slash

# History: large, shared, deduplicated, written immediately
HISTSIZE=100000
SAVEHIST=100000
HISTFILE="$ZSH_CACHE_DIR/.zsh_history"
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
