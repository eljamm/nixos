{ username, ... }:
{
  services.xserver.wacom.enable = true;

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = username;
    group = "users";
    dataDir = "/home/${username}/syncthing";
  };
}
