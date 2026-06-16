{inputs, ...}: {
  flake.nixosModules.tmux = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      tmux
    ];
  };

  flake.homeModules.tmux = { config, pkgs, ... }: {
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

      extraConfig = ''
        set-option -g renumber-windows on
        set-window-option -g mode-keys vi

        # QOL Keybinds
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        bind-key -n S-Left previous-window
        bind-key -n S-Right next-window
      '';
    };

    catppuccin.tmux = {
      enable = true;
      extraConfig = ''
        set -g @catppuccin_window_status_style "rounded"

        set -g status-left ""
        set -g status-right "#{E:@catppuccin_status_application}"
        set -ag status-right "#{E:@catppuccin_status_session}"
      '';
    };
  };
}
