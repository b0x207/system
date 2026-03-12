{ pkgs, ... }:
pkgs.firefox-unwrapped.overrideAttrs (old: {
  patches = (old.patches or []) ++ [ ./newtab.patch ];
  # extraNativeBuildInputs = (old.extraNativeBuildInputs or []) ++ [ pkgs.mold ];

  # Compiling Firefox can be pretty memory intensive.
  # Force no parallelism to attempt to mitigate OOM problems.
  #NIX_BUILD_CORES = 1;

  # Why would debug mode be enabled? I'm not sure, but disable it just in case.
  debugBuild = false;
})
