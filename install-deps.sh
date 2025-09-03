#!/bin/bash

detect_package_manager() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian)
                echo "Debian based Linux detected."
                PACKAGE_MANAGER="apt"
                VIM_PACKAGE="vim-gtk3"
                ;;
            fedora|fedora-asahi-remix|centos|rhel)
                echo "Red Hat based Linux detected."
                PACKAGE_MANAGER="dnf"
                VIM_PACKAGE="vim-enhanced"
                ;;
            *)
                echo "Unsupported Linux distribution: $ID"
                exit 1
                ;;
        esac
    else
        echo "Cannot detect OS"
        exit 1
    fi
}

install_common_packages() {
    if [ "$PACKAGE_MANAGER" = "apt" ]; then
        sudo $PACKAGE_MANAGER update
    fi
    sudo $PACKAGE_MANAGER install -y \
	    "$VIM_PACKAGE" \
	    curl \
	    firefox \
	    git \
	    keepassxc \
	    mpv \
	    wget \
	    qbittorrent
}

install_gnome() {
    echo "GNOME detected. Installing GNOME-specific tools..."
    sudo $PACKAGE_MANAGER install -y gnome-tweaks
}

check_manual_install() {
    local cmd="$1"
    local download_url="$2"
    if ! command -v "$cmd" &> /dev/null; then
        echo "[MANUAL] Install $cmd: $download_url"
    fi
}

detect_package_manager
install_common_packages

if [[ "$XDG_CURRENT_DESKTOP" == "GNOME" ]]; then
    install_gnome
fi

echo "Installation complete."

check_manual_install "signal-desktop" "https://signal.org/download/"
check_manual_install "slack" "https://slack.com/downloads/linux"
check_manual_install "spotify" "https://www.spotify.com/cz/download/linux/"
check_manual_install "code" "https://code.visualstudio.com/docs/setup/linux"

