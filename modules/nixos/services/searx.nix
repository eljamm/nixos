{
  config,
  pkgsUnstable,
  ...
}:
{
  services.searx = {
    enable = true;
    openFirewall = true;

    package = pkgsUnstable.searxng;

    settings = {
      server.port = 51351;
      server.secret_key = "$SEARX_SECRET_KEY";

      search = {
        autocomplete = "google";
        favicon_resolver = "google";
        default_lang = "auto";
        formats = [
          "json"
          "html"
        ];
      };

      engines = [
        {
          name = "nixos discourse";
          engine = "discourse";
          shortcut = "nixd";
          base_url = "https://discourse.nixos.org/";
          show_avatar = true;
          categories = [
            "it"
            "software forums"
            "nix"
          ];
        }
      ];
    };

    environmentFile = "/run/keys/searx-secrets.txt";
  };

  services.caddy = {
    enable = true;
    virtualHosts."http://searx.remotebuilder" = {
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString config.services.searx.settings.server.port}
      '';
    };
  };

  systemd.services.searxng = {
    environment = {
      SSL_CERT_FILE = "${pkgsUnstable.cacert}/etc/ssl/certs/ca-bundle.crt";
    };
  };
}
