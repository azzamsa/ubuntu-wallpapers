# Guide

## Getting Started

Fetch upstream images.

```bash
# get upstream wallpapers
$ git clone --depth 1 https://git.launchpad.net/ubuntu/+source/ubuntu-wallpapers ~/labs/forks/ubuntu-wallpapers

$ cd ubuntu-wallpapers
$ git pull --rebase origin ubuntu/devel
```

Curate the wallpapers.

```bash
$ git clone git@github.com:azzamsa/ubuntu-wallpapers.git
$ cd ubuntu-wallpapers
$ mise # or just copy the mise recipe to terminal
```

### Handling Duplicate Images

To prevent duplicate wallpapers from being included:

1. Run [czkawka](https://github.com/qarmin/czkawka) to scan for duplicate images in `curated`.
2. If duplicates are found, add their filenames to the `duplicate` field in `release.ron`.

Example:

```nu
# `Aeg_by_Tauno_Erik.jpg` already in `maverick` release
{codename: "natty",    version: "11.04", release_date: "2011-04-28", duplicates: ["Aeg_by_Tauno_Erik.jpg"]}
```

## How To Make Sure Your Code Works?

```bash
$ mise run clean
$ mise

$ git status
```

If no changes in `curated/` dir, it means your code works as expected.
As it prodoces the same result.

## Is There Any New Release?

See https://www.releases.ubuntu.com/
