{ ... }: {
  flake.modules.darwin.music-server = { ... }: {
    homebrew.brews = [ "navidrome" ];
  };
}
