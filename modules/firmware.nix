{...}: {
  flake.nixosModules.firmware = {pkgs, ...}: {
    services.fwupd.enable = true;
    environment.systemPackages = with pkgs; [
      firmware-manager
      gnome-firmware
    ];
  };
}
