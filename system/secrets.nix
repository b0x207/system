{
  inputs,
  pkgs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  environment.systemPackages = [inputs.agenix.packages.${system}.default];

  age.identityPaths = ["/home/ben/.ssh/id_ed25519"];
  age.secrets.openconnect.file = ../secrets/openconnect.age;
}
