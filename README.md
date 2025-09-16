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

Assuming Windows 11.

Open Powershell as admin:

Set execution policy to bypass so we can run bw cli. I generally find the defaults to be annoying anyways:

```
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
```

Install git, chezmoi, ande NodeJS:

```
winget install Git.Git twpayne.chezmoi OpenJS.NodeJS.LTS
```

Install bw cli:

```
npm install -g @bitwarden/cli
```

## Linux (OpenSUSE Tumbleweed)

```
sudo zypper in -y git chezmoi fnm
```

Install latest nodejs lts and set as default:

```
fnm install v22.19.0
fnm default v22.19.0
fnm use default
eval $(fnm env)
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
git config user.email "<chezmoi repo email>" # In case default git user is different
git remote set-url origin git@github.com:ishchow/dotfiles.git
```

# Bootstrap new system
## Linux (OpenSUSE Tumbleweed)

Enter bootstrap directory:

```
cd ~/.local/share/chezmoi/bootstrap
```

Run appropriate bootstrap script:

```
bash bootstrap-tw-kde.sh # Runs bootstrap for DE and apps, run on host
bash bootstrap-twdevbox.sh # Runs bootstrap for containerized dev env (it calls bootstrap.sh already)
bash bootstrap.sh # Runs bootstrap for dev environment, run on WSL or on host if not using distrobox
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
