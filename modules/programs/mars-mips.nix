{...}: {
  flake.nixosModules.mars-mips = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      (mars-mips.overrideAttrs {
        jre = javaPackages.compiler.openjdk11;
      })
    ];
  };
}
