{inputs, ...}: {
  flake.nixosModules.dev-tools = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      rustup
      gh
      inputs.todo-tree.packages.${pkgs.stdenv.hostPlatform.system}.todo-tree
      jq
    ];
  };
}
