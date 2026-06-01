{inputs, ...}: {
  flake.nixosModules.neovim = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      neovim

      # For various plugins
      tree-sitter
      ripgrep
    ];
  };
}
