#!/usr/bin/env bash
set -e

ulimit -n 65535
# nix build nixpkgs#make-minimal-bootstrap-sources -L --log-format bar-with-logs
nh os switch .#`hostname` --ask --show-activation-logs --accept-flake-config \
    -- --max-substitution-jobs 4 $@
# pinix --pix-command nixos-rebuild --pix-log-history 0 --pix-record /tmp/pix-rebuild.log \
#     build --flake .#laptop --accept-flake-config $@
# nvd diff /run/current-system result
# gum confirm "Switch System?" && sudo ./result/bin/switch-to-configuration switch
