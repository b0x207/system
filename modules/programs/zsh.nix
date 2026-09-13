{ ... }: {
  flake.homeModules.zsh = { pkgs, lib, ... }: {
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

        # alias pix="pinix --pix-command nix --pix-log-history 0 --pix-record /tmp/pix.log"

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
            rev = "v1.28.3";
            sha256 = "sha256-ZNi0ruTX9HRELXq1yvTm+StOuQ0UZgK6toMSgwqSD9A=";
          };
        }
      ];
    };
  };
}
