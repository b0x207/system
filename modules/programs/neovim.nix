{ inputs, ... }: {
  flake.nixosModules.neovim = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      neovim

      # For various plugins
      tree-sitter
      ripgrep
    ];
  };

  flake.homeModules.neovim =
    { config, pkgs, ... }:
    let
      neovimPath = "${config.home.homeDirectory}/config/user/nvim";
    in
    {
      xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink neovimPath;

      home.packages = [
        pkgs.neovim
        pkgs.ripgrep
        pkgs.tree-sitter
      ];
    };
}
