#!/usr/bin/env bash
set -e

ulimit -n 65535
nh os switch .#`hostname` --ask --show-activation-logs --accept-flake-config \
    -- --max-substitution-jobs 4 $@
