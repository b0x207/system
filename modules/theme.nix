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
      kdePackages.qtstyleplugin-kvantum

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

    # environment.sessionVariables = {
    #   QT_QPA_PLATFORMTHEME = "kde";
    # };
  };

  flake.homeModules.theme = {
    pkgs,
    lib,
    ...
  }: {
    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";

      qt6ctSettings = {
        Appearance = {
          # style = "kvantum-dark";
          style = "Breeze";
          standard_dialogs = "default";
          custom_palette = true;
          icon_theme = "breeze-dark";

          color_scheme_path = "${pkgs.qt6Packages.qt6ct}/share/qt6ct/colors/darker.conf";
        };

        Fonts = {
          fixed = "DejaVu Sans,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
          general = "DejaVu Sans,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
        };

        Interface = {
          activate_item_on_single_click = 1;
          buttonbox_layout = 2; # KDE
          cursor_flash_time = 1000;
          dialog_buttons_have_icons = 1;
          double_click_interval = 400;
          gui_effects = "@Invalid()";
          keyboard_scheme = 3; # KDE
          menus_have_icons = true;
          show_shortcuts_in_context_menus = true;
          stylesheets = "@Invalid()";
          toolbutton_style = 4; # Follow application style
          underline_shortcut = 1;
          wheel_scroll_lines = 3;
        };

        SettingsWindow = {
          geometry = lib.concatStrings [
            "@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\xff\xff\xf8\x80\0\0\0\0\xff\xff\xff\xfd\0\0\x4"
            "\x80\xff\xff\xf8\x80\0\0\0\0\xff\xff\xff\xfd\0\0\x4\x80\0\0\0\0\x2\0\0\0\a\x80\xff"
            "\xff\xf8\x80\0\0\0\0\xff\xff\xff\xfd\0\0\x4\x80)"
          ];
        };

        Troubleshooting = {
          force_raster_widgets = 1;
          ignored_applications = "@Invalid()";
        };
      };
    };

    home.packages = with pkgs; [
      kdePackages.qtstyleplugin-kvantum
      libsForQt5.qtstyleplugin-kvantum
      catppuccin-kvantum
      qt6Packages.qt6ct
    ];
  };
}
