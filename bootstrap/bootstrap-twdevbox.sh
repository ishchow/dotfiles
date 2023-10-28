#!/bin/bash

source ./bootstrap.sh

if ! test -f /.dockerenv; then
    echo "Creating /.dockerenv..."
    sudo touch /.dockerenv
fi

echo "Installing patterns..."
sudo zypper in --no-recommends -t pattern -y x11

echo "Installing packages..."
sudo zypper ref
sudo zypper in -y \
    libfuse2 \
    libfuse2-32bit \
    libgthread-2_0-0 \
    libXtst6

echo "Exporting binaries, apps, and services to host system..."
if command -v code &> /dev/null; then
    distrobox-export --app code --extra-flags "--foreground"
fi
distrobox-export --bin $(which nvim) --export-path ~/.local/bin

if ! test -f ~/.local/bin/idea && test -f ~/.local/share/JetBrains/Toolbox/scripts/idea; then
    echo "Exporting IntelliJ Idea from distrobox..."
    distrobox-export \
        --bin ~/.local/share/JetBrains/Toolbox/scripts/idea \
        --export-path ~/.local/bin
fi

if ! test -d ~/.local/config/nvim; then
    echo "Setting up nvim config..."
    ln -s ~/.local/share/chezmoi/nvim ~/.config/nvim/
fi
