{ self, ... }: {
  flake.nixosModules.tmux = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      tmux
    ];
  };

  flake.homeModules.tmux = { pkgs, ... }: {
    programs.tmux = {
      enable = true;

      baseIndex = 1;
      clock24 = true;
      focusEvents = true;
      terminal = "xterm-ghostty";
      historyLimit = 100000;
      keyMode = "vi";
      mouse = true;
      sensibleOnTop = true;

      plugins = with pkgs; [
        tmuxPlugins.sensible
        tmuxPlugins.yank
      ];

      extraConfig =
        let
          session = "#${self.themes.gruvbox.dark.aqua}";
          dark = "#${self.themes.gruvbox.dark.bg}";
          active = "#${self.themes.gruvbox.dark.muted-orange}";
          inactive = "#${self.themes.gruvbox.dark.muted-gray}";
        in
        ''
          set-option -g renumber-windows on
          set-window-option -g mode-keys vi

          set-option -g allow-passthrough on
          set -g extended-keys on
          set -g extended-keys-format csi-u

          # QOL Keybinds
          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
          bind-key -n S-Left previous-window
          bind-key -n S-Right next-window

          # Make the bar look pretty
          set -g status-style bg=default

          set -g status-left "\
          #[fg=${session}]#[bg=${session},fg=${dark}]\
          #{session_name}\
          #[bg=default,fg=${session}]#[fg=default] "

          set -g status-right "\
          #[fg=${session}]#[bg=${session},fg=${dark}]\
          #{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,}\"#{=21:pane_title}\" %H:%M\
          #[bg=default,fg=${session}]#[fg=default]"

          set -g window-status-current-format "\
          #[fg=${active}]#[bg=${active},fg=${dark}]\
          #I #W\
          #[bg=default,fg=${active}]#[fg=default] "

          set -g window-status-format "\
          #[fg=${inactive}]#[bg=${inactive},fg=${dark}]\
          #I #W\
          #[bg=default,fg=${inactive}]#[fg=default] "

          set -g window-status-separator ""

          # Since commit f59921ce184d27b4f11c62a4914bc2a8441b4667, the default is to underline but
          # the custom fg and bg colors break with underline
          set -g window-status-current-style ""
        '';
    };
  };
}
