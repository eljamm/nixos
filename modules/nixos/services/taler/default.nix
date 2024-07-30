{ lib, pkgs, ... }:

let
  hostname = "192.168.1.120";
  currency = "KUDOS";
in

{
  services.taler = {
    settings = {
      taler = {
        CURRENCY = currency;
      };
    };
    includes = [ ./conf/taler-accounts.conf ];
    exchange = {
      enable = false;
      debug = true;
      denominationConfig = lib.readFile ./conf/taler-denominations.conf;
      enableAccounts = [ ./accounts/exchange.json ];
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
    enable = false;
    debug = true;
    settings = {
      libeufin-bank = {
        BIND_TO = hostname;
        CURRENCY = currency;
        PORT = 8082;
        # SUGGESTED_WITHDRAWAL_EXCHANGE = "http://${hostname}:8081/";
        WIRE_TYPE = "x-taler-bank";
        X_TALER_BANK_PAYTO_HOSTNAME = "http://192.168.1.120:8082/";
        DEFAULT_CUSTOMER_DEBT_LIMIT = "${currency}:200";
        DEFAULT_ADMIN_DEBT_LIMIT = "${currency}:2000";
        ALLOW_REGISTRATION = "yes";
        REGISTRATION_BONUS_ENABLED = "yes";
        REGISTRATION_BONUS = "${currency}:100";
      };
    };
  };
}
