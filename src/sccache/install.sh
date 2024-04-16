#!/bin/bash
set -e

if ! which rustup > /dev/null; then
    which curl > /dev/null || (apt update && apt install curl -y -qq)
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
fi

dpkg -l | grep build-essential || (apt update && apt install build-essential -y -qq)



umask 002
cargo install sccache --locked -y

mkdir /.cargo
echo "[build]" >> /.cargo/config.toml
echo "rustc-wrapper = \"sccache\"" >> /.cargo/config.toml