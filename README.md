# Overview

Personal dotfiles for Windows and Linux.

```
.
├── bootstrap       # Contains scripts (Bash and PowerShell) for bootstrapping new systems (Windows and Linux only)
├── chezmoi_home    # Contains dotfiles that are managed by chezmoi (https://www.chezmoi.io/)
├── home            # Contains dotfiles that are not managed by chezmoi (typically these are symlinked manually)
├── misc            # Contains anything that doesn't cleanly fit into the other folders
```

# Setup dependencies

## Windows

Install scoop:

```
iwr -useb get.scoop.sh | iex
```

Open Powershell as admin:

Set execution policy to bypass so we can run bw cli. I generally find the defaults to be annoying anyways:

```
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
```

Install chocolatey:

```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Install git and chezmoi:

```
winget install git twpayne.chezmoi
```

Install nodejs:

```
choco install chezmoi nodejs
```

Install bw cli:

```
npm install -g @bitwarden/cli
```

## Linux (OpenSUSE Tumbleweed)

### Setup distrobox (optional)

When running Tumbleweed on bare metal, I prefer to keep my development environment (including stuff needed for dotfiles management) in a container instead of on the host machine.

Install distrobox and enter distrobox container shell:

```
sudo zypper in distrobox distrobox-bash-completion
distrobox enter twdevbox
```

Afterwards, run the steps from the below section in the distrobox container.

This step is not applicable when setting up a WSL environment.

### Setup dependences

Install git and chezmoi:

```
sudo zypper in -y git chezmoi
```

Install fnm, node, and npm:

```
curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
export PATH=/home/$USER/.local/share/.fnm:$PATH
eval "`fnm env`"
fnm install v18.14.0
fnm default v18.14.0
fnm use default
```

Install bitwarden cli:

```
npm install -g @bitwarden/cli
```

# Set api client secret

Windows:

```
$env:BW_CLIENTSECRET='...'
```

Linux:

```
export BW_CLIENTSECRET="..."
```

# Log into bitwarden

```
bw login
```

# Initialize dotfiles

```
chezmoi init --apply ishchow
```

# Change chezmoi repo settings

```
chezmoi cd
git remote set-url origin git@github.com:ishchow/dotfiles.git
git config user.email "<chezmoi repo email>" # In case default git user is different
```

# Bootstrap new system
## Linux (OpenSUSE Tumbleweed)

Enter bootstrap directory:

```
cd ~/.local/share/chezmoi/bootstrap
```

Run appropriate bootstrap script:

```
sudo bash bootstrap-tw-kde.sh # Runs bootstrap for DE and apps, run on host
sudo bash bootstrap-twdevbox.sh # Runs bootstrap for containerized dev env (it calls bootstrap.sh already)
sudo bash bootstrap.sh # Runs bootstrap for dev environment, run on WSL or on host if not using distrobox
```

## Windows

Open Powershell as admin.

Enter bootstrap directory:

```
cd ~\.local\share\chezmoi\bootstrap
```

Run bootstrap script:

```
.\bootstrap.ps1
```
