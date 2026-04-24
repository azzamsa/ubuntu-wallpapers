#!/usr/bin/env nu

# Usage:
# $ SOURCE=~/labs/forks/ubuntu-wallpapers ROOT=$(pwd) nu src/curate.nu

#
# Prepare dirs
#
let source = $env.SOURCE
let script_dir = $env.CURRENT_FILE | path dirname
let curated = $"($script_dir)/../curated"

#
# Curate
#
def main []: nothing -> nothing {
    # How many releases are there?
    let releases = try {
        open $"($script_dir)/releases.nuon"
    } catch { |e|
        error make { msg: $"failed to read releases.nuon: ($e.msg)" }
    }

    for release in $releases {
        let codename = $release.codename
        let duplicates = $release | get --optional duplicates | default []
        # Wallpaper filenames for this release
        let walls = extract-walls $codename $duplicates

        curate $codename $walls
        preview $codename $walls
    }

    keep-license-files
}

# Read .wallpapers.xml.in in each release directory
# and extract wallpaper filenames skipping duplicates
def extract-walls [codename: string, duplicates: list<string>]: nothing -> list<string> {
    let xml_path = $"($source)/($codename)-wallpapers.xml.in"

    let parsed = try {
        open $xml_path | from xml --allow-dtd
    } catch { |e|
        error make { msg: $"failed to parse ($xml_path): ($e.msg)" }
    }

    $parsed
    | get content
    | where tag == wallpaper
    | each {|wallpaper|
        # collect both `filename` and `filename-dark` nodes
        $wallpaper.content
        | where tag in [filename filename-dark]
        | each {|node| $node.content.0?.content }
    }
    | flatten
    | compact                                      # drop any nulls from 0?
    | each {|path| $path | path basename }         # keep filename only
    | where { not ($it | str ends-with .xml) }
    | where { $it not-in $duplicates }
}

# Copy wallpapers to the curated directory
def curate [codename: string, walls: list<string>]: nothing -> nothing {
    let dest = $"($curated)/($codename)"
    try { mkdir $dest } catch { |e|
        error make { msg: $"mkdir ($dest) failed: ($e.msg)" }
    }

    for wall in $walls {
        try {
            cp $"($source)/($wall)" $"($dest)/($wall)"
        } catch { |e|
            error make { msg: $"cp ($wall) failed: ($e.msg)" }
        }
    }
}

# Generate a README.md preview for the curated wallpapers
def preview [codename: string, walls: list<string>]: nothing -> nothing {
    let base = "https://raw.githubusercontent.com/azzamsa/ubuntu-wallpapers/refs/heads/master/curated"
    let body = $walls
    | each {|f| $"<img src=\"($base)/($codename)/($f)\">\n" }
    | str join "\n"

    let readme = $"($curated)/($codename)/README.md"
    try {
        $"# ($codename)\n\n($body)" | save --force $readme
    } catch { |e|
        error make { msg: $"save ($readme) failed: ($e.msg)" }
    }
}

# Copy meta files (AUTHORS, COPYING) to the curated directory
# to comply with the license
def keep-license-files []: nothing -> nothing {
    for f in [AUTHORS COPYING] {
        try {
            cp $"($source)/($f)" $"($curated)/($f)"
        } catch { |e|
            error make { msg: $"cp ($f) failed: ($e.msg)" }
        }
    }
}
