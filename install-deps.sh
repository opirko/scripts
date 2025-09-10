#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

detect_package_manager() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian)
                log_info "Debian based Linux detected."
                PACKAGE_MANAGER="apt"
                VIM_PACKAGE="vim-gtk3"
                ;;
            fedora|fedora-asahi-remix|centos|rhel)
                log_info "Red Hat based Linux detected."
                PACKAGE_MANAGER="dnf"
                VIM_PACKAGE="vim-enhanced"
                ;;
            *)
                log_error "Unsupported Linux distribution: $ID"
                exit 1
                ;;
        esac
    else
        log_error "Cannot detect OS"
        exit 1
    fi
}

install_common_packages() {
    if [ "$PACKAGE_MANAGER" = "apt" ]; then
        sudo $PACKAGE_MANAGER update
    fi
    sudo $PACKAGE_MANAGER install -y \
	    "$VIM_PACKAGE" \
	    clang-format \
	    cmake \
	    curl \
	    firefox \
	    firmware-linux \
	    firmware-iwlwifi \
	    firmware-realtek \
	    git \
	    keepassxc \
	    mpv \
	    wget \
	    qbittorrent
}

install_gnome() {
    log_info "GNOME detected. Installing GNOME-specific tools..."
    sudo $PACKAGE_MANAGER install -y \
	    gnome-tweaks \
	    gnome-shell-extension-autohidetopbar \
	    gnome-shell-extension-system-monitor \
	    ptyxis
}

check_manual_install() {
    local cmd="$1"
    local download_url="$2"
    if ! command -v "$cmd" &> /dev/null; then
        log_warning "[MANUAL] Install $cmd: $download_url"
    fi
}

# main starting here
detect_package_manager
install_common_packages

if [[ "$XDG_CURRENT_DESKTOP" == "GNOME" ]]; then
    install_gnome
fi

log_info "Installation complete."

check_manual_install "signal-desktop" "https://signal.org/download/"
check_manual_install "slack" "https://slack.com/downloads/linux"
check_manual_install "spotify" "https://www.spotify.com/cz/download/linux/"
check_manual_install "code" "https://code.visualstudio.com/docs/setup/linux"

