{
  config,
  pkgs,
  ...
}:
{
  services.harmonia = {
    cache = {
      enable = true;
      # NOTE: generate a public/private key pair with:
      #
      # $ nix-store \
      #     --generate-binary-cache-key remotebuilder.cache \
      #     /run/credstore/harmonia.secret \
      #     /run/credstore/harmonia.pub
      signKeyPaths = [ "/run/credstore/harmonia.secret" ];
    };

    # TODO: NixOS 26.11
    #gc = {
    #  enable = true;
    #};
  };

  services.prometheus = {
    enable = true;
    port = 9090;

    scrapeConfigs = [
      {
        job_name = "harmonia-remote-builder";
        scrape_interval = "15s";
        static_configs = [
          {
            targets = [ "127.0.0.1:5000" ];
          }
        ];
      }
    ];
  };

  # NOTE: harmonia offers a pre-configured grafana dashboard under:
  # https://github.com/nix-community/harmonia/blob/main/harmonia-cache/harmonia-grafana-dashboard.json
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 9191;
      };
      security = {
        secret_key = "$__file{/run/credstore/grafana.secret}";
      };
    };
    # configure Prometheus as a data source
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://127.0.0.1:9090";
          isDefault = true;
        }
      ];
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts."http://remotebuilder.cache" = {
      extraConfig = ''
        reverse_proxy http://127.0.0.1:5000
      '';
    };
    virtualHosts."http://remotebuilder.metrics" = {
      extraConfig = ''
        reverse_proxy http://127.0.0.1:9191
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [
    443
    80
  ];
}
