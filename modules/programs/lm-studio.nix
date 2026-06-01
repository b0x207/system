{...}: {
  flake.nixosModules.lm-studio = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      lmstudio
    ];
  };
}
