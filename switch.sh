#!/usr/bin/env bash
set -e

ulimit -n 65535

if [[ "$OSTYPE" == "darwin"* ]]; then
    nh darwin switch .#skalkr --ask --show-activation-logs --accept-flake-config \
        -- --max-substitution-jobs 4 $@
else
    nh os switch .#`hostname` --ask --show-activation-logs --accept-flake-config \
        -- --max-substitution-jobs 4 $@
fi
