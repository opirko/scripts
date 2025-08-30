#!/bin/bash

detect_package_manager() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian)
                echo "Debian based Linux detected."
                PACKAGE_MANAGER="apt"
                ;;
            fedora|centos|rhel)
                echo "Red Hat based Linux detected."
                PACKAGE_MANAGER="dnf"
                ;;
            *)
                echo "Unsupported Linux distribution"
                exit 1
                ;;
        esac
    else
        echo "Cannot detect OS"
        exit 1
    fi
}

install_common_packages() {
    sudo $PACKAGE_MANAGER install -y vim-gtk3 curl wget qbittorrent firefox keepassxc mpv
}

install_gnome() {
    echo "GNOME detected. Installing GNOME-specific tools... TODO"
}

detect_package_manager
install_common_packages
if [[ "$XDG_CURRENT_DESKTOP" == "GNOME" ]]; then
    install_gnome
fi
echo "Installation complete."
