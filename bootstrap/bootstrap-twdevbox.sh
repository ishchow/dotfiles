#!/bin/bash
source ./bootstrap.sh

echo "Adding repositories..."
if ! $(zypper lr | grep "vscode" &> /dev/null); then
    echo "Adding vscode repo..."
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo zypper addrepo -p 105 https://packages.microsoft.com/yumrepos/vscode vscode
fi

echo "Installing patterns..."
sudo zypper in --no-recommends -t pattern x11

echo "Installing packages..."
sudo zypper ref
sudo zypper in -y \
    code \
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
        --bin ~/.local/share/JetBrains/Toolbox/scripts \
        --export-path ~/.local/bin
fi

echo "Installing konsave..."
sudo python3 -m pip install konsave
