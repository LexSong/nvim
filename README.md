# My Neovim Config

### Clone the Config

1. Open the terminal and change to the default config directory:

   ```
   # Unix
   cd ~/.config

   # Windows
   cd /d %USERPROFILE%\AppData\Local
   ```

2. Clone this repository:

   ```
   git clone https://github.com/LexSong/nvim.git nvim
   ```

### Install Paq and Plugins

1. Install Paq:

   See https://github.com/savq/paq-nvim#installation.

   ```
   # Unix
   cd ~/.local/share
   git clone https://github.com/savq/paq-nvim.git nvim/site/pack/paqs/start/paq-nvim

   # Windows
   cd /d %USERPROFILE%\AppData\Local
   git clone https://github.com/savq/paq-nvim.git nvim-data\site\pack\paqs\start\paq-nvim
   ```

2. Install plugins with Paq:

   ```
   :PaqSync
   ```
