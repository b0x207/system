{ ... }: {
  flake.homeModules.rofi = { pkgs, ... }: {
    programs.rofi = {
      enable = true;

      settings = {
        cycle = true;
        location = 0; # 0 = center
        extraConfig = {
          scroll-method = 1; # 1 = continuous scroll
        };
        modes = [
          "drun"
          "calc"
        ];
      };

      plugins = [ pkgs.rofi-calc ];
    };

    catppuccin.rofi.enable = true;
  };
}
