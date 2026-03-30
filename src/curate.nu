#!/usr/bin/env nu

# Usage:
# $ SOURCE=~/labs/forks/ubuntu-wallpapers ROOT=$(pwd) nu src/curate.nu

#
# Prepare dirs
#
let source = $env.SOURCE
let curated = $"($env.CURRENT_FILE | path dirname)/../curated"

#
# Curate
#
def main [] {
    # How many releases are there?
    let releases = open $"($env.CURRENT_FILE | path dirname)/releases.nuon"

    for release in $releases {
        let codename = $release.codename
        let duplicates = $release | get --optional duplicates | default []
        # Wallpaper filenames for this release
        let walls = extract-walls $codename $duplicates

        # print $codename
        # print $walls
        curate $codename $walls
        preview $codename $walls
    }

    keep-license-files
}

# Read .wallpapers.xml.in in ecah release directory
# and extract wallpaper filenames skipping duplicates
def extract-walls [codename: string, duplicates: list<string>] {
    let xml_path = $"($source)/($codename)-wallpapers.xml.in"

    open $xml_path
    | from xml --allow-dtd
    | get content
    | where tag == "wallpaper"
    | each {|wallpaper|
        # collect both `filename` and `filename-dark` nodes
        $wallpaper.content
        | where tag in ["filename", "filename-dark"]
        | each {|node| $node.content.0.content }
    }
    | flatten
    | each {|path| $path | path basename }         # keep filename only
    | where {|name| not ($name | str ends-with ".xml") }
    | where {|name| $name not-in $duplicates }
}

# Copy wallpapers to the curated directory
def curate [codename: string, walls: list<string>] {
    let dest = $"($curated)/($codename)"
    mkdir $dest

    for wall in $walls {
        cp $"($source)/($wall)" $"($dest)/($wall)"
    }
}

# Generate a README.md preview for the curated wallpapers
def preview [codename: string, walls: list<string>] {
    let base = "https://raw.githubusercontent.com/azzamsa/ubuntu-wallpapers/refs/heads/master/curated"

    let body = $walls
    | each {|f| $"<img src=\"($base)/($codename)/($f)\">\n" }
    | str join "\n"

    $"# ($codename)\n\n($body)"
    | save --force $"($curated)/($codename)/README.md"
}

# Copy meta files (AUTHORS, COPYING) to the curated directory
# To comply with the license
def keep-license-files [] {
    for f in ["AUTHORS", "COPYING"] {
        cp $"($source)/($f)" $"($curated)/($f)"
    }
}
