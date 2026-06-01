{...}: {
  flake.nixosModules.dictionary = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      (hunspell.withDicts (dicts: with dicts; [en-us]))
      (aspellWithDicts (
        dicts:
          with dicts; [
            en
            en-computers
            en-science
          ]
      ))
    ];
  };
}
