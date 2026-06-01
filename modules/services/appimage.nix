{...}: {
  flake.nixosModules.appimage = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      appimage-run
    ];
  };
}
