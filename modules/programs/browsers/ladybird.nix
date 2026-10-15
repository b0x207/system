{ ... }: {
  flake.nixosModules.ladybird = { ... }: {
    programs.ladybird.enable = true;
  };
}
