{ lib, pkgs, ... }:
{
  services.taler =
    let
      hostname = "192.168.1.120";
      currency = "KUDOS";
    in
    {
      enable = true;
      settings = {
        taler = {
          CURRENCY = currency;
        };
        exchange = {
          BASE_URL = "http://${hostname}:8081/";
          HOSTNAME = hostname;
          PORT = 8081;
          MASTER_PUBLIC_KEY = "6D304A6WMPMX1NYRJS32E0CXEMDJMXKQZP7KG8VMK31DB074BVX0";
        };
        libeufin-bank = {
          BIND_TO = hostname;
          PORT = 8082;
          SUGGESTED_WITHDRAWAL_EXCHANGE = "http://${hostname}:8081";
          WIRE_TYPE = "iban";
          IBAN_PAYTO_BIC = "SANDBOXX";
          DEFAULT_CUSTOMER_DEBT_LIMIT = "${currency}:200";
          DEFAULT_ADMIN_DEBT_LIMIT = "${currency}:2000";
          ALLOW_REGISTRATION = "yes";
          REGISTRATION_BONUS_ENABLED = "yes";
          REGISTRATION_BONUS = "${currency}:100";
        };
      };
      includes = [ ./taler-accounts.conf ];
      exchange = {
        enable = true;
        debug = true;
        denominationConfig = lib.readFile ./taler-denominations.conf;
        # publicKeys = ./keys.json;
        # accounts = lib.readFile ./taler-accounts.conf;
      };
      libeufin.bank = {
        enable = true;
        debug = true;
      };
    };
}
