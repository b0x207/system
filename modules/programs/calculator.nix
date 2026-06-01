{...}: {
  flake.nixosModules.calculator = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      qalculate-qt
      libqalculate
      fend
    ];
  };
}
