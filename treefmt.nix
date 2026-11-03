{ pkgs, ... }: {
  projectRootFile = "flake.nix";
  settings.excludes = [
    "inputs/**"
  ];

  programs.nixfmt.enable = true;

  settings.formatter.nufmt = {
    command = "${pkgs.nufmt}/bin/nufmt";
    includes = [ "*.nu" ];
  };

  programs.qmlformat.enable = true;
  settings.formatter.qmlformat.options = [
    "--column-width"
    "100"
  ];
}
