{
  description = "System config flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";

    hyprland = {
      url = "github:HyprWM/Hyprland";
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

    # TODO: See if the newer build can be fixed
    todo-tree.url = "github:alexandretrotel/todo-tree/b46a07f6a8f0c8a2d3c0b70792cb819f82cb2c1a";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    tether.url = "github:zackb/tether";
  };

  outputs =
    base-inputs@{
      nixpkgs,
      flake-parts,
      ...
    }:
    let
      system = "x86_64-linux";

      # TODO: find a way to make this work without IFD
      patched-nixpkgs = import ./patched-nixpkgs.nix { inherit system nixpkgs; };

      inputs = base-inputs // {
        nixpkgs = patched-nixpkgs;
        base-nixpkgs = nixpkgs;
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        (inputs.import-tree ./modules)
        inputs.flake-parts.flakeModules.modules
        inputs.home-manager.flakeModules.home-manager
        inputs.git-hooks-nix.flakeModule
        # (inputs.tether.nixosModules.default (import inputs.nixpkgs { inherit system; }))
      ];

      # Is this kinda dumb? Yeah.
      systems = [
        system
        "aarch64-darwin"
      ];

      perSystem =
        {
          config,
          pkgs,
          ...
        }:
        let
          treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        in
        {
          formatter = treefmtEval.config.build.wrapper;

          packages.pre-commit = config.pre-commit.settings.package;

          devShells.default = pkgs.mkShell {
            packages = [
              config.packages.pre-commit
            ];

            shellHook = "${config.pre-commit.installationScript} ";
          };

          pre-commit = {
            check.enable = true;
            settings = {
              enable = true;
              hooks = {
                deadnix.enable = true;
                shellcheck = {
                  enable = true;
                  excludes = [ ".envrc" ];
                };

                treefmt-nix = {
                  enable = true;
                  name = "treefmt-nix";
                  description = "treefmt-nix";
                  files = "";
                  entry = "${pkgs.lib.getExe config.formatter}";
                };
              };
            };
          };
        };

      flake = {
        formatter.${system} =
          let
            pkgs = import patched-nixpkgs { inherit system; };
            treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
          in
          treefmtEval.config.build.wrapper;
      };
    };
}
