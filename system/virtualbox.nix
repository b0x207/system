{ ... }: {
  # Note: for some reason, VirtualBox acts really weird and can't find the correct kernel modules
  # when the `virtualbox` package is added to `environment.systemPackages`.
  virtualisation.virtualbox = {
    host.enable = true;
    guest = {
      clipboard = true;
      dragAndDrop = true;
    };
  };
  users.extraGroups.vboxusers.members = [ "ben" ];
}
