local SKIM_DIR=$(dirname "${(%):-%x}")

# Auto-completion
if [[ -o interactive && "${DISABLE_SKIM_AUTO_COMPLETION}" != "true" ]]; then
  source "${SKIM_DIR}/shell/completion.zsh" 2> /dev/null
fi

# Key bindings
if [[ "${DISABLE_SKIM_KEY_BINDINGS}" != "true" ]]; then
  source "${SKIM_DIR}/shell/key-bindings.zsh"
fi

# Bat theme
if [[ -z "$BAT_THEME" ]]; then
  export BAT_THEME="ansi"
fi

if [[ -z "$FZF_PREVIEW_COMMAND" ]]; then
  export FZF_PREVIEW_COMMAND='([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) \
    || ([[ -d {} ]] && (tree -L 2 -a -C {} | less || echo {} 2> /dev/null | head -200))'
fi

if [[ -z "$SKIM_DEFAULT_COMMAND" ]]; then
  export SKIM_DEFAULT_COMMAND="fd --type f || rg --files || find ."
fi

if [[ -z "$SKIM_DEFAULT_OPTIONS" ]]; then
  export SKIM_DEFAULT_OPTIONS="\
  --color=16 \
  --reverse \
  --inline-info \
  --no-multi \
  --cycle \
  --height=${SKIM_TMUX_HEIGHT:-40%} \
  --tiebreak=index \
  --bind '?:toggle-preview' \
  --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -L 2 -a -C {} | less || echo {} 2> /dev/null | head -200))' \
  "
fi
