{...}: {
  flake.homeModules.rofi = {pkgs, ...}: {
    programs.rofi = {
      enable = true;

      cycle = true;
      location = "center";
      extraConfig = {
        scroll-method = 1; # 1 = continuous scroll
      };

      plugins = [pkgs.rofi-calc];

      modes = ["drun" "calc"];
    };

    catppuccin.rofi.enable = true;
  };
}
