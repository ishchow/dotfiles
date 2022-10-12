Personal dotfiles for Windows and Linux. Dotfiles managed using [chezmoi](https://www.chezmoi.io/).

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

Install git:

```
winget install git
```

Install fnm, chezmoi:

```
scoop install chezmoi fnm
```

Install nodejs using fnm:

```
fnm env --use-on-cd | Out-String | Invoke-Expression
fnm install v16.16.0
fnm default v16.16.0
```

Install bw cli:

```
npm install -g @bitwarden/cli
```

## Linux (OpenSUSE Tumbleweed)

Install git:

```
sudo zypper in -y git
```

[Install chezmoi](https://www.chezmoi.io/docs/install/)

Install fnm, node, and npm:

```
curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
export PATH=/home/ishaat/.fnm:$PATH
eval "`fnm env`"
fnm install v16.16.0
fnm default v16.16.0
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
git remote set-url origin git@github.com:ishchow/dotfiles.git
git config user.email "<chezmoi repo email>" # In case default git user is different
```

# Bootstrap new system
## Linux (OpenSUSE Tumbleweed)

Enter bootstrap directory:

```
cd ~/.local/share/chezmoi/bootstrap
```

Run with default arguments:

```
./bootstrap.sh
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
