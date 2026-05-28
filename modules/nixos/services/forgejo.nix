{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.forgejo = {
    enable = true;

    settings = {
      server = {
        DOMAIN = "localhost";
        ROOT_URL = "http://localhost:8762/";
        HTTP_PORT = 8762;
      };
    };

    # good enough for my purposes
    database.type = "sqlite3";
  };

  networking.firewall.allowedTCPPorts = [
    8762
  ];
}
