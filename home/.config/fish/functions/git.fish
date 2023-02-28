function git -w git -d "Wrapper over git which calls correct git binary based on whether in wsl windows drive or native linux"
    if isWinDir
        set -f cmd "git.exe"
    else
        set -f cmd "$(which git)"
    end

    # https://github.com/fish-shell/fish-shell/issues/3708
    # https://github.com/fish-shell/fish-shell/issues/154
    $cmd $argv
end
