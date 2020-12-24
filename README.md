# My Neovim Configs

### CD to `$XDG_CONFIG_HOME`

Remember to set `$XDG_CONFIG_HOME` to `%USERPROFILE%\.config` on Windows.

    # Windows
    cd /d %XDG_CONFIG_HOME%

    # Linux
    cd $XDG_CONFIG_HOME

### Clone this repository

    git clone https://github.com/LexSong/nvim.git nvim

### Install minpac

    git clone https://github.com/k-takata/minpac.git nvim/pack/minpac/opt/minpac

### Install plugins with minpac

    nvim +PackUpdate

### Install Semshi

* Install the Python provider:

    pip install pynvim

* Update Remote Plugins

    nvim +UpdateRemotePlugins
