{...}: {
  flake.nixosModules.browser = {pkgs, ...}: {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-bin;
      languagePacks = ["en-US"];
    };

    programs.ladybird.enable = true;

    environment.systemPackages = with pkgs; [
      librewolf
      tor-browser
    ];
  };
}
