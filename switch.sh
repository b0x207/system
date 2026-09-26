#!/usr/bin/env bash
set -e

ulimit -n 65535

# To ensure boostrap always works
echo "Building minimal bootstrap sources"
nom build .#make-minimal-bootstrap-sources

nh os switch ".#$(hostname)" --ask --show-activation-logs --accept-flake-config \
    -- --max-substitution-jobs 4 --option substitute false --option substituters '' "$@"
