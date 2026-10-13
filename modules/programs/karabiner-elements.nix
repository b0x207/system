{ ... }: {
  flake.modules.darwin.karabiner-elements = { ... }: {
    homebrew.casks = [ "karabiner-elements" ];
  };
}
