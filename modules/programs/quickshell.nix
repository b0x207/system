{...}: {
  flake.nixosModules.quickshell = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      quickshell
    ];
  };

  flake.homeModules.quickshell = {config, ...}: let
    quickshellPath = "${config.home.homeDirectory}/config/user/quickshell";
  in {
    xdg.configFile."quickshell".source = config.lib.file.mkOutOfStoreSymlink quickshellPath;
  };
}
