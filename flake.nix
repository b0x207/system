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
    nix-gc-env.url = "github:Julow/nix-gc-env";
    utpm = {
      url = "github:typst-community/utpm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    typst = {
      url = "github:typst/typst-flake";
      inputs.typst.follows = "typst-src";
    };
    typst-src = {
      url = "github:typst/typst";
      flake = false;
    };
    agenix.url = "github:ryantm/agenix";
    HyprQuickFrame = {
      url = "github:Ronin-CK/HyprQuickFrame";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    typst-plantuml.url = "github:b0x207/typst-plantuml";
	};

  nixConfig = {
    substituters = [];
  };

	outputs = { self, nixpkgs, home-manager, catppuccin, nix-gc-env, agenix, ... }@inputs: {
		nixosConfigurations.system = nixpkgs.lib.nixosSystem {
			modules = [
				./system/configuration.nix
        home-manager.nixosModules.home-manager
        catppuccin.nixosModules.catppuccin
        nix-gc-env.nixosModules.default
        agenix.nixosModules.default
			];
			specialArgs = { flake = self; inherit inputs; };
		};
	};
}
