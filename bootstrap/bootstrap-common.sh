#/bin/bash

echo "Installing basic patterns..."
sudo zypper in -t pattern base enhanced_base devel_basis
sudo zypper in -y  \
    git \
    chezmoi \
    neovim

if ! command -v node &> /dev/null; then
    echo "Installing fnm, nodejs, and npm..."
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
    fnm install v16.16.0
    fnm default v16.16.0
fi

if ! command -v bw &> /dev/null; then
    echo "Installing bitwarden-cli..."
    npm install -g @bitwarden/cli
fi


