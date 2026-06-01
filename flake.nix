{
  description = "System config flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";

    catppuccin = {
      url = "github:catppuccin/nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utpm.url = "github:typst-community/utpm";
    typst = {
      # TRACK: https://github.com/typst/typst-flake/pull/11
      url = "github:typst/typst-flake?ref=refs/pull/11/head";
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

    todo-tree.url = "github:alexandretrotel/todo-tree";
  };

  outputs = base-inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }: let
    system = "x86_64-linux";

    # TODO: find a way to make this work without IFD
    patched-nixpkgs = import ./patched-nixpkgs.nix {inherit system nixpkgs;};

    inputs =
      base-inputs
      // {
        nixpkgs = patched-nixpkgs;
        base-nixpkgs = nixpkgs;
      };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        (inputs.import-tree ./modules)
      ];

      flake = {
        formatter.${system} = let
          pkgs = import patched-nixpkgs {inherit system;};
        in
          pkgs.alejandra;
      };
    };
  /*
    imports = [
      inputs.flake-parts.flakeModules.modules
      ./modules/ladybird.nix
    ];

    flake = {
      nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          ./system/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          inputs.catppuccin.nixosModules.catppuccin
          inputs.agenix.nixosModules.default
          inputs.stylix.nixosModules.stylix
        ];
        specialArgs = {
          inherit system inputs patched-nixpkgs;
          flake = self;
        };
      };

      formatter.${system} = patched-nixpkgs.legacyPackages.${system}.alejandra;
    };
    systems = [ "x86_64-linux" ];
  });
  */
}
