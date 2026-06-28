{
  config,
  lib,
  ...
}:

let
  cfg = config.services.firefly-iii;
  cfgImporter = config.services.firefly-iii-data-importer;
in

{
  services.firefly-iii = {
    enable = true;
    enableNginx = true;

    virtualHost = "firefly.localhost";

    settings = {
      APP_KEY_FILE = lib.toFile "firefly-iii-appkey" "_SheSellsSeaShellsOnTheSeaChore_";
      APP_URL = "http://firefly.localhost:28982";
    };
  };

  services.firefly-iii-data-importer = {
    enable = true;
    enableNginx = true;

    virtualHost = "firefly-importer.localhost";

    settings = {
      FIREFLY_III_URL = cfg.settings.APP_URL;
      FIREFLY_III_ACCESS_TOKEN_FILE = "/etc/firefly-token";
    };
  };

  services.nginx = {
    enable = true;

    virtualHosts.${cfg.virtualHost} = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 28982;
        }
      ];
    };

    virtualHosts.${cfgImporter.virtualHost} = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 28983;
        }
      ];
    };
  };

  networking.hosts = {
    "127.0.0.1" = [
      cfg.virtualHost
      cfgImporter.virtualHost
    ];
  };
}
