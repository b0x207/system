{ ... }: {
  flake.homeModules.home-manager-base = { pkgs, ... }: {
    imports = [
      ../theme/home-manager.nix
    ];

    home.username = "ben";
    home.homeDirectory = "/home/ben";
    home.stateVersion = "26.05";

    programs.home-manager.enable = true;

    home.pointerCursor = {
      enable = true;
      package = pkgs.kdePackages.breeze-icons;
      name = "breeze_cursors";
      size = 24;
      gtk.enable = true;
      hyprcursor = {
        enable = true;
        size = 24;
      };
      dotIcons.enable = true;
      x11.enable = true;
    };
  };
}
