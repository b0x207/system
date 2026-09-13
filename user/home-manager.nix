{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./firefox.nix
    ../theme/home-manager.nix
  ];

  home.username = "ben";
  home.homeDirectory = "/home/ben";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.mpv.enable = true;

  programs.discord = {
    enable = true;
    settings.SKIP_HOST_UPDATE = true;
  };

  programs.fzf = {
    enable = true;
    historyWidget.command = "";
  };

  services.swaync = {
    enable = true;
  };

  catppuccin = {
    swaync = {
      enable = true;
      font = "JetBrainsMono Nerd Font";
    };
    # cursors = {
    #   enable = true;
    #   accent = "dark";
    # };
    # gtk.icon.enable = true;
    fzf.enable = true;
  };

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
}
