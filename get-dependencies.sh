#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    libnotify \
    libnss_nis \
    libxss \
    libxtst

if [ "$ARCH" = 'x86_64' ]; then
    pacman -Syu --noconfirm libva-intel-driver
fi

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini intel-media-driver-mini

echo "Getting app..."
echo "---------------------------------------------------------------"
case "$ARCH" in
aarch64) farch=arm64 ;;
x86_64) farch=x64 ;;
esac
TARBALL_LINK=$(wget https://api.github.com/repos/shy1132/VacuumTube/releases -O - |
    sed 's/[()",{} ]/\n/g' | grep -o -m 1 "https.*/VacuumTube.*${farch}.tar.gz")

wget --retry-connrefused --tries=30 "$TARBALL_LINK" -O ./"${TARBALL_LINK##*/}"

mkdir -p ./AppDir/bin
tar -xvf ./"${TARBALL_LINK##*/}"
mv -v ./VacuumTube/* ./AppDir/bin

echo "$TARBALL_LINK" | awk -F'/' '{print $(NF-1)}' | awk -F'-' '{print $NF}' >~/version
