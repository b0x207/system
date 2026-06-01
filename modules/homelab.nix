{...}: {
  flake.nixosModules.homelab = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      cloudflared
    ];

    # For building the homelab config
    boot.binfmt.emulatedSystems = ["aarch64-linux"];
  };
}
