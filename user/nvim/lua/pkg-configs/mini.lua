require("mini.pick").setup({
    mappings = {
        move_down = "<C-j>",
        move_up = "<C-k>",
    },

    options = {
        use_cache = true
    },

    window = {
        config = function()
            local height = math.floor(0.8 * vim.opt.lines:get())
            local width = math.floor(0.9 * vim.opt.columns:get())

            return {
                anchor = "NW",
                height = height,
                width = width,
                row = math.floor(0.5 * (vim.opt.lines:get() - height)),
                col = math.floor(0.5 * (vim.opt.columns:get() - width))
            }
        end
    }
})

require("mini.extra").setup()
