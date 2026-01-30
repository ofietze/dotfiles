#!/bin/bash

echo "Installing commandline tools..."
xcode-select --install

echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off

brew install --cask ghostty

echo "Now setup your github ssh key 'ssh-keygen -t ed25519 -C "your_email@example.com"'"
echo "Afterwards open ghostty and run .finishInstall.sh"
