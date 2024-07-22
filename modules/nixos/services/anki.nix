{ pkgs, ... }:

{
  systemd.packages = [ pkgs.anki-sync-server ];

  services.anki-sync-server = {
    enable = true;
    users = [
      {
        username = "kuroko";
        passwordFile = /etc/anki-sync-server/kuroko;
      }
    ];
    address = "0.0.0.0";
    port = 27701;
    openFirewall = true;
  };
}
