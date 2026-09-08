{ pkgs, ... }: {
  projectRootFile = "flake.nix";

  programs.nixfmt.enable = true;

  settings.formatter.nufmt = {
    command = "${pkgs.nufmt}/bin/nufmt";
    includes = [ "*.nu" ];
  };
}
