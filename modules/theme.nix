{...}: {
  flake.nixosModules.theme = {pkgs, ...}: {
    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "kvantum";
    };

    environment.systemPackages = with pkgs; [
      # QT
      kdePackages.qqc2-breeze-style
      kdePackages.plasma-integration
      kdePackages.breeze-icons
      kdePackages.breeze-gtk
      kdePackages.breeze
      kdePackages.breeze.qt5
      kdePackages.qt6ct

      # GTK
      gnome-themes-extra

      # For testing
      kdePackages.kate
      gtk4.dev
      gtk3.dev
    ];

    # programs.dconf.enable = true;

    # xdg.portal.config.common."org.freedesktop.appearance.color-scheme" = "1";

    # environment.sessionVariables = {
    #   QT_QPA_PLATFORMTHEME = "kde";
    # };
  };

  flake.homeModules.theme = {...}: {
    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
    };
  };
}
