{
	description = "System config flake";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
		neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    hyprland.url = "github:HyprWM/Hyprland";
    hyprshutdown.url = "github:hyprwm/hyprshutdown";
	};

  nixConfig = {
    # substituters = [];
  };

	outputs = { self, nixpkgs, ... }@inputs: {
		nixosConfigurations.system = nixpkgs.lib.nixosSystem {
			modules = [
				./configuration.nix
			];
			specialArgs = { inherit inputs; };
		};
	};
}
