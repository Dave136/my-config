#!/bin/bash

function install() {
  if ! dnf list installed $1 > /dev/null 2>&1; then
    echo "Package \"$1\" not found. Installing..."
    # sudo dnf install $1
  else
    echo "Package \"$1\" already installed. Skipping..."
  fi
}

function install_pkgs() {
  local pkgs=("$@")
  for pkg in "${pkgs[@]}"; do
    install $pkg
  done
}

function install_fonts() {
  echo "Installing system pkgs"
  sleep 2s
  clear
  echo "Installing fonts..."
  mkdir -p ~/.local/share/fonts
  cp -r ./config/fonts/* ~/.local/share/fonts
  fc-cache -f -v
}

function mv_icons() {
  mv ./icons ~/.icons
}

function update_install_pkgs() {
  # Update deps
  sudo dnf update -y

  # Install packages
  sudo dnf install -y \
    git \
    neovim \
    python3-neovim \
    wget \
    curl \
    vlc \
    code \  # Visual Studio Code
    firefox \
    tldr \
    tableplus \
    gparted
}

function unzip_config() {
  echo "Installing zip/unzip deps..."
  install_pkgs "zip" "unzip"
  unzip config.zip
  echo "Files extracted successfully"
  sleep 2
  clear
}

function install_theme() {
  packages=$(dnf search yaru- | awk '/^yaru-/{print $1}')

  # Install the matched packages using dnf
  sudo dnf install $packages
}

function ohmyzsh() {
  echo "Installing ohmyzsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  echo "Installing zsh-completions..."
  git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

  source ~/.zshrc
}

function ohmyzsh_pkgs() {
  # Installing Fast Node Manager
  echo "Installing fnm..."
  curl -fsSL https://fnm.vercel.app/install | bash
  fnm install 20
  fnm completations --shell zsh

  # Installing pnpm
  echo "Installing pnpm..."
  curl -fsSL https://get.pnpm.io/install.sh | sh -

  # Installing bun
  echo "Installing bun..."
  curl -fsSL https://bun.sh/install | bash

  # Installing starship
  echo "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh

  source ~/.zshrc
}

function flatpak_apps() {
  echo "Installing flatpak apps..."
  sudo flatpak install -y flathub com.mattjakeman.ExtensionManager
  sudo flatpak install -y flathub net.fasterland.converseen
  sudo flatpak install -y flathub io.github.peazip.PeaZip
  sudo flatpak install -y flathub org.telegram.desktop
}

# First we need to unzip the files
unzip_config

# Install icons
mv_icons

# Install fonts
install_fonts

# Update and install packages
update_install_pkgs

# Installing Oh My Zsh
ohmyzsh

# Install ohmyzsh packages
ohmyzsh_pkgs

# Install flatpak apps
flatpak_apps
