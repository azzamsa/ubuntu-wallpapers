#!/usr/bin/env -S just --justfile

alias r := run
alias f := fmt
alias l := lint
alias c := comply
alias k := check

[doc('List available commands')]
_default:
    just --list --unsorted

[doc('Setup the project')]
setup:
    cp -n .scripts/hooks/pre-commit .git/hooks/

[doc('Clean Target Output')]
clean:
    #!/usr/bin/env bash
    rm -rf curated

[doc('Comply, then check')]
qq: comply check

[doc('Tasks to make the code-base comply with the rules. Mostly used in git hooks')]
comply: fmt lint

[doc('Check if the repository comply with the rules and ready to be pushed')]
check: fmt-check lint

[doc('Run the app')]
run:
    SOURCE=~/labs/forks/ubuntu-wallpapers nu src/curate.nu

[doc('Format the codebase.')]
fmt:
    dprint fmt

[doc('Check is the codebase properly formatted')]
fmt-check:
    dprint check

[doc('Lint the codebase')]
lint:

[doc('Check dependencies health. Pass `--write` to upgrade dependencies')]
up:

[doc('Dependency analysis')]
meta:
    pnpx actions-up
    actionlint
