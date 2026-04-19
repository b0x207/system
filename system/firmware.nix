{ pkgs, ... }:
{
  imports = [];

  services.fwupd.enable = true;
  environment.systemPackages = with pkgs; [
    firmware-manager
    gnome-firmware
  ];
}
