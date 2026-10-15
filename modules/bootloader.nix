{ self, ... }: {
  flake.nixosModules.bootloader = { pkgs, config, ... }: {
    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      limine = {
        enable = true;
        efiInstallAsRemovable = pkgs.lib.mkIf config.networking.hostName == "dekstop";
        panicOnChecksumMismatch = true;

        style = {
          backdrop = self.themes.gruvbox.dark.bg;

          wallpapers = [ ../wallpapers/gruvy-night.jpg ];
          wallpaperStyle = "centered";

          interface = {
            helpHidden = false;
            helpColor = self.themes.gruvbox.dark.muted-aqua;
            helpColorBright = self.themes.gruvbox.dark.aqua;
            brandingColor = self.themes.gruvbox.dark.blue;
          };

          graphicalTerminal = {
            palette = builtins.concatStringsSep ";" [
              self.themes.gruvbox.dark.bg
              self.themes.gruvbox.dark.muted-red
              self.themes.gruvbox.dark.muted-green
              self.themes.gruvbox.dark.muted-orange
              self.themes.gruvbox.dark.muted-blue
              self.themes.gruvbox.dark.muted-purple
              self.themes.gruvbox.dark.muted-aqua
              self.themes.gruvbox.dark.muted-gray
            ];
            brightPalette = builtins.concatStringsSep ";" [
              self.themes.gruvbox.dark.muted-gray
              self.themes.gruvbox.dark.red
              self.themes.gruvbox.dark.green
              self.themes.gruvbox.dark.orange
              self.themes.gruvbox.dark.blue
              self.themes.gruvbox.dark.purple
              self.themes.gruvbox.dark.aqua
              self.themes.gruvbox.dark.fg
            ];
          };
        };

        extraEntries =
          let
            part-uuid =
              if config.networking.hostName == "laptop" then
                "b74e7d45-3da0-4bb3-87d5-81c34d474029"
              else
                "a9a567e8-a803-4627-9a22-65ee168da73f";
          in
          ''
            /Windows
              protocol: efi
              path: uuid(${part-uuid}):/EFI/Microsoft/Boot/bootmgfw.efi
          '';
      };
    };
  };
}
