{ pkgs, ... }:
{
  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
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

    targets.gtk = {
      enable = true;
    };
    # targets.qt = {
    #   enable = true;
    #   platform = "qtct";
    # };
    targets.fontconfig.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gnome-themes-extra
    kdePackages.kcalc
    # catppuccin-kde
  ];

  # qt = {
  #   enable = true;
  #   platformTheme = "qt5ct";
  #   style = "kvantum";
  #   # style.name = "kvantum";
  # };
}
