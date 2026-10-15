{ ... }: {
  flake.homeModules.rofi =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
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

          terminal = "${lib.getExe config.programs.ghostty.package}";
          font = "JetBrainsMono 12";
        };

        plugins = [ pkgs.rofi-calc ];
        theme = "${pkgs.rofi}/share/rofi/themes/gruvbox-dark.rasi";
      };
    };
}
