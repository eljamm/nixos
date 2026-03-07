{
  lib,
  pkgs,
  username,
  ...
}:
{
  # Disable docker
  virtualisation.docker.enable = lib.mkDefault false;

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation.containers.storage.settings.storage.driver = "btrfs";

  virtualisation.podman = {
    enable = true;
    # Create a `docker` alias for podman, to use it as a drop-in replacement
    dockerCompat = true;
    # Required for containers under podman-compose to be able to talk to each other.
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
    podman-compose
  ];

  hardware.nvidia-container-toolkit.enable = true;

  users.users.${username}.extraGroups = [ "podman" ];
}
