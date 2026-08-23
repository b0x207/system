{...}: {
  # TODO: find a way to dynamically include program modules as part of these larger category ones
  flake.nixosModules.scanner = {pkgs, ...}: {
    hardware.sane = {
      enable = true;
      extraBackends = [
        pkgs.hplipWithPlugin
        pkgs.sane-backends
      ];
    };

    environment.systemPackages = with pkgs; [
      kdePackages.skanlite
      kdePackages.skanpage
      hplip
      simple-scan
      gscan2pdf
    ];

    users.users.ben.extraGroups = ["scanner" "lp"];
  };
}
