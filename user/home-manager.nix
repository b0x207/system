{ config, lib, inputs, pkgs, ... }:
{
  home.username = "ben";
  home.homeDirectory = "/home/ben";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  programs.vesktop = {
    enable = true;
  };
  programs.discord = {
    enable = true;
    settings.SKIP_HOST_UPDATE = true;
  };

  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      background-opacity = 0.9;
      link-url = false;
      # link-preview = false; # wait for newer ghostty version
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
    '';
    plugins = [
      {
        name = "pure";
        src = pkgs.fetchFromGitHub {
          owner = "sindresorhus";
          repo = "pure";
          rev  = "v1.26.0";
          sha256 = "1bxg5i3a0dm5ifj67ari684p89bcr1kjjh6d5gm46yxyiz9f5qla";
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
    qt5ct.enable = true;
    rofi.enable = true;
    atuin.enable = true;
    cursors = {
      enable = true;
      accent = "dark";
    };
    fzf.enable = true;
    #gtk.icon.enable = true;
    zsh-syntax-highlighting.enable = true;
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
}
