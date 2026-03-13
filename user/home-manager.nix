{ config, lib, inputs, pkgs, ... }:
{
  imports = [
    ./firefox.nix
  ];

  home.username = "ben";
  home.homeDirectory = "/home/ben";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

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

  programs.discord = {
    enable = true;
    settings.SKIP_HOST_UPDATE = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
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
  };

  xdg.configFile."git/allowed-signers" = {
    enable = true;
    force = true;
    text = "${config.programs.git.settings.user.email} " +
           "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDnyx15yATERx55O38TsVldST7u2eXX8fAsv15L6AhLE";
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

      if [[ ! -n $DISPLAY ]] && uwsm check may-start && uwsm select; then
        exec uwsm start default
      fi
    '';
    plugins = [
      {
        name = "pure";
        src = pkgs.fetchFromGitHub {
          owner = "sindresorhus";
          repo = "pure";
          rev  = "v1.27.1";
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
    flags = [ "--disable-up-arrow" ];
  };

  services.swaync = {
    enable = true;
  };

  catppuccin = {
    flavor = "mocha";
    ghostty.enable = true;
    swaync = { enable = true; font = "JetBrainsMono Nerd Font"; };
    kvantum.enable = true;
    rofi.enable = true;
    atuin.enable = true;
    # cursors = {
    #   enable = true;
    #   accent = "dark";
    # };
    fzf.enable = true;
    #gtk.icon.enable = true;
    zsh-syntax-highlighting.enable = true;
  };

  home.pointerCursor = {
    package = pkgs.kdePackages.breeze-icons;
    name = "breeze_cursors";
    size = 24;
    gtk.enable = true;
    hyprcursor = {
      enable = true;
      size = 24;
    };
    dotIcons.enable = true;
    x11.enable = true;
  };

  gtk = {
    colorScheme = "dark";
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    cursorTheme = {
      name = "catppuccin-mocha-dark-cursors";
      size = 18;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
    style.name = "kvantum";
  };

  programs.fastfetch = let
    color = "{#blue}";
    top =    "{#}┏━━━━━━━━━━┫${color}";
    side =   "{#}┃${color}";
    bottom = "{#}┗━━━━━━━━━━";
  in {
    enable = true;
    package = pkgs.callPackage ../packages/fastfetch/default.nix {};
    settings = {
      logo = {
        source = "nixos_medium";
        padding = {
          right = 3;
        };
      };
      display = {
        size = {
          binaryPrefix = "si";
        };
        color = "blue";
        # separator = "  ";
      };
      modules = [
        "break"
        {
          type = "title";
          format = "${top} {user-name}@{host-name}";
        }
        { type = "os"; key = "${side} OS"; }
        { type = "kernel"; key = "${side} Kernel"; }
        { type = "host"; key = "${side} Host"; }
        { type = "packages"; key = "${side} Packages"; }
        { type = "uptime"; key = "${side} Uptime"; }
        # { type = "bios"; key = "${side} BIOS Version"; }
        { type = "custom"; format = bottom; }

        "break"
        { type = "custom"; format = "${top} System Resources"; }
        { type = "cpu"; key = "${side} CPU"; }
        { type = "gpu"; key = "${side} GPU"; }
        {
          type = "memory";
          key = "${side} Memory";
          format = "{total}";
          percent = {
            green = 50;
            yellow = 70;
          };
        }
        {
          type = "battery";
          key = "${side} Battery";
          format = "{model-name} {technology} - {charge_full} mAh ({cycle-count} cycles)";
        }
        { type = "physicaldisk"; key = "${side} Physical Disk"; }
        { type = "custom"; format = bottom; }

        "break"
        { type = "custom"; format = "${top} Peripherals"; }
        {
          type = "display";
          key = "${side} Display";
          format = "{width}x{height} @ {refresh-rate} Hz {inch}\" [{type}] - {name}";
        }
        {
          type = "btrfs";
          key = "${side} Btrfs";
          percent = {
            green = 70;
            yellow = 85;
          };
        }
        {
          type = "disk";
          key = "${side} Disk ({mountpoint})";
          percent = {
            green = 70;
            yellow = 85;
          };
        }
        "poweradapter"
        { type = "custom"; format = bottom; }

        "break"
        { type = "custom"; format = "${top} Environment"; }
        { type = "wm"; key = "${side} Window Manager"; }
        # { type = "vulkan"; key = "${side} Vulkan"; }
        { type = "theme"; key = "${side} Theme"; }
        { type = "icons"; key = "${side} Icon Theme"; }
        { type = "cursor"; key = "${side} Cursor"; }
        { type = "font"; key = "${side} Font"; }
        { type = "custom"; format = bottom; }
      ];
    };
  };
}
