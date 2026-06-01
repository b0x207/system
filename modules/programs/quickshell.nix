{...}: {
  flake.nixosModules.quickshell = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      quickshell
    ];
  };
}
