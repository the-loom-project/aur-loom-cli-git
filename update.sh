#!/usr/bin/env bash

# this is a helper script which builds the package from upstream HEAD and refreshes pkgver and .SRCINFO
# run it after editing PKGBUILD and before pushing to the AUR
# NEVER RUN AS ROOT (makepkg refuses)

set -euo pipefail

cd "$(dirname "$0")"

# builds from upstream HEAD, makepkg rewrites pkgver in PKGBUILD from pkgver()
makepkg -fd --noconfirm
ver=$(sed -n 's/^pkgver=//p' PKGBUILD)

# sanity check that the package contains the expected files
pkg=$(ls -1 loom-cli-git-"$ver"-*.pkg.tar.zst)
files=$(bsdtar -tf "$pkg")
grep -qx 'usr/bin/loom' <<<"$files"
grep -qx 'usr/share/fish/vendor_completions.d/loom.fish' <<<"$files"
grep -qx 'usr/share/licenses/loom-cli-git/LICENSE' <<<"$files"

# the completion must not be empty (it would be if loom failed during build)
bsdtar -xOf "$pkg" usr/share/fish/vendor_completions.d/loom.fish | grep -q '^complete '

# generates .SRCINFO
makepkg --printsrcinfo > .SRCINFO

# cleanup
rm -rf src pkg loom ./*.pkg.tar.zst

echo "ok: $ver"
