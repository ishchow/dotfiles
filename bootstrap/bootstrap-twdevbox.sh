#!/bin/bash
source ./bootstrap.sh

echo "Installing patterns..."
sudo zypper in --no-recommends -t pattern x11

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

if test ~/.local/share/JetBrains/Toolbox/scripts/idea; then
    distrobox-export \
        --bin ~/.local/share/JetBrains/Toolbox/scripts/idea \
        --export-path ~/.local/bin
fi

echo "Installing konsave..."
sudo python3 -m pip install konsave
