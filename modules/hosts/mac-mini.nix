{
  inputs,
  self,
  ...
}:
{
  flake.darwinConfigurations.skalkr = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      self.modules.darwin.skalkr-config

      inputs.home-manager.darwinModules.home-manager

      self.modules.darwin.tailscale
    ];
  };

  flake.modules.darwin.skalkr-config = { config, pkgs, ... }: {
    nixpkgs.hostPlatform = "aarch64-darwin";

    nixpkgs.config = {
      allowUnfree = true;
    };

    nix.settings.experimental-features = "nix-command flakes";

    networking = {
      computerName = "skálkr";
      hostName = "skalkr";
    };

    users.users.ben = {
      name = "ben";
      home = "/Users/ben";
      shell = pkgs.zsh;
    };

    home-manager = {
      users.ben.imports = [
        # Basic module to setup core functionality
        ({ osConfig, ... }: {
          programs.bash.enable = true;
          home.stateVersion = "26.05";

          programs.nh = {
            enable = true;
            flake = "${osConfig.users.users.ben.home}/config";
          };
        })

        inputs.catppuccin.homeModules.catppuccin
        self.homeModules.catppuccin

        self.homeModules.tmux
        self.homeModules.fastfetch
        self.homeModules.atuin
        self.homeModules.git
        self.homeModules.nushell
        self.homeModules.zsh
        self.homeModules.direnv
        self.homeModules.ghostty
        self.homeModules.btop
        self.homeModules.neovim
      ];

      useUserPackages = false;
      useGlobalPkgs = true;
    };

    system.configurationRevision = toString (self.rev or self.dirtyRev or "unknown");

    system.stateVersion = 6;
  };
}
