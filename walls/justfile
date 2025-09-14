#!/usr/bin/env -S just --justfile

set dotenv-load := true

alias d := dev
alias r := run
alias f := fmt
alias l := lint
alias c := comply
alias k := check

[doc('List available commands')]
_default:
    just --list --unsorted

[doc('Tasks to make the code-base comply with the rules. Mostly used in git hooks')]
comply: fmt lint

[doc('Check if the repository comply with the rules and ready to be pushed')]
check: fmt-check lint

[doc('Develop the app')]
dev:
    bacon

[doc('Run the app')]
run:
    cargo run

[doc('Format the codebase.')]
fmt:
    cargo fmt --all
    dprint fmt

[doc('Check is the codebase properly formatted')]
fmt-check:
    cargo fmt --all -- --check
    dprint check

[doc('Lint the codebase')]
lint:
    cargo clippy --all-targets --all-features
    typos

[doc('Check dependencies health. Pass `--write` to upgrade dependencies')]
up arg="":
    #!/usr/bin/env bash
    if [ "{{ arg }}" = "--write" ]; then
        cargo upgrade --incompatible --recursive --verbose
        cargo update
        dprint config update
    else
        cargo outdated --root-deps-only
    fi;
