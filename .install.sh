#!/bin/bash

echo "Installing commandline tools..."
xcode-select --install

echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
eval "$(/opt/homebrew/bin/brew shellenv)"
source ~/.bash_profile

brew install --cask ghostty

echo "\n Installation done!"
echo "Now setup your github ssh key 'ssh-keygen -t ed25519 -C "your_email@example.com"'"
echo "Afterwards open ghostty and run .finishInstall.sh"
