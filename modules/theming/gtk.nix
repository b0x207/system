{ ... }: {
  flake.homeModules.gtk-theme = { ... }: {
    gtk = {
      enable = true;

      gtk4 = {
        enable = true;
        colorScheme = "dark";
      };
    };
  };
}
