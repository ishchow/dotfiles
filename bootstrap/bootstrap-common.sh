#/bin/bash

add_repo () {
    if ! $(zypper lr | grep "$1" &> /dev/null); then
        sudo zypper ar -p 105 "https://download.opensuse.org/repositories/$1/openSUSE_Tumbleweed/$1.repo"
    fi
}
