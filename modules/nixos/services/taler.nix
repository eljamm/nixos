{ lib, pkgs, ... }:
{
  # services.postgresql = {
  #   enable = true;
  #   enableTCPIP = true;
  #   ensureDatabases = [
  #     "kuroko"
  #     "taler-exchange"
  #     "taler-mailbox"
  #     "anastasis"
  #     "anastasischeck"
  #     "talercheck"
  #   ];
  #   ensureUsers = [
  #     {
  #       name = "kuroko";
  #       ensureDBOwnership = true;
  #     }
  #     {
  #       name = "taler-mailbox";
  #       ensureDBOwnership = true;
  #     }
  #   ];
  #   initialScript =
  #     pkgs.writeText "backend-initScript" # sql
  #       ''
  #         CREATE ROLE kuroko
  #         WITH
  #           LOGIN PASSWORD 'secret' CREATEDB;
  #
  #         GRANT ALL PRIVILEGES ON DATABASE taler - mailbox TO kuroko;
  #
  #         GRANT ALL PRIVILEGES ON DATABASE taler - mailbox TO taler - mailbox;
  #
  #         GRANT ALL PRIVILEGES ON DATABASE taler - exchange TO kuroko;
  #       '';
  #   authentication = ''
  #     #type database  DBuser  auth-method
  #     local      all       all       trust
  #     hostnossl  all       all   0.0.0.0/0     trust
  #     host       all       all   0.0.0.0/0     trust
  #   '';
  # };

  # systemd.user.services = lib.mergeAttrsList [
  #   (lib.genAttrs
  #     [
  #       "taler-exchange-aggregator"
  #       "taler-exchange-closer"
  #       "taler-exchange-httpd"
  #       "taler-exchange-secmod-cs"
  #       "taler-exchange-secmod-eddsa"
  #       "taler-exchange-secmod-rsa"
  #       "taler-exchange-transfer"
  #       "taler-exchange-wirewatch"
  #     ]
  #     (name: {
  #       enable = true;
  #       after = [ "network.target" ];
  #       wantedBy = [ "default.target" ];
  #       description = "";
  #       serviceConfig = {
  #         Type = "simple";
  #         ExecStart = ''${lib.getBin pkgs.taler-exchange}/bin/${name} -L debug'';
  #       };
  #     })
  #   )
  # ];

  services.taler = {
    enable = false;
    exchange = {
      enable = true;
      debug = true;
      denominationConfig = lib.readFile ./taler-denominations.conf;
    };
  };

}
