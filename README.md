Personal dotfiles for Windows and Linux. Dotfiles managed using [chezmoi](https://www.chezmoi.io/).

# Setup dependencies

## Windows

Open Powershell as admin:

Set execution policy to bypass so we can run bw cli. I generally find the defaults to be annoying anyways:

```
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
```

Install chocolatey:

```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Install chezmoi and nodejs (needed for bw cli):

```
choco install -y git chezmoi nodejs
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
cd ~/bootstrap
```

Run with default arguments:

```
./bootstrap
```

## Windows

Open Powershell as admin.

Enter bootstrap directory:

```
cd ~\bootstrap
```

Run bootstrap script:

```
.\bootstrap.ps1
```
