# TODO: document findings on how theming QT works
{ self, ... }: {
  flake.homeModules.qt-theme = { pkgs, lib, ... }: {
    home.packages = [
      # For testing
      pkgs.kdePackages.qttools
    ];

    xdg.dataFile."color-schemes/GruvboxDark.colors" = {
      text =
        let
          colorsGenerator = self.lib.generators.toQTColors { };
          palette = lib.mapAttrs (_: color: "#${color}") self.themes.gruvbox.dark;
        in
        colorsGenerator {
          name = "Gruvbox Dark";
          identifier = "GruvboxDark";

          bg = {
            normal = palette.bg;
            selection = palette.orange;
          };

          fg = {
            normal = palette.fg;
            positive = palette.green;
            negative = palette.red;
          };

          link = {
            normal = palette.blue;
            visited = palette.purple;
          };

          decoration = palette.aqua;

          button.normal = palette.bg;

          effects = {
            disabled = palette.gray;
            inactive = palette.red;
          };
        };
      force = true;
    };
  };
}
