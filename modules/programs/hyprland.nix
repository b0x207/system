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

      # Hyprlock and dependencies
      bash
      hyprlock
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

    systemd.user.services.polkit-kde-agent = let
      kvantum = pkgs.kdePackages.qtstyleplugin-kvantum;
      agent = pkgs.kdePackages.polkit-kde-agent-1;
    in {
      description = "Polkit KDE Authentication Agent";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];

      path = [kvantum agent];

      serviceConfig = {
        ExecStart = "${agent}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
        Environment = [
          "QT_STYLE_OVERRIDE="
        ];
      };
    };

    security.pam.services.hyprlock = {};
  };

  flake.homeModules.hyprland = {config, ...}: let
    # TODO: make this not dependent upon the config source directory location
    hyprlandPath = "${config.home.homeDirectory}/config/user/hypr";
  in {
    xdg.configFile."hypr".source = config.lib.file.mkOutOfStoreSymlink hyprlandPath;
    xdg.configFile."wallpapers" = {
      source = ../../wallpapers;
      recursive = true;
    };

    home.file.".face".source = ../../user/face.jpg;
  };
}
