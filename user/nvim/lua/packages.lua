vim.pack.add({
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin-nvim" },
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/lukas-reineke/indent-blankline.nvim",
    "https://github.com/nvim-mini/mini.pick",
    "https://github.com/nvim-mini/mini.extra",
    -- "https://github.com/wakatime/vim-wakatime",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    "https://github.com/rebelot/terminal.nvim",
    "https://github.com/Bekaboo/deadcolumn.nvim",
    "https://github.com/folke/lazydev.nvim",
    "https://github.com/j-hui/fidget.nvim",

    -- LSP
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",

    -- Completions
    {
        src = "https://github.com/saghen/blink.cmp",
        version = "v1.8.0",
        data = { build = { "cargo", "build", "-r" } }
    },

    -- Dependencies
    "https://github.com/nvim-tree/nvim-web-devicons", -- which-key.nvim, mini.pick

    "https://github.com/RaafatTurki/hex.nvim",
    { src = "https://github.com/chomosuke/typst-preview.nvim", version = "v1.4.1" },
    "https://github.com/jinh0/eyeliner.nvim",
    "https://github.com/sphamba/smear-cursor.nvim",
})

require("catppuccin").setup({
    transparent_background = true
})

vim.cmd("colorscheme catppuccin-mocha")

require("pkg-configs")
