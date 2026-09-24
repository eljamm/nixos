{
  users.users.remotebuild = {
    isSystemUser = true;
    useDefaultShell = true;
    createHome = true;
    home = "/var/lib/remotebuild";
    group = "remotebuild";
    openssh.authorizedKeys.keyFiles = [
      ./remotebuild.pub
      ./remotebuild-kuroko.pub
    ];
  };

  users.groups.remotebuild = { };

  networking.extraHosts = ''
    127.0.0.1 remotebuilder remotebuilder.local
  '';

  nix = {
    nrBuildUsers = 64;
    settings = {
      trusted-users = [ "remotebuild" ];

      min-free = 10 * 1024 * 1024;
      max-free = 200 * 1024 * 1024;

      max-jobs = "auto";
      cores = 0;
    };
  };

  systemd.services.nix-daemon.serviceConfig = {
    MemoryAccounting = true;
    MemoryMax = "90%";
    OOMScoreAdjust = 500;
  };
}
