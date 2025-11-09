{ username, ... }:
{
  ## Music
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = username;
  };

  ## Books
  services.calibre-server = {
    enable = true;
    openFirewall = true;
    port = 8097;
    user = username;
    libraries = [ "/media/Calibre" ];
  };

  services.calibre-web = {
    enable = true;
    openFirewall = true;
    listen.port = 8098;
    listen.ip = "0.0.0.0";
    user = username;
    group = "calibre-server";
    options = {
      enableBookConversion = true;
      enableBookUploading = true;
      calibreLibrary = "/media/Calibre";
    };
  };

  services.kavita = {
    enable = true;
    settings.Port = 8099;
    tokenKeyFile = "/etc/secrets/kavita-token.key";
  };

  ## Manga
  # Use komga container instead of the NixOS module since it supports jxl
  # and avif out of the gate
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      komga = {
        image = "gotson/komga:latest";
        volumes = [
          "/media/.services/komga:/config"
          "/media/Manga:/data"
        ];
        ports = [ "8100:25600" ];
      };
    };
  };

  systemd.tmpfiles.settings = {
    "10-komga" = {
      "/media/Manga"."d" = {
        user = username;
        group = "users";
        mode = "0740";
      };
    };
  };

  # Open ports in the firewall
  networking.firewall.allowedTCPPorts = [
    8099 # kavita
    8100 # komga
  ];
}
