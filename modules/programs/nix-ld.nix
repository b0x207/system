{...}: {
  flake.nixosModules.nix-ld = {pkgs, ...}: {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libxcrypt
        libGL
        ocl-icd
        level-zero
        intel-compute-runtime

        # For Minecraft
        # TODO: split into separate module?
        libxrender
        libxtst
        libxi
        vulkan-loader
        libglvnd
      ];
    };
  };
}
