# My Neovim Configs

### CD to `$XDG_CONFIG_HOME`

Remember to set `$XDG_CONFIG_HOME` to `%USERPROFILE%\.config` on Windows.

    # Windows
    cd /d %XDG_CONFIG_HOME%

    # Linux
    cd $XDG_CONFIG_HOME

### Clone this repository

    git clone https://github.com/LexSong/nvim.git nvim

### Enable Python integration

    pip install pynvim

Run `:checkhealth` to see if it works correctly.
See `:h provider-python` for more details.
