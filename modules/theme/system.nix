{pkgs, ...}: {
  qt = {
    enable = true;
    platformTheme = "kde";
    # style = "breeze";
  };

  environment.systemPackages = with pkgs; [
    # QT
    kdePackages.qqc2-breeze-style
    kdePackages.plasma-integration
    kdePackages.breeze-icons
    kdePackages.breeze-gtk
    kdePackages.breeze

    # GTK
    gnome-themes-extra

    # For testing
    kdePackages.kate
    gtk4.dev
    gtk3.dev
  ];

  # programs.dconf.enable = true;

  # xdg.portal.config.common."org.freedesktop.appearance.color-scheme" = "1";

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "kde";
  };
}
