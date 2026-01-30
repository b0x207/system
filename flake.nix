{
	description = "System config flake";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
		neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    hyprland.url = "github:HyprWM/Hyprland";
    hyprshutdown.url = "github:hyprwm/hyprshutdown";
    # aw-window-watcher-hyprland.url = "github:bobvanderlinden/aw-watcher-window-hyprland";
    catppuccin = {
      url = "github:catppuccin/nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:aylur/ags";
    astal.url = "github:aylur/astal";
	};

  nixConfig = {
    # substituters = [];
  };

	outputs = { self, nixpkgs, home-manager, catppuccin, ... }@inputs: {
		nixosConfigurations.system = nixpkgs.lib.nixosSystem {
			modules = [
				./system/configuration.nix
        home-manager.nixosModules.home-manager
        catppuccin.nixosModules.catppuccin
			];
			specialArgs = { inherit inputs; };
		};
	};
}
