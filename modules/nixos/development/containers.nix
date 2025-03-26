{
  flake.nixosModules = {
    dev-podman =
      {
        lib,
        config,
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

        users.users.${username}.extraGroups = [ "podman" ];
      };
    dev-docker =
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
      };
    dev-lxd =
      { pkgs, username, ... }:
      {
        virtualisation.lxd.enable = true;
        virtualisation.lxd.recommendedSysctlSettings = true;

        users.users.${username}.extraGroups = [ "lxd" ];

        virtualisation.lxc = {
          enable = true;
          unprivilegedContainers = true;
          lxcfs.enable = true;
        };

        networking.firewall.trustedInterfaces = [ "lxdbr0" ];
      };
  };
}
