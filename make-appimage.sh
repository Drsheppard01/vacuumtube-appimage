#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook:fix-namespaces.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/shy1132/VacuumTube/refs/heads/main/assets/icon.svg
export DESKTOP=https://raw.githubusercontent.com/shy1132/VacuumTube/refs/heads/main/flatpak/rocks.shy.VacuumTube.desktop

# Deploy dependencies
quick-sharun ./AppDir/bin/*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
