{...}: {
  flake.nixosModules.intel-igpu = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      intel-gpu-tools
      level-zero
      intel-compute-runtime
      intel-gpu-tools
    ];

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        vpl-gpu-rt
        intel-compute-runtime
        ocl-icd
        level-zero
        intel-npu-driver
        intel-graphics-compiler
        intel-llvm
      ];
    };
  };
}
