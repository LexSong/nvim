# My Neovim Configs

### CD to `$XDG_CONFIG_HOME`

Remember to set `$XDG_CONFIG_HOME` to `%USERPROFILE%\.config` on Windows.

    # Windows
    cd /d %XDG_CONFIG_HOME%

    # Linux
    cd $XDG_CONFIG_HOME

### Clone this repository

    git clone https://github.com/LexSong/nvim.git nvim

### Create a mamba environment for Python integration

    mamba create -n pynvim pynvim

Run `:checkhealth` to see if it works correctly.
See `:h provider-python` for more details.

### Install Paq

    # Windows
    git clone https://github.com/savq/paq-nvim.git %LOCALAPPDATA%\nvim-data\site\pack\paqs\start\paq-nvim

### Install plugins with Paq

    :PaqSync

### Update remote plugins (for Semshi)

    :UpdateRemotePlugins
