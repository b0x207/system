{ ... }: {
  flake.homeModules.fzf = { ... }: {
    programs.fzf = {
      enable = true;
      historyWidget.command = "";
    };
  };
}
