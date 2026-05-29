{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./firefox.nix
    ./fastfetch.nix
    ../modules/theme/home-manager.nix
  ];

  home.username = "ben";
  home.homeDirectory = "/home/ben";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  stylix.targets = {
    # I spent way too long on this, DON'T TOUCH IT
    firefox.enable = false;

    mpv.enable = true;

    # kde = {
    #   enable = true;
    #   applicationStyle = "BreezeDark";
    #   widgetStyle = "BreezeDark";
    # };

    # gtk.enable = true;
    # qt = {
    #   enable = true;
    #   # platform = "kvantum";
    #   standardDialogs = "xdgdesktopportal";
    # };
    # kde = {
    #   enable = true;
    #   widgetStyle = "BreezeDark";
    #   applicationStyle = "BreezeDark";
    # };
    fontconfig.enable = true;
  };
  programs.btop = {
    enable = true;
    settings = {
      disks_filter = "/boot /";
    };
  };

  programs.mpv.enable = true;

  # home.file.".config/nvim" = {
  #   source = ./nvim;
  #   target = ".config/nvim";
  # };

  programs.zathura = {
    enable = true;
    extraConfig = ''
      # For some reason, default-bg must be specified using HTML notation
      set default-bg "#000000ff"
      set default-fg "#ff0000"

      #set scroll-page-aware true
      set adjust-open width

      set recolor true
      set recolor-darkcolor "#ffffff"
      set recolor-lightcolor rgba(0,0,0,0.9)
      set recolor-keephue true

      # Keep original image colors
      set recolor-reverse-video true

      set database "sqlite"

      # Show a vertical scrollbar
      set guioptions 'v'

      set selection-clipboard clipboard
    '';
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        addKeysToAgent = "yes";
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
      };
      "*.b0x207.dev" = {
        proxyCommand = "cloudflared access ssh --hostname %h";
      };
      "*.intercraft.nexus" = {
        proxyCommand = "cloudflared access ssh --hostname %h";
      };
      "openlab.ics.uci.edu" = {
        identityFile = "~/.ssh/id_uci";
        identitiesOnly = true;
        controlMaster = "auto";
        controlPath = "~/.ssh/%r@%h-%p";
        controlPersist = "10m";
        forwardAgent = true;
      };
      "archimedes-8.ics.uci.edu" = {
        port = 10010;
      };
    };
  };

  services.ssh-agent = {
    enable = true;
    defaultMaximumIdentityLifetime = 3600;
  };

  programs.discord = {
    enable = true;
    settings.SKIP_HOST_UPDATE = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      warn_timeout = 0;
    };
  };

  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      auto-update = "off";
      background-opacity = 0.9;
      link-previews = "osc8";
      clipboard-read = "allow";
      clipboard-write = "allow";
      gtk-single-instance = false;
      shell-integration-features = "ssh-terminfo,ssh-env,sudo";
      font-family = "JetBrainsMono Nerd Font Mono";
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "Ben Landon";
        email = "landb0x207@gmail.com";
      };
      init.defaultBranch = "main";
      gpg.ssh.allowedSignersFile = "~/.config/git/allowed-signers";
    };
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519";
      signByDefault = true;
    };
    includes = [
      {
        condition = "gitdir:~/school/";
        contents = {
          user.email = "blandon1@uci.edu";
        };
      }
    ];
  };

  xdg.configFile."git/allowed-signers" = {
    enable = true;
    force = true;
    text =
      "${config.programs.git.settings.user.email} "
      + "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDnyx15yATERx55O38TsVldST7u2eXX8fAsv15L6AhLE";
  };

  home.shell.enableZshIntegration = true;
  programs.zsh = {
    enable = true;
    enableVteIntegration = true;
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting.enable = true;
    initContent = lib.mkOrder 1000 ''
      export EDITOR=nvim

      # Because wth ZSH???
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey \^U backward-kill-line

      #if [[ ! -n $DISPLAY ]] && uwsm check may-start && uwsm select; then
      #  exec uwsm start default
      #fi
    '';
    plugins = [
      {
        name = "pure";
        src = pkgs.fetchFromGitHub {
          owner = "sindresorhus";
          repo = "pure";
          rev = "v1.27.1";
          sha256 = "sha256-Fhk4nlVPS09oh0coLsBnjrKncQGE6cUEynzDO2Skiq8=";
        };
      }
    ];
  };

  programs.fzf.enable = true;

  programs.atuin = {
    enable = true;
    daemon.enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    flags = ["--disable-up-arrow"];
  };

  services.swaync = {
    enable = true;
  };

  catppuccin = {
    flavor = "mocha";
    ghostty.enable = true;
    swaync = {
      enable = true;
      font = "JetBrainsMono Nerd Font";
    };
    # kvantum.enable = true;
    rofi.enable = true;
    atuin.enable = true;
    # cursors = {
    #   enable = true;
    #   accent = "dark";
    # };
    gtk.icon.enable = true;
    fzf.enable = true;
    zsh-syntax-highlighting.enable = true;
  };

  home.pointerCursor = {
    package = pkgs.kdePackages.breeze-icons;
    name = "breeze_cursors";
    size = 12;
    gtk.enable = true;
    hyprcursor = {
      enable = true;
      size = 12;
    };
    dotIcons.enable = true;
    x11.enable = true;
  };

  /*
  gtk = {
    colorScheme = "dark";
    iconTheme = {
      package = pkgs.kdePackages.breeze-icons;
      name = "breeze-dark";
    };
    cursorTheme = {
      name = "catppuccin-mocha-dark-cursors";
      size = 12;
    };
    # theme = {
    #   name = "Breeze-Dark";
    #   package = pkgs.kdePackages.breeze-gtk;
    # };
    # theme = {
    #   name = "Adwaita-dark";
    #   package = pkgs.gnome-themes-extra;
    # };
    # theme = {
    #   name = "adw-gtk3-dark";
    #   package = pkgs.adw-gtk3;
    # };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  */

  # qt = {
  #   enable = true;
  #   platformTheme.name = "qtct";
  #   style = {
  #     name = "Breeze-Dark";
  #     package = pkgs.kdePackages.breeze;
  #   };
  #   qt6ctSettings = {
  #     Appearance = {
  #       icon_theme = "breeze-dark";
  #       standard_dialogs = "default";
  #       style = "Breeze";
  #     };
  #     Fonts = {
  #       fixed = "\"JetBrainsMono Nerd Font Mono,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular,0,0\"";
  #       general = "\"DejaVu Sans,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Book,0,0\"";
  #     };
  #   };
  #   # kvantum = {
  #   #   enable = true;
  #   # };
  #   # style.name = "kvantum";
  #   # style.package = pkgs.kdePackages.qtstyleplugin-kvantum;
  # };
}
