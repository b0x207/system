{...}: {
  flake.nixosModules.multimedia-tools = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      obs-studio
      krita
      vimiv-qt
      mpv
    ];
  };
}
