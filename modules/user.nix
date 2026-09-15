{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.user = { pkgs, ... }: {
    users.users = {
      ben = {
        uid = 1000;
        description = "Ben";
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "libvirtd"
          "wireshark"
          "render"
          "video"
          "input"
        ];
        shell = pkgs.zsh;
      };
    };

    programs.zsh.enable = true;
    environment.pathsToLink = [ "/share/zsh" ];

    home-manager = {
      users.ben = {
        imports = [
          ../user/home-manager.nix

          inputs.catppuccin.homeModules.catppuccin
          self.homeModules.catppuccin

          self.homeModules.nix-output-monitor
          self.homeModules.fastfetch
          self.homeModules.atuin
          self.homeModules.git
          self.homeModules.ghostty
          self.homeModules.nushell
          self.homeModules.zsh
          self.homeModules.direnv
          self.homeModules.btop
          self.homeModules.theme
          self.homeModules.rofi
          self.homeModules.zathura
          self.homeModules.ssh
          self.homeModules.hyprland
          self.homeModules.quickshell
          self.homeModules.neovim
          self.homeModules.tmux
          self.homeModules.games
        ];
      };
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "hm-backup";
      extraSpecialArgs = { inherit inputs; };
    };
  };
}
