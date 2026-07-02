{...}: {
  flake.nixosModules.xonotic = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      xonotic
    ];
  };
}
