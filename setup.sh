#!/bin/bash

# Script to install developer tools on a fresh Ubuntu system
# Tools: neovim, bat, zoxide, oh-my-zsh, delta, fzf, starship, lazygit, ripgrep, and eza

# Text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print status messages
print_status() {
    echo -e "${YELLOW}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}==>${NC} $1"
}

print_error() {
    echo -e "${RED}==>${NC} $1"
}

# Check if script is run as root
if [ "$(id -u)" -eq 0 ]; then
    print_error "This script should not be run as root. Please run as a regular user with sudo privileges."
    exit 1
fi

# Check if zsh is installed on the system
if [ ! -f "/usr/bin/zsh" ] && [ ! -f "/bin/zsh" ]; then
    print_error "zsh is not installed. Please install zsh first with: sudo apt install zsh"
    exit 1
fi

# Check if the user's shell is zsh
current_shell=$(basename "$SHELL")
if [ "$current_shell" != "zsh" ]; then
    print_error "Your current shell is $current_shell, not zsh. Please change your shell to zsh with: chsh -s $(which zsh)"
fi

print_success "zsh is installed. Proceeding with installation..."

# Update package lists
print_status "Updating package lists..."
sudo apt update

# Install dependencies
print_status "Installing dependencies..."
sudo apt install -y curl wget git build-essential unzip cmake pkg-config tmux

# Install Neovim (latest version)
print_status "Installing Neovim..."
if ! command_exists nvim; then
    # Add Neovim repository and install
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt update
    sudo apt install -y neovim
    print_success "Neovim installed successfully!"
else
    print_status "Neovim is already installed, updating..."
    sudo apt install -y --only-upgrade neovim
    print_success "Neovim updated successfully!"
fi

# Install ripgrep
print_status "Installing ripgrep..."
if ! command_exists rg; then
    sudo apt install -y ripgrep
    print_success "ripgrep installed successfully!"
else
    print_status "ripgrep already installed, updating..."
    sudo apt install -y --only-upgrade ripgrep
    print_success "ripgrep update successfully"
fi

# Install bat
print_status "Installing bat..."
if ! command_exists bat; then
    sudo apt install -y bat
    if ! command_exists bat && command_exists batcat; then
        mkdir -p ~/.local/bin
        ln -s /usr/bin/batcat ~/.local/bin/bat
        echo 'export PATH="$HOME/.local/bin:$PATH"' >>~/.zshrc
    fi
    print_success "bat installed successfully!"
else
    print_status "bat is already installed."
fi

# Install zoxide
print_status "Installing zoxide..."
if ! command_exists zoxide; then
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    print_success "zoxide installed successfully!"
else
    print_status "zoxide is already installed."
fi

# Install Oh My Zsh
print_status "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh installed successfully!"
else
    print_status "Oh My Zsh is already installed."
fi

# Install delta (git-delta)
print_status "Installing delta..."
if ! command_exists delta; then
    DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
    wget -q "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb"
    sudo dpkg -i git-delta_${DELTA_VERSION}_amd64.deb
    rm git-delta_${DELTA_VERSION}_amd64.deb
else
    print_status "delta is already installed."
fi

# Install fzf
print_status "Installing fzf..."
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-fish
    print_success "fzf installed successfully!"
else
    print_status "fzf is already installed."
fi

# Install starship
print_status "Installing starship..."
if ! command_exists starship; then
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
    print_success "starship installed successfully!"
else
    print_status "starship is already installed."
fi

# Install lazygit
print_status "Installing lazygit..."
if ! command_exists lazygit; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar -xf /tmp/lazygit.tar.gz -C /tmp
    sudo install /tmp/lazygit /usr/local/bin
    rm -f /tmp/lazygit /tmp/lazygit.tar.gz
    print_success "lazygit installed successfully!"
else
    print_status "lazygit is already installed."
fi

# Install eza (replacement for exa)
print_status "Installing eza..."
if ! command_exists eza; then
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/eza.gpg
    echo "deb [signed-by=/etc/apt/keyrings/eza.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/eza.list
    sudo chmod 644 /etc/apt/keyrings/eza.gpg
    sudo apt update
    sudo apt install -y eza
    print_success "eza installed successfully!"
else
    print_status "eza is already installed."
fi

print_status "Install fzf-git..."
if [ ! -d "$HOME/fzf-git/" ]; then
    git clone https://github.com/junegunn/fzf-git.sh.git ~/fzf-git/
    print_success "fzf-git installed successfully"
else
    print_status "fzf-git already installed"
fi

print_status "Install TPM..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    print_status "TPM installed successfully"
else
    print_status "TPM already installed"
fi

print_status "Configuring bat theme..."
[ ! -f "$(/usr/bin/batcat --config-dir)/themes/Catppuccin Macchiato.tmTheme" ] && wget -P "$(/usr/bin/batcat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme && /usr/bin/batcat cache --build
print_success "bat configured successfully"

print_status "Configuring neovim..."
if [ ! -d "$HOME/.config/nvim" ]; then
    mkdir -p ~/.config/ && cd ~/.config/ &&
        git init -q && git config core.sparseCheckout true -q &&
        echo "nvim/*" >.git/info/sparse-checkout &&
        git remote add origin https://github.com/MuchTitan/workspace.git &&
        git pull origin master -q &&
        rm -rf .git && cd - || exit
    print_success "neovim configured successfully"
else
    print_status "Found already existing neovim config"
fi

if [ -f "$HOME/.zshrc" ]; then
    print_status "Backing up existing .zshrc to .zshrc-backup..."
    [ ! -f "$HOME/.zshrc-backup" ] && mv "$HOME/.zshrc" "$HOME/.zshrc-backup"
fi

# Download the new .zshrc file
print_status "Downloading .zshrc config..."
curl -so "$HOME/.zshrc" https://raw.githubusercontent.com/MuchTitan/workspace/refs/heads/master/.zshrc
print_success ".zshrc downloaded and saved successfully!"

if [ -f "$HOME/.tmux.conf" ]; then
    print_status "Backing up existing .tmux.conf to .tmux.conf-backup..."
    [ ! -f "$HOME/.tmux.conf-backup" ] && mv "$HOME/.tmux.conf" "$HOME/.tmux.conf-backup"
fi

# Download the new .zshrc file
print_status "Downloading .tmux.conf..."
curl -so "$HOME/.tmux.conf" https://raw.githubusercontent.com/MuchTitan/workspace/refs/heads/master/.tmux.conf
print_success ".tmux.conf downloaded and saved successfully!"

print_success "All tools have been installed! Please restart your shell or run 'source ~/.zshrc' to apply changes."
