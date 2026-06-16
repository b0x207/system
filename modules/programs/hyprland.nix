{...}: {
  flake.nixosModules.hyprland = {pkgs, ...}: {
    programs.hyprland = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      # Included packages because it is part of the hyprland umbrella
      hyprshutdown
      hyprpolkitagent

      # Other basic functions
      libnotify
      libdrm.dev
      libdrm

      # TODO: move to a better place
      brightnessctl
      dex
      satty
      networkmanagerapplet
    ];

    programs.xwayland.enable = true;
    security.polkit.enable = true;
    services.seatd.enable = true;

    xdg.portal = {
      enable = true;
      configPackages = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.kdePackages.xdg-desktop-portal-kde
      ];
      config = {
        common = {
          default = [
            "hyprland"
            "kde"
          ];
          "org.freedesktop.impl.portal.FileChooser" = "kde";
        };

        hyprland = {
          default = [
            "hyprland"
            "kde"
          ];
        };
      };
    };
  };

  flake.homeModules.hyprland = {config, ...}: let
    nvimPath = "${config.home.homeDirectory}/config/user/hypr";
  in {
    xdg.configFile."hypr".source = config.lib.file.mkOutOfStoreSymlink nvimPath;
  };
}
