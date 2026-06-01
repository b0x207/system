{...}: {
  flake.nixosModules.sway-notification-center = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      swaynotificationcenter
    ];
  };
}
