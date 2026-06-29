{
  config,
  pkgs,
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

  systemd.services.firefly-iii-backup = {
    description = "Firefly III backup";

    serviceConfig = {
      Type = "oneshot";
    };

    unitConfig =
      let
        services = [
          "phpfpm-firefly-iii.service"
        ]
        ++ lib.optional cfgImporter.enable "phpfpm-firefly-iii-data-importer.service";
      in
      {
        # Shut down the firefly-iii services while the backup runs
        Conflicts = services;
        After = services;
        # Bring them back up afterwards, regardless of pass/fail
        OnSuccess = services;
        OnFailure = services;
      };

    script = ''
      set -euo pipefail

      backupDir="${cfg.dataDir}/backup"
      timestamp=$(date +%Y%m%d-%H%M%S)

      mkdir -p "$backupDir"

      ${lib.getBin pkgs.sqlite}/bin/sqlite3 \
        "${cfg.dataDir}/storage/database/database.sqlite" \
        ".backup '$backupDir/firefly-iii-database-$timestamp.sqlite'"

      ${lib.optionalString cfgImporter.enable ''
        ${lib.getBin pkgs.gnutar}/bin/tar \
          -c \
          -I ${lib.getBin pkgs.gzip}/bin/gzip \
          -f "$backupDir/firefly-iii-data-importer-$timestamp.tar.gz" \
          -C "${cfgImporter.dataDir}/storage" \
          configurations import-jobs
      ''}

      ${lib.getBin pkgs.fd}/bin/fd \
        -g "firefly-iii-*" \
        "$backupDir" \
        --changed-before '30d' \
        -X rm

      ${lib.getBin pkgs.coreutils}/bin/chown -R "${cfg.user}:${cfg.group}" "$backupDir"
      ${lib.getBin pkgs.coreutils}/bin/chmod 0700 "$backupDir"
    '';

    startAt = "daily";
  };
}
