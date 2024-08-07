{ lib, pkgs, ... }:

let
  hostname = "192.168.1.120";
  CURRENCY = "KUDOS";
in

{
  services.taler = {
    settings = {
      taler = {
        inherit CURRENCY;
      };
    };
    includes = [ ./conf/taler-accounts.conf ];
    exchange = {
      enable = true;
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
    enable = true;
    debug = true;
    settings = {
      libeufin-bank = {
        BIND_TO = hostname;
        inherit CURRENCY;
        PORT = 8082;
        # SUGGESTED_WITHDRAWAL_EXCHANGE = "http://${hostname}:8081/";
        WIRE_TYPE = "x-taler-bank";
        X_TALER_BANK_PAYTO_HOSTNAME = "http://${hostname}:8082/";
        DEFAULT_CUSTOMER_DEBT_LIMIT = "${CURRENCY}:200";
        DEFAULT_ADMIN_DEBT_LIMIT = "${CURRENCY}:2000";
        ALLOW_REGISTRATION = "yes";
        REGISTRATION_BONUS_ENABLED = "yes";
        REGISTRATION_BONUS = "${CURRENCY}:100";
      };
    };
  };

  services.libeufin.nexus = {
    enable = true;
    debug = true;
    settings = {
      nexus-ebics = {
        CURRENCY = "KUDOS";

        # Bank
        HOST_BASE_URL = "http://${hostname}:8082/";
        BANK_DIALECT = "postfinance";

        # EBICS IDs
        HOST_ID = "PFEBICS";
        USER_ID = "PFC00563";
        PARTNER_ID = "PFC00563";

        # Account information
        IBAN = "CH7789144474425692816";
        BIC = "POFICHBEXXX";
        NAME = "John Smith S.A.";

        CLIENT_PRIVATE_KEYS_FILE = "/home/kuroko/.local/share/libeufin/client-ebics-keys.json";
      };
      libeufin-nexusdb-postgres.CONFIG = "postgresql:///libeufin-nexus";
    };
  };

}
