require("blink.cmp").setup({
    keymap = {
        preset = "none",

        ["<Down>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ['<C-i>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-y>'] = { 'select_and_accept' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ["<Tab>"] = { 'fallback' },
        ["<Shift-Tab>"] = { 'fallback' },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
        },
        ghost_text = {
            enabled = true,
            show_with_menu = true
        },
    },
    signature = {
        enabled = true,
        window = {
            show_documentation = true
        }
    }
})
