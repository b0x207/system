{ ... }: {
  flake.nixosModules.docker = {
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
    };

    users.users.ben.extraGroups = [ "docker" ];
  };
}
