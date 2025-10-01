#/bin/bash

add_repo () {
    if ! $(zypper lr | grep "$1" &> /dev/null); then
        sudo zypper ar -p 105 "https://download.opensuse.org/repositories/$1/openSUSE_Tumbleweed/$1.repo"
    fi
}

echo "Installing basic patterns..."
sudo zypper in -y -t pattern base enhanced_base devel_basis

if ! command -v node &> /dev/null; then
    eval "`fnm env`"
    fnm install v22.19.0
    fnm default v22.19.0
    fnm use default
fi

if ! command -v bw &> /dev/null; then
    echo "Installing bitwarden-cli..."
    npm install -g @bitwarden/cli
fi

echo "Adding repositories..."
add_repo "home:mohms"

echo "Updating system..."
sudo zypper ref && sudo zypper dup -y

echo "Installing packages..."
sudo zypper in -y -t pattern devel_basis
sudo zypper in -y \
    git \
    chezmoi \
    chezmoi-fish-completion \
    fnm \
    fnm-bash-completion \
    fnm-fish-completion \
    neovim \
    fish \
    opi \
    wget \
    tree \
    curl \
    jq \
    fuse \
    ripgrep \
    ripgrep-bash-completion \
    ripgrep-fish-completion \
    bat \
    fd \
    fd-bash-completion \
    fd-fish-completion \
    gpg2 \
    hub \
    tig \
    tmux \
    fzf \
    fzf-bash-completion \
    fzf-fish-completion \
    clang \
    lldb \
    fasd \
    nerd-fonts-firacode \
    meld \
    lazygit

# If not in WSL
if [[ -z "$WSL_DISTRO_NAME" ]]; then
    if ! $(zypper lr | grep "vscode" &> /dev/null); then
        echo "Adding vscode repo..."
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo zypper addrepo -p 105 https://packages.microsoft.com/yumrepos/vscode vscode
    fi

    echo "Installing VS Code..."
    sudo zypper in -y code

    if command -v code &> /dev/null; then
        echo "Installing VS Code plugins..."
        cat ~/.local/share/chezmoi/misc/vscode/extensions.list | xargs -L 1 code --install-extension --force
    fi
fi

echo "Creating projects folder..."
mkdir -p ~/projects

if command -v firewall-cmd &> /dev/null; then
    echo "Setting up firewall rules..."
    sudo firewall-cmd --permanent --zone=public --add-service=http
    sudo firewall-cmd --permanent --zone=public --add-service=https

    if [ ! -d ~/projects/personal-site ]; then
        if command -v firewall-cmd &> /dev/null; then
            echo "Setting up firewall rules for personal website..."
            sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
        fi
    fi

    echo "Reloading firewall rules..."
    sudo firewall-cmd --reload
fi
