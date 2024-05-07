sudo apt update && sudo apt -y upgrade
sudo apt install -y nodejs npm ripgrep bat build-essential curl wget locales
sudo apt install -y python3 python3-pip python3-venv python-is-python3 git fd-find
sudo apt install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip git binutils 
sudo apt autoclean && sudo apt clean

python3 -m venv ~/.neovim-venv
source ~/.neovim-venv/bin/activate
pip3 install pynvim black
npm i -g neovim tree-sitter-cli
