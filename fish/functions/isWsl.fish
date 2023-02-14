function isWsl -d "Checks if fish is running in a WSL2 session"
    test -z $WSL_DISTRO_NAME
end
