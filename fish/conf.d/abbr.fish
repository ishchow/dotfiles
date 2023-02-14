abbr -a -- gplr 'git pull --rebase'
abbr -a -- gca 'git commit --amend'
abbr -a -- grshom 'git reset --hard origin/$(git remote show origin | grep "HEAD branch" | sed "s/.* //")'
abbr -a -- gms 'git merge --squash'
abbr -a -- cdgroot 'cd $(git rev-parse --show-toplevel)'
abbr -a -- gclfdx 'git clean -fdx'
abbr -a -- gpuod 'git push -d origin'
abbr -a -- gm 'git merge'
abbr -a -- gdfoh 'git diff origin/$(git rev-parse --abbrev-ref HEAD)'
abbr -a -- gpdo 'git push -d origin'
abbr -a -- cl clear
abbr -a -- gl 'git log --oneline --decorate'
abbr -a -- cz chezmoi
abbr -a -- gdfob 'git diff origin/$(git branch --show-current)'
abbr -a -- gmbom 'git merge-base --fork-point origin/$(git remote show origin | grep "HEAD branch" | sed "s/.* //")'
abbr -a -- gbr 'git branch'
abbr -a -- gdf 'git diff'
abbr -a -- gros 'git restore --staged'
abbr -a -- gcps 'git cherry-pick --skip'
abbr -a -- gmb 'git merge-base'
abbr -a -- gcpc 'git cherry-pick --continue'
abbr -a -- gcom 'git checkout master'
abbr -a -- gpu 'git push'
abbr -a -- gma 'git merge --abort'
abbr -a -- gstp 'git stash pop'
abbr -a -- gco 'git checkout'
abbr -a -- gcm 'git commit -m'
abbr -a -- grbioh 'git rebase -i --autosquash origin/HEAD'
abbr -a -- gbrd 'git branch -d'
abbr -a -- gbrsc 'git branch --show-current'
abbr -a -- gbrdef 'git remote show origin | grep "HEAD branch" | sed "s/.* //"'
abbr -a -- ls 'ls -l'
abbr -a -- gcf 'git commit --fixup'
abbr -a -- ga 'git add'
abbr -a -- g git
abbr -a -- czap 'chezmoi apply'
abbr -a -- gclnfd 'git clean -nfd'
abbr -a -- gstd 'git stash drop'
abbr -a -- gau 'git add -u'
abbr -a -- gsu 'git submodule'
abbr -a -- cat 'bat -p'
abbr -a -- czad 'chezmoi add'
abbr -a -- grshob 'git reset --hard origin/$(git branch --show-current)'
abbr -a -- gpl 'git pull'
abbr -a -- gcob 'git checkout -b'
abbr -a -- gcoom 'git checkout origin/master'
abbr -a -- grba 'git rebase --abort'
abbr -a -- grb 'git rebase'
abbr -a -- gad 'git add .'
abbr -a -- gc 'git commit'
abbr -a -- gclf 'git clean -f'
abbr -a -- gclnf 'git clean -nf'
abbr -a -- gbrm 'git branch -m'
abbr -a -- gplrb 'git pull --rebase'
abbr -a -- gcp 'git cherry-pick'
abbr -a -- gch git\ checkout\ \$\(git\ branch\ \|\ fzf\ \|\ tr\ -d\ \'\[:space:\]\'\)
abbr -a -- gcl 'git clean'
abbr -a -- gclfd 'git clean -fd'
abbr -a -- gpud 'git push -d origin'
abbr -a -- gpudob 'git push -d origin dev/ischowdh/rm-cdn-throttling'
abbr -a -- grbiom 'git rebase -i --autosquash origin/$(git remote show origin | grep "HEAD branch" | sed "s/.* //")'
abbr -a -- gf 'git fetch'
abbr -a -- gpuoh 'git push -u origin HEAD'
abbr -a -- grbc 'git rebase --continue'
abbr -a -- grshoh 'git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)'
abbr -a -- gbrD 'git branch -D'
abbr -a -- grbi 'git rebase -i --autosquash'
abbr -a -- gplom 'git pull origin master'
abbr -a -- grbiob 'git rebase -i --autosquash origin/$(git branch --show-current)'
abbr -a -- grbob 'git fetch && git rebase origin/$(git branch --show-current)'
abbr -a -- grbom 'git fetch && git rebase origin/$(git remote show origin | grep "HEAD branch" | sed "s/.* //")'
abbr -a -- grfl 'git reflog'
abbr -a -- groot 'git rev-parse --show-toplevel'
abbr -a -- grs 'git reset'
abbr -a -- gmc 'git merge --continue'
abbr -a -- gro 'git restore'
abbr -a -- gcha git\ checkout\ \$\(git\ branch\ --all\ \|\ fzf\ \|\ tr\ -d\ \'\[:space:\]\'\)
abbr -a -- grsgmbom 'git reset $(git merge-base --fork-point origin/$(git remote show origin | grep "HEAD branch" | sed "s/.* //"))'
abbr -a -- grsh 'git reset --hard'
abbr -a -- grv 'git revert'
abbr -a -- grvnc 'git revert --no-commit'
abbr -a -- gs 'git status'
abbr -a -- gst 'git stash'
abbr -a -- gsta 'git stash apply'
abbr -a -- gaa 'git add -A'
abbr -a -- gstl 'git stash list'
abbr -a -- gsuir 'git submodule --update --init --recursive'
abbr -a -- gcpa 'git cherry-pick --abort'
abbr -a -- gdfh 'git diff HEAD'
abbr -a -- gdfom 'git diff origin/$(git remote show origin | grep "HEAD branch" | sed "s/.* //")'
abbr -a -- gmsom 'git merge --squash origin/$(git remote show origin | grep "HEAD branch" | sed "s/.* //")'
