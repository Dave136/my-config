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
  cp -r ./fonts/* ~/.local/share/fonts
  fc-cache -f -v
}

show_menu() {
  echo "Select an option:"
  echo "1. Unzip files"
  echo "2. Install fonts"
  echo "3. Install packages"
  echo "4. Install Oh My Zsh"
  echo "5. Install Flatpak apps"
  echo "6. Install theme"
  echo "7. Exit"
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
  mv backup/*.zip .
  unzip config.zip
  unzip fonts.zip
  echo "Files extracted successfully"
  sleep 2
  echo "Moving files..."
  cp -r config/* $HOME/
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
# unzip_config

# Install fonts
# install_fonts

# Update and install packages
# update_install_pkgs

# Installing Oh My Zsh
# ohmyzsh

# Install ohmyzsh packages
# ohmyzsh_pkgs

# Install flatpak apps
# flatpak_apps


while true; do
  show_menu
  read -p "Enter your choice: " choice

  case $choice in
    1)
        unzip_config
        ;;
    2)
        install_fonts
        ;;
    3)
        update_install_pkgs
        ;;
    4)
        ohmyzsh
        ohmyzsh_pkgs
        ;;
    5)
        flatpak_apps
        ;;
    6)
        install_theme
        ;;
    7)
        echo "Exiting..."
        break
        ;;
    *)
        echo "Invalid choice. Please try again."
        ;;
  esac
done

#  echo "Select an option:"
#   echo "1. Unzip files"
#   echo "2. Install fonts"
#   echo "3. Install packages"
#   echo "4. Install Oh My Zsh"
#   echo "5. Install Flatpak apps"
#   echo "6. Install theme"
#   echo "7. Exit"