#/bin/bash

source bootstrap-common.sh

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


echo "Adding repositories..."
if ! $(zypper lr | grep "vscode" &> /dev/null); then
    echo "Adding vscode repo..."
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo zypper addrepo -p 105 https://packages.microsoft.com/yumrepos/vscode vscode
fi

add_repo "home:mohms"

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
    code \
    nerd-fonts-firacode

if ! test -d ~/.local/config/nvim; then
    echo "Setting up nvim config..."
    ln -s ~/.local/share/chezmoi/home/.config/nvim ~/.config/nvim
fi

if ! test -d ~/.local/config/fish; then
    echo "Setting up nvim fish..."
    ln -s ~/.local/share/chezmoi/home/.config/fish ~/.config/fish
fi

if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "Installing tmux plugin manager (tpm)..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ ! -d ~/.tmux/plugins/tmux-resurrect ]; then
    echo "Installing tmux-resurrect plugin..."
    git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect
fi

if [ ! -d ~/.tmux/plugins/tmux-continuum ]; then
    echo "Installing tmux-continuum plugin..."
    git clone https://github.com/tmux-plugins/tmux-continuum ~/.tmux/plugins/tmux-continuum
fi

if [ ! -d ~/.tmux/plugins/tmux-yank ]; then
    echo "Installing tmux-yank plugin..."
    git clone https://github.com/tmux-plugins/tmux-yank ~/.tmux/plugins/tmux-yank
fi

if [ ! -d ~/.tmux/plugins/tmux-resurrect ]; then
    echo "Installing tmux-resurrect plugin..."
    git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect
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
