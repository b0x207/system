#!/usr/bin/env bash
set -e

ulimit -n 65535

# To ensure boostrap always works
echo "Building minimal bootstrap sources"
nom build .#make-minimal-bootstrap-sources

NH_ROM=1 nh os switch ".#$(hostname)" --ask --accept-flake-config --diff always \
    -- --max-substitution-jobs 4 "$@"
#--option substitute false --option substituters ''
