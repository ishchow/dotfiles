function isWinDir -d "checks if in wsl windows directory"
    if isWsl
        false
    end

    switch "$PWD/"
        case "/mnt/*"
            true
        case "*"
            false
    end
end
