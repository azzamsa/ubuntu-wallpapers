# Guide

## Getting Started

Fetch upstream images.

```bash
# get upstream wallpapers
$ git clone --depth 1 https://git.launchpad.net/ubuntu/+source/ubuntu-wallpapers ~/labs/forks/ubuntu-wallpapers-upstream

$ cd ubuntu-wallpapers-upstream
$ git pull --rebase origin ubuntu/devel
```

Curate the wallpapers.

```bash
$ git clone git@github.com:azzamsa/ubuntu-wallpapers.git
$ cd ubuntu-wallpapers
$ mise run  # or copy the mise recipe into your terminal
```

## Help, There’s a New Release!

Pull the latest changes from upstream.

```bash
$ cd ubuntu-wallpapers-upstream
$ git pull --rebase origin ubuntu/devel
```

Add new entry to `src/releases.noun` based on data in https://www.releases.ubuntu.com.

```
[DIR] resolute/               2026-04-23 15:50    -   Ubuntu 26.04 LTS (Resolute Raccoon)
```

```diff
    {codename: "questing", version: "25.10", release_date: "2025-10-09"}
+   {codename: "resolute", version: "26.04", release_date: "2026-04-23"}
]
```

Then, run.

``` bash
mise run
```

Now, check duplicate images using the guide below.

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
$ mise run

$ git status
```

If no changes in `curated/` dir, it means your code works as expected.
As it prodoces the same result.
