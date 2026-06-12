{...}: {
  flake.homeModules.rofi = { pkgs, ... }: {
    programs.rofi = {
      enable = true;

      cycle = true;
      location = "center";

      plugins = [ pkgs.rofi-calc ];
      
      modes = ["drun" "calc"];
    };

    catppuccin.rofi.enable = true;
  };
}
