#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

dnf5 install -y \
    @cinnamon-desktop \
    lightdm \
    lightdm-gtk \
    cinnamon-control-center \
    cinnamon-screensaver \
    cinnamon-session \
    cinnamon-settings-daemon \
    nemo nemo-extensions \
    mint-themes mint-x-icons mint-y-icons \
    curl git micro rsync wget

# Switch display manager: GDM (default in base-main) -> LightDM
systemctl disable gdm.service || true
systemctl enable lightdm.service

# Rebuild initramfs with --no-hostonly so it contains drivers for any hardware,
# not just what the build container sees. This is what prevents the
# "boots fine in the build, panics on real metal" failure mode.
KVER=$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}\n' | tail -1)
dracut --force --no-hostonly --kver "$KVER"

systemctl enable podman.socket
