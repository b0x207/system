hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 0,
        border_size = 1,
        layout = "dwindle",
        resize_on_border = true,
    },

    decoration = {
        rounding = 0,
        shadow = {
            enabled = false,
        },
        blur = {
            enabled = false,
        },
    },

    animations = {
        enabled = true,
    },

    input = {
        kb_layout = "us",
        follow_mouse = 1,

        touchpad = {
            -- Disabled because it causes issues when playing games on trackpad
            -- drag_lock = 1,
        },
    },

    group = {
        groupbar = {
            render_titles = false,
            indicator_height = 10,
            gaps_in = 2,
            gaps_out = 0,
            keep_upper_gap = false,
            rounding = 0,
            scrolling = false,
        },
    },

    dwindle = {
        preserve_split = true,

        -- This is the correct behavior enough that when it isn't, the extra keystrokes to fix it
        -- is just fine.
        force_split = 2,
    },

    scrolling = {
        -- fullscreen_on_one_column = true,
        column_width = 0.99,
    },

    misc = {
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
        vrr = 2,
    },

    ecosystem = {
        no_update_news = true,
    },

    debug = {
        disable_logs = false
    }
})
