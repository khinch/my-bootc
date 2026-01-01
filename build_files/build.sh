#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Packages from fedora repos
dnf5 install -y \
	alacritty \
	clang \
	cmake \
	fatsort \
	gitui \
	gtypist \
	helix \
  lldb \
  lldb \
	neovim \
	pdfgrep \
	rustup \
	stow

# Install pgAdmin4-desktop 
dnf -y install \
  https://ftp.postgresql.org/pub/pgadmin/pgadmin4/yum/pgadmin4-fedora-repo-2-1.noarch.rpm
dnf -y install pgadmin4-desktop

# Signal Desktop via COPR
dnf5 -y copr enable useidel/signal-desktop
dnf5 install -y signal-desktop
dnf5 -y copr disable useidel/signal-desktop

# Yazi via COPR
dnf5 -y copr enable lihaohong/yazi
dnf5 install -y yazi
dnf5 -y copr disable lihaohong/yazi

# Packages outside of Fedora repositories
cd /tmp

# Veracrypt
curl -LO "https://launchpad.net/veracrypt/trunk/1.26.24/+download/veracrypt-1.26.24-Fedora-40-x86_64.rpm"
rpm --import 'https://amcrypto.jp/VeraCrypt/VeraCrypt_PGP_public_key.asc'
rpm --checksig -v veracrypt-1.26.24-Fedora-40-x86_64.rpm
dnf install -y veracrypt-1.26.24-Fedora-40-x86_64.rpm

# Megasync
curl -LO "https://mega.nz/linux/repo/Fedora_42/x86_64/megasync-Fedora_42.x86_64.rpm"
curl -LO "https://mega.nz/linux/repo/Fedora_42/x86_64/nautilus-megasync-Fedora_42.x86_64.rpm"
curl -LO "https://mega.nz/linux/repo/Fedora_42/x86_64/thunar-megasync-Fedora_42.x86_64.rpm"

rm /opt
mkdir /opt

dnf install -y --nogpgcheck --setopt=tsflags=noscripts \
  ./megasync-Fedora_42.x86_64.rpm \
  ./nautilus-megasync-Fedora_42.x86_64.rpm \
  ./thunar-megasync-Fedora_42.x86_64.rpm

# Clean up
dnf clean all
rm -rf /var/cache/dnf

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
