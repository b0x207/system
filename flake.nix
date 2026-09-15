{
  description = "System config flake";
  inputs = {
    # Core inputs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";

    # ~~~ NIXPKGS PATCHES HERE ~~~
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake fundamentals
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";

    # Everything else
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

    todo-tree.url = "github:alexandretrotel/todo-tree";

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs@{
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        (inputs.import-tree ./modules)
        inputs.home-manager.flakeModules.home-manager
        inputs.git-hooks-nix.flakeModule
      ];

      # Is this kinda dumb? Yeah.
      systems = [ "x86_64-linux" ];

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
    };
}
