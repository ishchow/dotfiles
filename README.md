# Overview

Personal dotfiles.

## Repo structure
```
.
├── bootstrap       # Contains data used for bootstrapping new systems
├── chezmoi_home    # Contains dotfiles that are managed by chezmoi (https://www.chezmoi.io/)
├── home            # Contains dotfiles that are not managed by chezmoi (typically these are symlinked manually)
├── misc            # Contains anything that doesn't cleanly fit into the other folders
```

## Supported and Tested Platforms
These are the platforms that this repo is used to manage and tested with:
- Windows 11 or above
- Linux
    - Scipts to install packages and instructions on bootstrapping only support OpenSUSE Tumbleweed
    - But the rest of the config works fine on any Linux system (theoretically, not tested)
- MacOS
    - Apple Silicon
    - Sequoia or above
        - Techincally can work on Intel Mac but some paths may be hardcoded to Apple Silicon paths

# Install bootstrap dependencies

## Windows

Run in admin prompt:

```
winget install --exact --id Git.Git --scope=machine
winget install --exact --id twpayne.chezmoi --scope=machine
winget install --exact --id gerardog.gsudo --scope=machine
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

## Windows

```
sudo config --enable normal
chezmoi init --apply ishchow --exclude=scripts # First, init the dotfiles but do not run any scripts
Set-ExecutionPolicy -ExecutionPolicy Bypass
sudo pwsh.exe -File $(Resolve-Path ~/AppData/Local/ishaat/bootstrap/000_bootstrap.ps1).Path # Then, do basic setup that needs to run as admin. .chezmoiscripts are pain when script needs to run as admin, so managing separately.
chezmoi init --apply ishchow # Finally, this will init dotfiles again and then run scripts
```

## Linux/OSX

```
chezmoi init --apply ishchow
```

This will automatically setup dotfiles and bootstrap the system using POSIX shell scripts based on platform.

# Change chezmoi repo settings

```
chezmoi cd
git config user.email "<chezmoi repo email>" # In case default git user is different
git config remote.origin.url https://github.com/ishchow/dotfiles.git # set fetch URL to https to avoid potential SSH login for fetch/pull since repo is public
ssh -T git@github.com # Check if ssh to github works
<<<<<<< Updated upstream
git remote set-url --push origin git@github.com:ishchow/dotfiles.git # If so, update chezmoi repo url for push only. Fetch stays on HTTPS for convenience.
||||||| Stash base
git remote set-url origin git@github.com:ishchow/dotfiles.git # If so, update chezmoi repo url
=======
git remote set-url --push origin git@github.com:ishchow/dotfiles.git # If so, update chezmoi repo url
>>>>>>> Stashed changes
```

# Fixing line ending errors (mostly in Windows)

Might get errors like this in Windows (seems to happen when I'm copying from ChatGPT):

```
PS C:\Users\ischowdh\.local\share\chezmoi> git add -A
fatal: CRLF would be replaced by LF in chezmoi_home/AppData/Local/ishaat/bootstrap/005_stop_mssqlserver.ps1.tmpl
```

To fix do this:

```
wsl # enter WSL
dos2unix chezmoi_home/AppData/Local/ishaat/bootstrap/005_stop_mssqlserver.ps1.tmpl # Convert file to LF line endings, repeat similar command for all offending files
exit # exit WSL
git add -A # should work now
```
