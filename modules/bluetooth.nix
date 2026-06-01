{...}: {
  flake.nixosModules.bluetooth = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      blueman
      bluejay
    ];

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
