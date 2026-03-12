{
	description = "System config flake";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-intel-compiler.url = "github:NixOS/nixpkgs?ref=pull/470035/head";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
		neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    hyprland.url = "github:HyprWM/Hyprland";
    hyprshutdown.url = "github:hyprwm/hyprshutdown";
    catppuccin = {
      url = "github:catppuccin/nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gc-env.url = "github:Julow/nix-gc-env";
    utpm.url = "github:typst-community/utpm";
    typst = {
      url = "github:typst/typst-flake";
      inputs.typst.follows = "typst-src";
    };
    typst-src = {
      url = "github:typst/typst";
      flake = false;
    };
    agenix.url = "github:ryantm/agenix";
    HyprQuickFrame.url = "github:Ronin-CK/HyprQuickFrame?rev=d8750eab1963886085c66d4b19c5ccc49f59869c";

    typst-plantuml.url = "github:b0x207/typst-plantuml";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dolphin-overlay = {
      url = "github:rumboon/dolphin-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
	};

  # nixConfig.substituters = [];

	outputs = { self, nixpkgs, home-manager, catppuccin, nix-gc-env, agenix, ... }@inputs: {
		nixosConfigurations.system = nixpkgs.lib.nixosSystem {
			modules = [
				./system/configuration.nix
        home-manager.nixosModules.home-manager
        catppuccin.nixosModules.catppuccin
        # nix-gc-env.nixosModules.default
        agenix.nixosModules.default
			];
			specialArgs = { flake = self; inherit inputs; };
		};
	};
}
