{ ... }: {
  flake.themes.gruvbox = {
    dark = {
      bg = "282828";
      fg = "ebdbb2";

      gray = "928374";
      red = "fb4934";
      green = "b8bb26";
      yellow = "fabd2f";
      blue = "83a598";
      purple = "d3869b";
      aqua = "8ec07c";
      orange = "fe8019";

      muted-gray = "a89984";
      muted-red = "cc241d";
      muted-green = "98971a";
      muted-yellow = "d79921";
      muted-blue = "458588";
      muted-purple = "b16286";
      muted-aqua = "689d6a";
      muted-orange = "d65d0e";
    };

    light = {
      bg = "fbf1c7";
    };
  };

  flake.nixosModules.theme = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # QT
      kdePackages.qqc2-breeze-style
      kdePackages.plasma-integration
      kdePackages.breeze-icons
      kdePackages.breeze-gtk
      kdePackages.breeze
      kdePackages.breeze.qt5

      # GTK
      gnome-themes-extra

      # For testing
      kdePackages.kate
      gtk4.dev
      gtk3.dev
      kdePackages.kcalc
    ];

    # programs.dconf.enable = true;

    # xdg.portal.config.common."org.freedesktop.appearance.color-scheme" = "1";
  };
}
