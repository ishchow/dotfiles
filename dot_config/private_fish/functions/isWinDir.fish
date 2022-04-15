function isWinDir -d "checks if in wsl windows directory"
    if test -z $WSL_DISTRO_NAME
        false
    end

    switch "$PWD/"
        case "/mnt/*"
            true
        case "*"
            false
    end
end
