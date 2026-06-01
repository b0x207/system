{...}: {
  flake.nixosModules.theme = {pkgs, ...}: {
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

    /*
    stylix = {
      enable = true;
      autoEnable = false;
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      image = null; # ../wallpapers/earth-behind-moon.jpg;
      polarity = "dark";

      fonts = {
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };

        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };

        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };

        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };

        sizes = {
          applications = 10;
          desktop = 10;
        };
      };

      # icons = {
      #   enable = true;
      # };
      opacity = {
        terminal = 0.9;
      };

      targets.fontconfig.enable = true;
    };
    */
  };
}
