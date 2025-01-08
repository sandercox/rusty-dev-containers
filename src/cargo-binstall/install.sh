#!/bin/bash
set -e

umask 002

PACKAGES=${PACKAGES:-""}

CARGO_PACKAGES=("${PACKAGES//,/ }")

if ! (which rustup > /dev/null && which cargo > /dev/null); then
    which curl > /dev/null || (apt update && apt install curl -y -qq)
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
fi

dpkg -l | grep build-essential || (apt update && apt install build-essential -y -qq)

(curl -L --proto '=https' --tlsv1.2 -sSf \
    https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh \
    | bash) \
 || cargo install cargo-binstall

if [ -z "${PACKAGES}" ]; then
    echo "No packages specified, and no upgrade required. Skip installation..."
    exit 0
fi

cargo binstall -y --force --locked $CARGO_PACKAGES
