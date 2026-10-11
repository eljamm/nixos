{
  config,
  ...
}:
{
  services.linkwarden = {
    enable = true;
    openFirewall = true;

    port = 47143;
    host = "127.0.0.1";

    enableRegistration = true;
    secretFiles = {
      NEXTAUTH_SECRET = "/run/credstore/linkwarden.secret";
    };

    environment = {
      NEXTAUTH_URL = "http://linkwarden.localhost/api/v1/auth";
      ALLOW_PRIVATE_NETWORK_ACCESS = "true"; # otherwise we cannot archive localhost
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts."http://linkwarden.localhost" = {
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString config.services.linkwarden.port}
      '';
    };
  };
}
