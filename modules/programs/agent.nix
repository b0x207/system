{ ... }: {
  flake.homeModules.agent = { pkgs, ... }: {
    programs.pi-coding-agent = {
      enable = true;
      extraPackages = with pkgs; [
        nodejs
        ketch
      ];

      settings = {
        compaction = {
          enabled = true;
          keepRecentTokens = 20000;
          reserveTokens = 16384;
        };
        defaultModel = "Qwen 3.8 27B";
        defaultProvider = "faesten";
        defaultThinkingLevel = "medium";
        enabledModels = [
          "Qwen 3.8 27B"
        ];
        packages = [
          "npm:pi-ketch"
        ];
        retry = {
          enabled = true;
          maxRetries = 3;
        };
        theme = "dark";
      };

      models.providers = {
        "faesten" = {
          api = "openai-completions";
          baseUrl = "http://faesten:8081/v1";

          models = [
            {
              id = "Qwen 3.8 27B";
              reasoning = true;
            }
          ];
        };
      };
    };
  };
}
