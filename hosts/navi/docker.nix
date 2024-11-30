{ username, ... }:
{
  # Enable rootless docker
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  users.users.${username}.extraGroups = [ "docker" ];
}
