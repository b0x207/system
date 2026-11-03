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
        defaultModel = "Flint";
        defaultProvider = "faesten";
        defaultThinkingLevel = "medium";
        enabledModels = [
          "Qwen 3.8 27B"
          "Flint"
        ];
        packages = [
          "npm:pi-ketch"
          "npm:@gotgenes/pi-permission-system"
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
            {
              id = "Flint";
              reasoning = true;
            }
          ];
        };
      };
    };

    home.file.".pi/agent/extensions/pi-permission-system/config.json".text = ''
      {
        "permission": {
          "*": "allow",
          "path": {
            "*": "allow",
            "*.env": "deny",
            "*.env.*": "deny",
            "*.env.example": "allow"
          },
          "bash": {
            "*": "ask",
            "rm -rf *": "deny",
            "sudo *": "ask"
          },
          "external_directory": "ask"
        }
      }
    '';
  };
}
