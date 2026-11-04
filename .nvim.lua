vim.lsp.config("nixd", {
    cmd = { "nixd" },
    filetypes = { "nix" },
    root_markers = { "flake.nix", ".git" },
    settings = {
        nixd = {
            nixpkgs = {
                expr = "import <nixpkgs> { }",
            },
            formatting = {
                command = { "nixfmt" },
            },
            options = {
                nixos = {
                    expr = '(builtins.getFlake (toString ./.)).nixosConfigurations.<hostname>.options',
                },
                home_manager = {
                    expr = '(builtins.getFlake (toString ./.)).homeConfigurations.<hostname>.options',
                },
            },
        },
    },
})
