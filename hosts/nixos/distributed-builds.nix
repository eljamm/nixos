{
  pkgs,
  ...
}:
{
  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;

  networking.extraHosts = ''
    192.168.1.143 arsene
    192.168.1.143 remotebuilder remotebuilder.local
    192.168.1.143 remotebuilder.cache remotebuilder.metrics
  '';

  nix.buildMachines = [
    {
      protocol = "ssh-ng";
      hostName = "remotebuilder.local";
      sshUser = "remotebuild";
      sshKey = "/root/.ssh/remotebuild";
      speedFactor = 5;
      systems = [
        "x86_64-linux"
        "i686-linux"
      ];
      supportedFeatures = [
        "nixos-test"
        "big-parallel"
        "kvm"
      ];
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpYQjAyMzE0UGFwR2U2T0JYdkwvQXhYcU9lL2plWVdKdGRoY1JHdHFBdDAgcm9vdEBhcnNlbmUK";
    }
  ];
}
