{
  config,
  ...
}:
{
  services.vikunja = {
    enable = true;
    port = 3456;
    frontendScheme = "http";
    frontendHostname = "vikunja.localhost";
  };

  services.caddy = {
    enable = true;
    virtualHosts."http://vikunja.localhost" = {
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString config.services.vikunja.port}
      '';
    };
  };
}
