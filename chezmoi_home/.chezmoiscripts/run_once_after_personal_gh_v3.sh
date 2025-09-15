#!/bin/sh

# Set the target file path
TARGET="$HOME/.ssh/personal-gh-v3"

# Only run if the file doesn't exist
if [ ! -f "$TARGET" ]; then
    echo "Writing personal-gh-v3.pub from Bitwarden..."
    chezmoi bitwarden attachment get --item feb3d011-094e-4749-9cfb-ac22004ff685 --name personal-gh-v3 > "$TARGET"
else
    echo "personal-gh-v3 already exists. Skipping."
fi
