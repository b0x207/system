{...}: {
  flake.nixosModules.rofi = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      rofi
      rofi-calc
    ];
  };
}
