{inputs, ...}: {
  flake.nixosModules.catppuccin = {pkgs, ...}: {
    imports = [
      inputs.catppuccin.nixosModules.catppuccin
    ];

    catppuccin = {
      autoEnable = false;
      enable = true;

      accent = "blue";
      flavor = "mocha";
      grub.enable = true;
      limine.enable = true;
      tty.enable = true;
    };
  };
}
