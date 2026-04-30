{
	description = "System config flake";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:HyprWM/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprshutdown = {
      url = "github:hyprwm/hyprshutdown";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

    pkgs = import nixpkgs { inherit system; };
    patched-nixpkgs-src = pkgs.stdenv.mkDerivation (let
      patches = [
        ./nixpkgs-patches/llvm.patch
        ./nixpkgs-patches/arrow-cpp.patch
        ./nixpkgs-patches/aiocache.patch
        (pkgs.fetchpatch2 {
          url = "https://github.com/NixOS/nixpkgs/pull/503903.patch";
          hash = "sha256-fgf0/qJMwi6BOV/DfLDjTCk3KGqCQzcmwnptlx3mPo8=";
        })
      ];
    in {
      pname = "patched-nixpkgs";
      version = "${nixpkgs.shortRev}-patched";
      src = nixpkgs.sourceInfo.outPath;

      nativeBuildInputs = [ pkgs.git ];

      phases = [ "unpackPhase" "buildPhase" "installPhase" ];

      buildPhase = ''
      git apply --verbose ${pkgs.lib.concatStringsSep " " patches}
      '';

      installPhase = ''
      cp -r . $out
      '';
    });

    # Yes, this is IFD but since it happens so early in the evaluation phase, it should have a
    # mostly negligible impact on build times
    patched-nixpkgs = let
      # This is some pretty hacky stuff...
      # Since `builtins.getFlake` won't allow passing store paths as inputs, the only solution is
      # to resort to trickery. Here, we add in the bare minimum required attributes to pretend that
      # this is an actual flake input.
      flake = (import "${patched-nixpkgs-src}/flake.nix") // {
        outPath = "${patched-nixpkgs-src}";
      };
    in
      flake.outputs { self = flake; };
  in {
    foo = patched-nixpkgs;
		nixosConfigurations.system = patched-nixpkgs.lib.nixosSystem {
			modules = [
				./system/configuration.nix
        inputs.home-manager.nixosModules.home-manager
        inputs.catppuccin.nixosModules.catppuccin
        inputs.agenix.nixosModules.default
			];
			specialArgs = {
        inherit system inputs;
        flake = self;
      };
		};
	};
}
