#/bin/bash

source bootstrap-common.sh

echo "Adding repositories..."
if ! $(zypper lr | grep "vscode" &> /dev/null); then
    echo "Adding vscode repo..."
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo zypper addrepo -p 105 https://packages.microsoft.com/yumrepos/vscode vscode
fi

echo "Updating system..."
sudo zypper ref && sudo zypper dup -y

echo "Installing packages..."
sudo zypper in -y -t pattern devel_basis
sudo zypper in -y \
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
    exa \
    exa-fish-completion \
    fd \
    fd-fish-completion \
    ruby \
    python \
    python2-pip \
    python3 \
    python3-pip \
    python3-virtualenvwrapper \
    gpg2 \
    hub \
    tig \
    tmux \
    fzf \
    fzf-bash-completion \
    fzf-fish-completion \
    fzf-tmux \
    clang \
    lldb \
    neovim \
    fasd \
    fish \
    code

if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "Installing tmux plugin manager (tpm)..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if ! command -v fff &> /dev/null; then
    echo "Installing fast file finder (fff)..."
    git clone https://github.com/dylanaraps/fff ~/.fff
    sudo make -C ~/.fff install
fi

if ! command -v lazygit &> /dev/null; then
    echo "Installing lazygit..."
    sudo zypper ar -p 105 https://download.opensuse.org/repositories/home:Dead_Mozay/openSUSE_Tumbleweed/home:Dead_Mozay.repo
    sudo zypper --gpg-auto-import-keys ref
    sudo zypper in -y lazygit
fi

if ! command -v rustup &> /dev/null; then
    echo "Installing rustup..."
    curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
fi

if ! command -v rust-analyzer %> /dev/null; then
    echo "Installing rust-analyzer..."
    mkdir -p ~/.local/bin
    curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
    chmod +x ~/.local/bin/rust-analyzer
fi

echo "Creating projects folder..."
mkdir -p ~/projects

if comamnd -v firewall-cmd &> /dev/null; then
    echo "Setting up firewall rules..."
    sudo firewall-cmd --permanent --zone=public --add-service=http
    sudo firewall-cmd --permanent --zone=public --add-service=https

    if [ ! -d ~/projects/personal-site ]; then
        if comamnd -v firewall-cmd &> /dev/null; then
            echo "Setting up firewall rules for personal website..."
            sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
        fi
    fi

    echo "Reloading firewall rules..."
    sudo firewall-cmd --reload
fi
