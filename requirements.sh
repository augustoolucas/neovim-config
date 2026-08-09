# System packages (Ubuntu/Debian)
sudo apt update && sudo apt -y upgrade
sudo apt install -y git curl wget build-essential cmake
sudo apt install -y nodejs npm python3 python3-pip python3-venv ripgrep fd-find
sudo apt install -y shfmt
sudo apt autoclean && sudo apt clean

# Python venv for Neovim provider
python3 -m venv ~/.neovim-venv
~/.neovim-venv/bin/pip install pynvim

# Global npm packages
npm i -g neovim tree-sitter-cli
