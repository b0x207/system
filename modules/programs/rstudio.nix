{ ... }: {
  flake.homeModules.rstudio = { pkgs, ... }: {
    home.packages = with pkgs; [
      R
      rPackages.rmarkdown
      rstudio
    ];
  };
}
