# Guide

### Handling Duplicate Images

To prevent duplicate wallpapers from being included:

1. Run [czkawka](https://github.com/qarmin/czkawka) to scan for duplicate images in `curated`.
2. If duplicates are found, add their filenames to the `duplicate` field in `release.ron`.

Example:

```ron
releases: [
    (
        codename: "natty",
        version: "11.04",
        release_date: "2011-04-28",
        duplicates: ["Aeg_by_Tauno_Erik.jpg"],
    ),
]
```
