# skim

This plugin tries to find [skim](https://github.com/lotabout/skim) based on where
it's been installed, and enables its fuzzy auto-completion and key bindings.

To use it, add `skim.zsh` to the plugins in your zshrc file the follow is an example using zinit:

```zsh
zinit wait lucid for \
  OMZL::key-bindings.zsh \
  OMZL::history.zsh \
  OMZP::git \
  casonadams/alacritty-shell \
  casonadams/skim.zsh \
  ;
```

## Settings

All these settings should go in your zshrc file, before the plugin is loaded.

### `SKIM_BASE`

Set to skim installation directory path:

```zsh
export SKIM_BASE=/path/to/skim/install/dir
```

### `SKIM_DEFAULT_COMMAND`

Set default command to use when input is tty:

```zsh
export SKIM_DEFAULT_COMMAND='<your skim default command>'
```
If not set, the plugin will try to set it to these, in the order in which they're found:

- [`fd`](https://github.com/sharkdp/fd)
- [`rg`](https://github.com/BurntSushi/ripgrep)
- [`ag`](https://github.com/ggreer/the_silver_searcher)

The plugin default settings lets one toggle the preview window using `?`

### `DISABLE_SKIM_AUTO_COMPLETION`

Set whether to load skim auto-completion:

```zsh
DISABLE_SKIM_AUTO_COMPLETION="true"
```

### `DISABLE_SKIM_KEY_BINDINGS`

Set whether to disable key bindings (CTRL-T, CTRL-R, ALT-C):

```zsh
DISABLE_SKIM_KEY_BINDINGS="true"
```

