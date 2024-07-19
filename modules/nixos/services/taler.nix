{ lib, pkgs, ... }:
let
  hostname = "192.168.1.120";
  currency = "KUDOS";
in

{
  services.taler = {
    enable = true;
    settings = {
      taler = {
        CURRENCY = currency;
      };
    };
    includes = [ ./taler-accounts.conf ];
    exchange = {
      enable = true;
      debug = true;
      denominationConfig = lib.readFile ./taler-denominations.conf;
      settings = {
        exchange = {
          BASE_URL = "http://${hostname}:8081/";
          HOSTNAME = hostname;
          PORT = 8081;
          MASTER_PUBLIC_KEY = "2TQSTPFZBC2MC4E52NHPA050YXYG02VC3AB50QESM6JX1QJEYVQ0";
        };
      };
    };
  };

  services.libeufin.bank = {
    enable = true;
    debug = true;
    settings = {
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
  };
}
