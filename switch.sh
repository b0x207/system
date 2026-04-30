#!/usr/bin/env bash
set -e

ulimit -n 65535
nix build nixpkgs#make-minimal-bootstrap-sources -L --log-format bar-with-logs
nh os switch .#system --ask --accept-flake-config -- \
    --max-jobs 1 --max-substitution-jobs 2 --cores 4 $@
