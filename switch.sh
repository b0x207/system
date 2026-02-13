ulimit -n 65535
sudo nixos-rebuild switch --flake .#system -L --log-format bar-with-logs
