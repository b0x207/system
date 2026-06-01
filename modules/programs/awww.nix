{...}: {
  flake.nixosModules.awww = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      awww
    ];
  };
}
