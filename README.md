# skim

This plugin tries to find [junegunn's fzf](https://github.com/junegunn/fzf) based on where
it's been installed, and enables its fuzzy auto-completion and key bindings.

To use it, add `fzf` to the plugins array in your zshrc file:

```zsh
plugins=(... fzf)
```

## Settings

All these settings should go in your zshrc file, before Oh My Zsh is sourced.

### `SKIM_BASE`

Set to fzf installation directory path:

```zsh
export SKIM_BASE=/path/to/fzf/install/dir
```

### `SKIM_DEFAULT_COMMAND`

Set default command to use when input is tty:

```zsh
export SKIM_DEFAULT_COMMAND='<your fzf default command>'
```

If not set, the plugin will try to set it to these, in the order in which they're found:

- [`fd`](https://github.com/sharkdp/fd)
- [`rg`](https://github.com/BurntSushi/ripgrep)
- [`ag`](https://github.com/ggreer/the_silver_searcher)

### `DISABLE_SKIM_AUTO_COMPLETION`

Set whether to load fzf auto-completion:

```zsh
DISABLE_SKIM_AUTO_COMPLETION="true"
```

### `DISABLE_SKIM_KEY_BINDINGS`

Set whether to disable key bindings (CTRL-T, CTRL-R, ALT-C):

```zsh
DISABLE_SKIM_KEY_BINDINGS="true"
```

