{
  pkgs,
  ...
}:
{
  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;

  networking.extraHosts = ''
    192.168.1.143 remotebuilder arsene
  '';

  nix.buildMachines = [
    {
      protocol = "ssh-ng";
      hostName = "remotebuilder";
      sshUser = "remotebuild";
      sshKey = "/root/.ssh/remotebuild";
      system = pkgs.stdenv.hostPlatform.system;
      supportedFeatures = [
        "nixos-test"
        "big-parallel"
        "kvm"
      ];
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpYQjAyMzE0UGFwR2U2T0JYdkwvQXhYcU9lL2plWVdKdGRoY1JHdHFBdDAgcm9vdEBhcnNlbmUK";
    }
  ];
}
