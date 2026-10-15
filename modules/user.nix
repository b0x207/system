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
          self.homeModules.home-manager-base

          # Core
          self.homeModules.git
          self.homeModules.btop
          self.homeModules.ssh
          self.homeModules.hyprland
          self.homeModules.quickshell
          self.homeModules.neovim
          self.homeModules.tmux
          self.homeModules.theme
          self.homeModules.atuin
          self.homeModules.ghostty
          self.homeModules.direnv
          self.homeModules.clipboard
          self.homeModules.sway-notification-center

          # Shells
          self.homeModules.zsh
          self.homeModules.nushell

          # Browsers
          self.homeModules.firefox
          self.homeModules.tor-browser

          # Misc
          self.homeModules.agent
          self.homeModules.lazygit
          self.homeModules.rofi
          self.homeModules.games
          self.homeModules.zathura
          self.homeModules.fzf
          self.homeModules.discord
          self.homeModules.mpv
          self.homeModules.fastfetch
        ];
      };
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "hm-backup";
      extraSpecialArgs = { inherit inputs; };
    };
  };
}
