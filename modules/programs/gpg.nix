{...}: {
  flake.nixosModules.gpg = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      gnupg
      pinentry-tty
    ];

    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-tty;
    };
  };
}
