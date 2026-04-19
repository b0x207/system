set -e
ulimit -n 65535
#sudo nixos-rebuild switch --flake .#system -L --log-format bar-with-logs
nix build nixpkgs#make-minimal-bootstrap-sources -L --log-format bar-with-logs

# I don't want to (and don't have enough RAM for) building firefox
# nix build .#nixosConfigurations.system.pkgs.firefox -L --log-format bar-with-logs \
#     --substituters "https://cache.nixos.org" --option fallback false

nh os switch .#system --ask --accept-flake-config -- --max-jobs 1 --cores 8 $@
