require("which-key").setup({
    preset = "modern",

    win = {
        -- This prevents the popup from scrolling the terminal which makes selecting text hard
        no_overlap = false
    }
})
