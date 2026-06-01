{inputs, ...}: {
  flake.nixosModules.catppuccin = {pkgs, ...}: {
    imports = [
      inputs.catppuccin.nixosModules.catppuccin
    ];

    catppuccin = {
      accent = "blue";
      flavor = "mocha";
      grub.enable = true;
      tty.enable = true;
    };
  };
}
