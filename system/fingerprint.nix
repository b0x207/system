{ pkgs, ... }:
{
  imports = [];

  services.fprintd = {
    enable = false;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-broadcom-cv3plus;
    };
  };

  programs.wireshark = {
    enable = false;
    package = pkgs.wireshark;
    usbmon.enable = true;
  };
}
