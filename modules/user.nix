{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.user = {pkgs, ...}: {
    users.users = {
      ben = {
        uid = 1000;
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "libvirtd"
          "wireshark"
          "render"
          "video"
        ];
        shell = pkgs.zsh;
      };
    };

    programs.zsh.enable = true;
    environment.pathsToLink = ["/share/zsh"];

    home-manager = {
      users.ben = {
        imports = [
          ../user/home-manager.nix
          inputs.catppuccin.homeModules.catppuccin
          self.homeModules.btop
          self.homeModules.theme
          self.homeModules.rofi
          self.homeModules.zathura
          self.homeModules.ssh
          self.homeModules.hyprland
          self.homeModules.quickshell
          self.homeModules.neovim
          self.homeModules.tmux
        ];
      };
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "hm-backup";
      extraSpecialArgs = {inherit inputs;};
    };
  };
}
