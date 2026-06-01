{...}: {
  flake.nixosModules.battery = {pkgs, ...}: {
    services.upower.enable = true;

    # TODO: split out into separate module when switching to notashelf/watt
    services.auto-cpufreq.enable = true;
  };
}
