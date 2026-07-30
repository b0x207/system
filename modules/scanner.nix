{...}: {
  # TODO: find a way to dynamically include program modules as part of these larger category ones
  flake.nixosModules.scanner = {pkgs, ...}: {
    hardware.sane = {
      enable = true;
      extraBackends = [pkgs.hplipWithPlugin];
    };

    environment.systemPackages = with pkgs; [
      kdePackages.skanlite
    ];

    users.users.ben.extraGroups = ["scanner" "lp"];
  };
}
