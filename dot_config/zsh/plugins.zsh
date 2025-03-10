#-------------------------------------------------------------------------------
#  PLUGIN MANAGEMENT
#-------------------------------------------------------------------------------
PLUGIN_DIR="$ZDOTDIR/plugins"
mkdir -p $PLUGIN_DIR

function zsh_add_file() {
  [ -f "$ZDOTDIR/$1" ] && source "$ZDOTDIR/$1"
}

function zsh_source_plugin () {
  zsh_add_file "plugins/$1.zsh"
}

function zsh_add_plugin() {
  PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
  if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then
    zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
    zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh" || \
    zsh_add_file "plugins/$PLUGIN_NAME/$2.zsh"
  else
    cd $PLUGIN_DIR
    git clone "https://github.com/$1.git" "$PLUGIN_NAME"
    cd -
  fi
}
