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

    todo-tree.url = "github:alexandretrotel/todo-tree";
	};

  # nixConfig.substituters = [];

	outputs = { self, nixpkgs, ... }@inputs: let
    system = "x86_64-linux";
    # TODO: find a way to make this be a full replacement of `nixpkgs.lib.nixosSystem`
    patched-nixpkgs = (import nixpkgs { inherit system; }).applyPatches {
      name = "patched-nixpkgs";
      src = nixpkgs;
      patches = [
        ./nixpkgs-patches/qt-6.patch
        ./nixpkgs-patches/kservice.patch
      ];
    };
  in {
    packages.x86_64-linux = {
      default = self.nixosConfigurations.builder-vm.config.microvm.declaredRunner;
    };

		nixosConfigurations.system = nixpkgs.lib.nixosSystem {
			modules = [
				./system/configuration.nix
        inputs.home-manager.nixosModules.home-manager
        inputs.catppuccin.nixosModules.catppuccin
        # inputs.nix-gc-env.nixosModules.default
        inputs.agenix.nixosModules.default
			];
			specialArgs = {
        inherit system;
        flake = self;
        inputs = inputs // { inherit patched-nixpkgs; };
      };
		};
	};
}
