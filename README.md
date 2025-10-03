# Overview

Personal dotfiles for Windows and Linux.

```
.
├── bootstrap       # Contains data used for bootstrapping new systems
├── chezmoi_home    # Contains dotfiles that are managed by chezmoi (https://www.chezmoi.io/)
├── home            # Contains dotfiles that are not managed by chezmoi (typically these are symlinked manually)
├── misc            # Contains anything that doesn't cleanly fit into the other folders
```

# Install bootstrap dependencies

## Windows

Run in admin prompt:

```
winget install --exact --id Git.Git --scope=machine
winget install --exact --id twpayne.chezmoi --scope=machine
```

## Linux (OpenSUSE Tumbleweed)

```
sudo zypper in -y git chezmoi
```

## OSX (HomeBrew)

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" # Install homebrew first
brew install git
brew install chezmoi
```

# Initialize dotfiles

```
chezmoi init --apply ishchow
```

This will automatically setup dotfiles and bootstrap the system using shell scripts based on platform.

# Change chezmoi repo settings

```
chezmoi cd
git config user.email "<chezmoi repo email>" # In case default git user is different
ssh -T git@github.com # Check if ssh to github works
git remote set-url origin git@github.com:ishchow/dotfiles.git # If so, update chezmoi repo url
```