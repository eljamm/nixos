{
  pkgs,
  ...
}:
{
  systemd.packages = [ pkgs.anki-sync-server ];

  services.anki-sync-server = {
    enable = true;
    address = "0.0.0.0";
    openFirewall = true;
    users = [
      {
        username = "kuroko";
        passwordFile = "/etc/anki-sync-server/kuroko";
      }
    ];
  };
}
