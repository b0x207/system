#!/usr/bin/env bash
set -e

ulimit -n 65535
nix build nixpkgs#make-minimal-bootstrap-sources -L --log-format bar-with-logs
nh os switch .#laptop --ask --accept-flake-config -- --max-substitution-jobs 4 $@
