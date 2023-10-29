#/bin/bash

source bootstrap-common.sh

echo "Installing packages..."
sudo zypper ref
sudo zypper in -y \
    flatpak \
    discover \
    discover-backend-flatpak \
    libqt5-qttools \
    kdeconnect-kde \
    konsole \
    yakuake \
    kate \
    okular \
    gwenview \
    ark \
    opi \
    kcalc \
    touchegg \
    distrobox \
    gnome-keyring \
    onedrive \
    onedrive-completion-bash \
    remmina \
    spectacle \
    earlyoom \
    intel-gpu-tools \
    python311-pipx \
    python311-python-xlib \
    pipewire-libjack-0_3 \
    wireplumber-audio \
    libfuse2 \
    libfuse2-32bit \
    libgthread-2_0-0 \
    libXtst6

echo "Adding groups..."
sudo usermod -a -G libvirt $USER

echo "Installing steam udev rules..."
sudo zypper in --no-recommends -y steam-devices

echo "Starting services..."
sudo systemctl enable --now touchegg.service
sudo systemctl enable --now docker.service
sudo systemctl enable --now earlyoom
sudo systemctl enable --now libvirtd
systemctl --user enable --now pipewire.service
systemctl --user enable --now wireplumber.service
systemctl --user enable --now pipewire-pulse.{service,socket}
systemctl --user enable --now onedrive
systemctl --user enable --now mouse_follows_focus.service

# See https://superuser.com/a/1107191 for explanation
if cat /sys/class/dmi/id/chassis_type | grep "10" &> /dev/null; then
    echo "Removing power-profiles-daemon..."
    sudo zypper rm power-profiles-daemon


    echo "Installing laptop specific packages..."
    sudo zypper in -y \
        powertop \
        thermald \
        tlp

    echo "Starting laptop specific services..."
    sudo systemctl enable --now tlp.service
    sudo systemctl enable --now thermald.service
fi

if [ ! getent group docker &> /dev/null ]; then
    echo "Setting up docker group..."
    getent group docker || sudo groupadd docker 
    sudo usermod -aG docker $USER 
    newgrp docker
fi

echo "Setting up firewall rules..."
sudo firewall-cmd --permanent --zone=public --add-service=kdeconnect
sudo firewall-cmd --permanent --zone=public --add-service=kdeconnect-kde
sudo firewall-cmd --reload

echo "Adding flathub repo..."
sudo flatpak --system remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Installing flatpaks..."
sudo flatpak install -y \
    com.bitwarden.desktop \
    com.calibre_ebook.calibre \
    de.shorsh.discord-screenaudio \
    com.getmailspring.Mailspring \
    com.github.tchx84.Flatseal \
    com.github.wwmm.easyeffects \
    com.spotify.Client  \
    org.freedesktop.Platform.VulkanLayer.MangoHud \
    md.obsidian.Obsidian \
    org.gimp.GIMP \
    org.libreoffice.LibreOffice \
    org.mozilla.firefox \
    org.qbittorrent.qBittorrent \
    org.videolan.VLC \
    com.valvesoftware.Steam \
    org.gtk.Gtk3theme.Breeze \
    org.freedesktop.Platform.GStreamer.gstreamer-vaapi \
    org.freedesktop.Platform.ffmpeg-full \
    org.freefilesync.FreeFileSync

echo "Setting flatpak overrides..."
flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
flatpak override --user --env=MANGOHUD=1 com.valvesoftware.Steam
flatpak override --user --env=GDK_SCALE=2 com.valvesoftware.Steam
flatpak override --user --filesystem=xdg-config/MangoHud:ro com.valvesoftware.Steam
flatpak override --user --filesystem=xdg-data/icons com.valvesoftware.Steam
flatpak override --user --filesystem=xdg-data/applications com.valvesoftware.Steam
flatpak override --user --filesystem=xdg-desktop com.valvesoftware.Steam
flatpak override --user --socket=wayland --env=MOZ_ENABLE_WAYLAND=1 org.mozilla.firefox

# workaround for missing libs after steam installation
sudo flatpak update

echo "Updating xgg settings..."
xdg-settings set default-web-browser org.mozilla.firefox.desktop

echo "Updating xdg user dirs..."
if test -d ~/OneDrive/; then
    if test -d ~/Music; then
        rmdir ~/Music/
        ln -s ~/OneDrive/Music/ ~/Music
        xdg-user-dirs-update --set MUSIC ~/OneDrive/Music/
    fi

    if test -d ~/Pictures; then
        rmdir ~/Pictures
        ln -s ~/OneDrive/Pictures/ ~/Pictures
        xdg-user-dirs-update --set PICTURES ~/OneDrive/Pictures/
    fi

    if test -d ~/Videos; then
        rmdir ~/Videos
        ln -s ~/OneDrive/Videos/ ~/Videos
        xdg-user-dirs-update --set VIDEOS ~/OneDrive/Videos/
    fi

    if test -d ~/Documents/; then
        rmdir ~/Documents/
        ln -s ~/OneDrive/Documents/ ~/Documents
        xdg-user-dirs-update --set DOCUMENTS ~/OneDrive/Documents/
    fi
fi


if flatpak list --app | grep "Firefox" &> /dev/null && zypper se -i MozillaFirefox &> /dev/null; then
    echo "Removing native firefox..."
    sudo zypper rm --clean-deps MozillaFirefox
fi

# See https://discourse.flathub.org/t/how-to-enable-video-hardware-acceleration-on-flatpak-firefox/3125 for how to setup hardware acceleration

echo "Installing konsave..."
pipx install konsave

# STR=$(konsave -l)
# if [[ "$STR" == *"No profile found"* ]]; then
#     if test ~/default.knsv; then
#         echo "Restoring plasma settings..."
#         konsave -i ~/default.knsv
#         konsave -a default
#     fi    n
# fi

echo "Setting up KDE dbus settings"
# See https://www.reddit.com/r/kde/comments/8vvwwn/setting_window_spread_to_meta_key/ for explanation
kwriteconfig5 --file ~/.config/kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.kglobalaccel,/component/kwin,org.kde.kglobalaccel.Component,invokeShortcut,ExposeAll"
#qdbus-qt5 org.kde.KWin /KWin reconfigure

# Run this to get all qdbus shortcuts
# qdbus-qt5 org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.shortcutNames

if test -f ~/.local/share/chezmoi/misc/kanata && ! test -f /etc/systemd/system/kanata.service; then
    echo "Copying kanata service file and starting kanata service..."
    sudo cp ~/.local/share/chezmoi/misc/kanata/kanata.service /etc/systemd/system/kanata.service
    sudo systemctl enable --now kanata.service
fi
