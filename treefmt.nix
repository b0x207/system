{pkgs, ...}: {
  projectRootFile = "flake.nix";

  programs.alejandra.enable = true;

  settings.formatter.nufmt = {
    command = "${pkgs.nufmt}/bin/nufmt";
    includes = ["*.nu"];
  };
}
