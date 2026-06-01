{inputs, ...}: {
  flake.nixosModules.hyprquickframe = {pkgs, ...}: {
    environment.systemPackages = [
      inputs.HyprQuickFrame.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
