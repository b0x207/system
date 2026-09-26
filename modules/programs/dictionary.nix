{ ... }: {
  flake.nixosModules.dictionary = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      (hunspell.withDicts (dicts: with dicts; [ en-us ]))
      (aspellWithDicts (
        dicts: with dicts; [
          en

          # TRACK: Disable due to a problem in upstream
          # en-computers

          en-science
        ]
      ))
    ];
  };
}
