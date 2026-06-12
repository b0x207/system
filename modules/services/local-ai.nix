# One must try things to have an informed opinion
{...}: {
  flake.nixosModules.local-ai = {pkgs, genericPkgs, ...}: {
    environment.systemPackages = with pkgs; [
      uv
      nodejs
    ];

    services.open-webui = {
      enable = true;
      port = 9090;
      host = "127.0.0.1";
      environment = {
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";

        ENABLE_OPENAI_API = "True";
        OPENAI_API_BASE_URL = "http://localhost:10000";
        OPENAI_API_KEY = "";

        WEBUI_AUTH = "False";

        ENABLE_RAG_WEB_SEARCH = "True";
        RAG_WEB_SEARCH_ENGINE = "searxng";
        RAG_WEB_SEARCH_RESULT_COUNT = "3";
        RAG_WEB_SEARCH_CONCURRENT_REQUESTS = "10";
        SEARXNG_QUERY_URL = "http://localhost:9091/search?q=<query>";
      };
    };

    services.searx = {
      enable = true;
      settings = {
        server.port = 9091;
        server.secret_key = "oogabooga";
        search.formats = [
          "html"
          "json"
        ];
      };
      limiterSettings = {
        botdetection.ip_lists = {
          block_ip = [];
          pass_ip = [];
        };
        botdetection.ip_limit.link_token = false;
      };
    };
  };
}
