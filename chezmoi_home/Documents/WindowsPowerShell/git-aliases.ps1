# Git Aliases for PowerShell

### --- Simple Aliases --- ###
Set-Alias g git
Set-Alias ga 'git add'
Set-Alias gaa 'git add -A'
Set-Alias gad 'git add .'
Set-Alias gau 'git add -u'
# Set-Alias gc 'git commit' # Conflicts with built-in alias for Get-Content
Set-Alias gtc 'git commit'
# Set-Alias gcm 'git commit -m' # Conflicts with built-in alias for Get-Command
Set-Alias gtcm 'git commit -m'
Set-Alias gca 'git commit --amend'
Set-Alias gcf 'git commit --fixup'
Set-Alias gcp 'git cherry-pick'
Set-Alias gcpa 'git cherry-pick --abort'
Set-Alias gcpc 'git cherry-pick --continue'
Set-Alias gcps 'git cherry-pick --skip'
Set-Alias gclf 'git clean -f'
Set-Alias gclfd 'git clean -fd'
Set-Alias gclfdx 'git clean -fdx'
Set-Alias gclnf 'git clean -nf'
Set-Alias gclnfd 'git clean -nfd'
Set-Alias gcl 'git clean'
Set-Alias gco 'git checkout'
Set-Alias gcob 'git checkout -b'
Set-Alias gcoom 'git checkout origin/master'
Set-Alias gdf 'git diff'
Set-Alias gdfh 'git diff HEAD'
Set-Alias gbr 'git branch'
Set-Alias gbrD 'git branch -D'
Set-Alias gbrd 'git branch -d'
Set-Alias gbrm 'git branch -m'
Set-Alias gbrsc 'git branch --show-current'
Set-Alias gbrr 'git branch -r'
Set-Alias gf 'git fetch'
# Set-Alias gl 'git log --oneline --decorate' # Conflicts with built-int alias for Get-Location
Set-Alias gtl 'git log --oneline --decorate'
# Set-Alias gm 'git merge' # Conflicts with built-in alias for Get-Member
Set-Alias gtm 'git merge'
Set-Alias gma 'git merge --abort'
Set-Alias gmc 'git merge --continue'
Set-Alias gms 'git merge --squash'
Set-Alias gpl 'git pull'
Set-Alias gplr 'git pull --rebase'
Set-Alias gplrb 'git pull --rebase'
Set-Alias gplom 'git pull origin master'
Set-Alias grb 'git rebase'
Set-Alias grba 'git rebase --abort'
Set-Alias grbc 'git rebase --continue'
Set-Alias grfl 'git reflog'
Set-Alias grs 'git reset'
Set-Alias grsh 'git reset --hard'
Set-Alias gro 'git restore'
Set-Alias gros 'git restore --staged'
Set-Alias grv 'git revert'
Set-Alias grvnc 'git revert --no-commit'
Set-Alias gs 'git status'
Set-Alias gst 'git stash'
Set-Alias gsta 'git stash apply'
Set-Alias gstl 'git stash list'
Set-Alias gstp 'git stash pop'
Set-Alias gstd 'git stash drop'
Set-Alias gpu 'git push'
Set-Alias gpuoh 'git push -u origin HEAD'
Set-Alias gpdo 'git push -d origin'
Set-Alias gpud 'git push -d origin'
Set-Alias gpudob 'git push -d origin dev/ischowdh/rm-cdn-throttling'
Set-Alias gsu 'git submodule'
Set-Alias gsuir 'git submodule update --init --recursive'

### --- Functions --- ###

function gbrdef {
    git remote show origin | Select-String 'HEAD branch' | ForEach-Object {
        ($_ -split ': ')[-1].Trim()
    }
}

function grshom {
    $branch = gbrdef
    git reset --hard origin/$branch
}

function grshob {
    $branch = git branch --show-current
    git reset --hard origin/$branch
}

function grshoh {
    $branch = git rev-parse --abbrev-ref HEAD
    git reset --hard origin/$branch
}

function gdfob {
    $branch = git branch --show-current
    git diff origin/$branch
}

function gdfom {
    $branch = gbrdef
    git diff origin/$branch
}

function gmsom {
    $branch = gbrdef
    git merge --squash origin/$branch
}

function grbiom {
    $branch = gbrdef
    git rebase -i --autosquash origin/$branch
}

function grbiob {
    $branch = git branch --show-current
    git rebase -i --autosquash origin/$branch
}

function grbob {
    $branch = git branch --show-current
    git fetch
    git rebase origin/$branch
}

function grbom {
    $branch = gbrdef
    git fetch
    git rebase origin/$branch
}

function gmbom {
    $branch = gbrdef
    git merge-base --fork-point origin/$branch
}

function grsgmbom {
    $branch = gbrdef
    $mergeBase = git merge-base --fork-point origin/$branch
    git reset $mergeBase
}

function cdgroot {
    Set-Location (git rev-parse --show-toplevel)
}

function gcom {
    $branch = gbrdef
    git checkout $branch
}

# Optional: FZF-based fuzzy branch checkout (requires fzf installed on Windows)
if (Get-Command fzf -ErrorAction "silentlycontinue")
{
    function gch {
        $branch = git branch | fzf | ForEach-Object { $_.Trim() }
        if ($branch) {
            git checkout $branch
        }
    }

    function gcha {
        $branch = git branch -a | fzf | ForEach-Object { $_.Trim() }
        if ($branch) {
            git checkout $branch
        }
    }
}