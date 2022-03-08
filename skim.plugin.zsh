function skim_setup_using_base_dir() {
  local skim_base skim_shell skimdirs dir

  test -d "${SKIM_BASE}" && skim_base="${FZF_BASE}"

  if [[ -z "${skim_base}" ]]; then
    skimdirs=(
      "${HOME}/.skim"
      "${HOME}/.nix-profile/share/skim"
      "${XDG_DATA_HOME:-$HOME/.local/share}/skim"
      "/usr/local/opt/skim"
      "/usr/share/skim"
      "/usr/local/share/examples/skim"
    )
    for dir in ${skimdirs}; do
      if [[ -d "${dir}" ]]; then
        skim_base="${dir}"
        break
      fi
    done

    if [[ -z "${skim_base}" ]]; then
      if (( ${+commands[skim-share]} )) && dir="$(skim-share)" && [[ -d "${dir}" ]]; then
        skim_base="${dir}"
      elif (( ${+commands[brew]} )) && dir="$(brew --prefix sk 2>/dev/null)"; then
        if [[ -d "${dir}" ]]; then
          skim_base="${dir}"
        fi
      fi
    fi
  fi

  if [[ ! -d "${skim_base}" ]]; then
    return 1
  fi

  # Fix skim shell directory for Arch Linux, NixOS or Void Linux packages
  if [[ ! -d "${skim_base}/shell" ]]; then
    skim_shell="${skim_base}"
  else
    skim_shell="${skim_base}/shell"
  fi

  # Setup skim binary path
  if (( ! ${+commands[sk]} )) && [[ "$PATH" != *$skim_base/bin* ]]; then
    export PATH="$PATH:$skim_base/bin"
  fi

  # Auto-completion
  if [[ -o interactive && "$DISABLE_SKIM_AUTO_COMPLETION" != "true" ]]; then
    source "${skim_shell}/completion.zsh" 2> /dev/null
  fi

  # Key bindings
  if [[ "$DISABLE_SKIM_KEY_BINDINGS" != "true" ]]; then
    source "${skim_shell}/key-bindings.zsh"
  fi
}


function skim_setup_using_debian() {
  if (( ! $+commands[dpkg] )) || ! dpkg -s sk &>/dev/null; then
    # Either not a debian based distro, or no skim installed
    return 1
  fi

  # NOTE: There is no need to configure PATH for debian package, all binaries
  # are installed to /usr/bin by default

  local completions key_bindings

  case $PREFIX in
    *com.termux*)
      # Support Termux package
      completions="${PREFIX}/share/skim/completion.zsh"
      key_bindings="${PREFIX}/share/skim/key-bindings.zsh"
      ;;
    *)
      # Determine completion file path: first bullseye/sid, then buster/stretch
      completions="/usr/share/doc/skim/examples/completion.zsh"
      [[ -f "$completions" ]] || completions="/usr/share/zsh/vendor-completions/_skim"
      key_bindings="/usr/share/doc/skim/examples/key-bindings.zsh"
      ;;
  esac

  # Auto-completion
  if [[ -o interactive && "$DISABLE_SKIM_AUTO_COMPLETION" != "true" ]]; then
    source $completions 2> /dev/null
  fi

  # Key bindings
  if [[ ! "$DISABLE_SKIM_KEY_BINDINGS" == "true" ]]; then
    source $key_bindings
  fi

  return 0
}

function skim_setup_using_opensuse() {
  # OpenSUSE installs skim in /usr/bin/skim
  # If the command is not found, the package isn't installed
  (( $+commands[sk] )) || return 1

  # The skim-zsh-completion package installs the auto-completion in
  local completions="/usr/share/zsh/site-functions/_skim"
  # The skim-zsh-completion package installs the key-bindings file in
  local key_bindings="/etc/zsh_completion.d/skim-key-bindings"

  # If these are not found: (1) maybe we're not on OpenSUSE, or
  # (2) maybe the skim-zsh-completion package isn't installed.
  if [[ ! -f "$completions" || ! -f "$key_bindings" ]]; then
    return 1
  fi

  # Auto-completion
  if [[ -o interactive && "$DISABLE_SKIM_AUTO_COMPLETION" != "true" ]]; then
    source "$completions" 2>/dev/null
  fi

  # Key bindings
  if [[ "$DISABLE_SKIM_KEY_BINDINGS" != "true" ]]; then
    source "$key_bindings" 2>/dev/null
  fi

  return 0
}

function skim_setup_using_openbsd() {
  # openBSD installs skim in /usr/local/bin/skim
  if [[ "$OSTYPE" != openbsd* ]] || (( ! $+commands[skim] )); then
    return 1
  fi

  # The skim package installs the auto-completion in
  local completions="/usr/local/share/zsh/site-functions/_skim_completion"
  # The skim package installs the key-bindings file in
  local key_bindings="/usr/local/share/zsh/site-functions/_skim_key_bindings"

  # Auto-completion
  if [[ -o interactive && "$DISABLE_SKIM_AUTO_COMPLETION" != "true" ]]; then
    source "$completions" 2>/dev/null
  fi

  # Key bindings
  if [[ "$DISABLE_SKIM_KEY_BINDINGS" != "true" ]]; then
    source "$key_bindings" 2>/dev/null
  fi

  return 0
}

function skim_setup_using_cygwin() {
  # Cygwin installs skim in /usr/local/bin/skim
  if [[ "$OSTYPE" != cygwin* ]] || (( ! $+commands[skim] )); then
    return 1
  fi

  # The skim-zsh-completion package installs the auto-completion in
  local completions="/etc/profile.d/skim-completion.zsh"
  # The skim-zsh package installs the key-bindings file in
  local key_bindings="/etc/profile.d/skim.zsh"

  # Auto-completion
  if [[ -o interactive && "$DISABLE_SKIM_AUTO_COMPLETION" != "true" ]]; then
    source "$completions" 2>/dev/null
  fi

  # Key bindings
  if [[ "$DISABLE_SKIM_KEY_BINDINGS" != "true" ]]; then
    source "$key_bindings" 2>/dev/null
  fi

  return 0
}

# Indicate to user that skim installation not found if nothing worked
function skim_setup_error() {
  cat >&2 <<'EOF'
[skim zsh] skim plugin: Cannot find skim installation directory.
Please add `export SKIM_BASE=/path/to/skim/install/dir` to your .zshrc
EOF
}

skim_setup_using_openbsd \
  || skim_setup_using_debian \
  || skim_setup_using_opensuse \
  || skim_setup_using_cygwin \
  || skim_setup_using_base_dir \
  || skim_setup_error

unset -f -m 'skim_setup_*'

if [[ -z "$SKIM_DEFAULT_COMMAND" ]]; then
  export SKIM_DEFAULT_COMMAND="fd --type f || git ls-tree -r --name-only HEAD || rg --files || find ."
  export SKIM_DEFAULT_OPTIONS="\
  --color=16 \
  --reverse \
  --inline-info \
  --no-multi \
  --cycle \
  --preview-window=:hidden \
  --preview '([[ -f {} ]] \
    && (bat --style=numbers --color=always {} \
    || cat {})) \
    || ([[ -d {} ]] && (tree -C {} | less)) \
    || echo {} 2> /dev/null | head -200' \
  --bind '?:toggle-preview'
  "
fi
