## Neovim Configuration Files

This repository contains my configuration files for the Neovim editor. Follow the instructions below to install dependencies, compile Neovim, clone and set up the repository, and perform health checks.

**Prerequisites**

- **Compatible operating system**: The guide assumes a Debian/Ubuntu-based system.
- **Basic knowledge**: Familiarity with the terminal and basic Git concepts.

**Installation and Configuration Steps**

1. **Install Dependencies**

   ```bash
   curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
   sudo apt update
   sudo apt install python3-pip python3-venv python3-pynvim nodejs git lua5.1 luarocks ripgrep ninja-build gettext cmake unzip curl build-essential
   sudo npm install -g neovim
   python3 -m venv ~/.neovim-venv
   ```

   After that:
   ˋˋˋbash
   pip install flak8 isort black pyright
   ˋˋˋ

3. **Neovim Installation**
  
   I've tested it with Neovim 0.10.1 on Ubuntu 22.04, and I needed to build it from source to make it work with this configuration. I'm not entirely sure why. On Ubuntu 24.04, it wasn't necessary to build it; simply installing it with Snap worked for me. 

   - Follow the official Neovim build instructions: [https://github.com/neovim/neovim/blob/master/BUILD.md](https://github.com/neovim/neovim/blob/master/BUILD.md)
   - Use the `v0.10.1` branch.
   - After compiling, set the `VIMRUNTIME` environment variable to point to the `runtime` folder of the Neovim repository.

5. **Clone the Configuration Repository**

   ```bash
   git clone https://github.com/augustoolucas/neovim-config.git
   ```

6. **Move the Repository to the Configuration Folder**

   ```bash
   mv <path_to_cloned_repository>/neovim-config ~/.config/nvim
   ```

7. **Run Neovim and Wait for Package Installation**

   - Run Neovim (`nvim`). The `Lazy` plugin will automatically start installing packages. Wait for it to finish.

8. **Restart Neovim**

   - Close and reopen Neovim (`nvim`).

9. **Run Configuration Commands**

   - Run the following commands inside Neovim:
     - `:Mason`
     - `:Lazy update`
     - `:Lazy sync`

10. **Check Configuration Health**

   - Run `:checkhealth` to ensure everything is working correctly. If there are any issues, Neovim will display error messages.
