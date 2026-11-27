[AUR](https://aur.archlinux.org/packages/loom-cli-git) package for [loom](https://github.com/the-loom-project/loom)

This repository holds the packaging files and the automation that builds the AUR package from upstream `master`.

[![AUR version](https://img.shields.io/aur/version/loom-cli-git)](https://aur.archlinux.org/packages/loom-cli-git)

## Install

```sh
paru -S loom-cli-git
# or
yay -S loom-cli-git
```

or manually:

```sh
git clone https://aur.archlinux.org/loom-cli-git.git
cd loom-cli-git
makepkg -si
```

this is a `-git` package, it builds whatever upstream `master` is at install time. to pick up new commits:

```sh
paru -Syu --devel
# or
yay -Syu --devel
```

## Automation

the package is not bumped on every upstream commit (AUR helpers handle that with `--devel`), so the workflow only:

- builds upstream HEAD daily and opens an issue if the build breaks
- publishes `PKGBUILD` and `.SRCINFO` to the AUR when they change on `master`

### Repository settings

| Kind | Name | Value |
|---|---|---|
| Secret | `AUR_SSH_KEY` | private key (no passphrase) whose public half is on the AUR account |
| Variable | `AUR_PUSH` | `true` to publish. anything else only runs the build check |

the built-in `github.token` is used for everything else.


## Changing the PKGBUILD

```sh
./update.sh          # must not run as root, builds HEAD and refreshes pkgver and .SRCINFO
git diff             # review
```

then commit and push, the workflow publishes it to the AUR.
