hl.env("HYPRCURSOR_THEME", "breeze_cursors")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_SIZE", "24")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("NIXOS_OZONE_WL", "1")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GDK_BACKEND", "wayland")

-- QT
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- hl.env("QT_QPA_PLATFORM", "wayland;xcb")

-- TODO: move this to home manager config
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
-- hl.env("QT_STYLE_OVERRIDE", "kvantum")
